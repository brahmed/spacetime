import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_client/supabase.dart';

/// Handles FCM token lifecycle and foreground notification display.
///
/// Call [init] once after Firebase is initialized (before [runApp]).
/// Call [saveTokenForUser] after login, [removeTokenForUser] before logout.
class FcmService {
  FcmService._();

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const _androidChannel = AndroidNotificationChannel(
    'spacetime_default',
    'SpaceTime',
    description: 'SpaceTime class notifications',
    importance: Importance.high,
  );

  /// Must be called at top-level (not inside a widget) so the background
  /// isolate can reach it via a @pragma('vm:entry-point') annotation.
  static Future<void> init() async {
    // Request permission
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Set up local notifications for foreground display
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    await _localNotifications.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );

    // Create the Android notification channel
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);

    // Show a local notification when the app is in the foreground
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;

      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(),
        ),
      );
    });
  }

  /// Saves the current FCM token for [userId] and listens for token refreshes.
  static Future<void> saveTokenForUser({
    required String userId,
    required DeviceTokenRepository repository,
  }) async {
    // On iOS, APNS token must be available before FCM token can be fetched.
    // This may not be available on simulators.
    if (Platform.isIOS) {
      final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      if (apnsToken == null) return;
    }
    final token = await FirebaseMessaging.instance.getToken();
    if (token == null) return;

    final platform = Platform.isIOS ? 'ios' : 'android';
    try {
      await repository.upsertToken(
        userId: userId,
        token: token,
        platform: platform,
      );
      log('FCM token saved for user $userId', name: 'fcm');
    } catch (e, st) {
      log('Failed to save FCM token', name: 'fcm', error: e, stackTrace: st);
    }

    // Keep the token up to date if Firebase rotates it
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      try {
        await repository.upsertToken(
          userId: userId,
          token: newToken,
          platform: platform,
        );
        log('FCM token refreshed for user $userId', name: 'fcm');
      } catch (e, st) {
        log(
          'Failed to refresh FCM token',
          name: 'fcm',
          error: e,
          stackTrace: st,
        );
      }
    });
  }

  /// Removes the FCM token from Supabase on sign-out.
  static Future<void> removeTokenForUser({
    required String userId,
    required DeviceTokenRepository repository,
  }) async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token == null) return;
    try {
      await repository.removeToken(userId: userId, token: token);
      log('FCM token removed for user $userId', name: 'fcm');
    } catch (e, st) {
      log('Failed to remove FCM token', name: 'fcm', error: e, stackTrace: st);
    }
  }
}

/// Top-level background message handler.
/// Must be a top-level function annotated with @pragma('vm:entry-point').
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Firebase is already initialized in the background isolate by FlutterFire.
  log(
    'Background FCM message received: ${message.messageId}',
    name: 'fcm',
  );
}
