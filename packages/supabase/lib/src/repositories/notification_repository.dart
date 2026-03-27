import 'dart:developer';

import 'package:core/core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationRepository {
  NotificationRepository(this._supabase);

  final SupabaseClient _supabase;

  Future<List<AppNotification>> fetchNotificationsForUser(
    String userId,
  ) async {
    try {
      final data = await _supabase
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return data.map(AppNotification.fromJson).toList();
    } on PostgrestException catch (e, st) {
      log(
        'Failed to fetch notifications for user $userId',
        name: 'notifications',
        error: e,
        stackTrace: st,
      );
      throw NetworkException(e.message);
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _supabase
          .from('notifications')
          .update({'read': true})
          .eq('id', notificationId);
    } on PostgrestException catch (e, st) {
      log(
        'Failed to mark notification $notificationId as read',
        name: 'notifications',
        error: e,
        stackTrace: st,
      );
      throw NetworkException(e.message);
    }
  }

  Future<void> markAllAsRead(String userId) async {
    try {
      await _supabase
          .from('notifications')
          .update({'read': true})
          .eq('user_id', userId)
          .eq('read', false);
    } on PostgrestException catch (e, st) {
      log(
        'Failed to mark all notifications as read for user $userId',
        name: 'notifications',
        error: e,
        stackTrace: st,
      );
      throw NetworkException(e.message);
    }
  }
}
