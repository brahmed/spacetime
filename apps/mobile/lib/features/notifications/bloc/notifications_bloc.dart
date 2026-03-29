import 'dart:developer';

import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_client/supabase.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc({required NotificationRepository notificationRepository})
      : _notificationRepository = notificationRepository,
        super(const NotificationsInitial()) {
    on<NotificationsLoaded>(_onLoaded);
    on<NotificationMarkedRead>(_onMarkedRead);
    on<NotificationsAllMarkedRead>(_onAllMarkedRead);
  }

  final NotificationRepository _notificationRepository;

  Future<void> _onLoaded(
    NotificationsLoaded event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(const NotificationsLoading());
    try {
      final notifications =
          await _notificationRepository.fetchNotificationsForUser(event.userId);
      emit(NotificationsSuccess(notifications: notifications));
    } catch (e, st) {
      log(
        'Failed to load notifications',
        name: 'notifications',
        error: e,
        stackTrace: st,
      );
      emit(const NotificationsFailure());
    }
  }

  Future<void> _onMarkedRead(
    NotificationMarkedRead event,
    Emitter<NotificationsState> emit,
  ) async {
    final current = state;
    if (current is! NotificationsSuccess) return;
    try {
      await _notificationRepository.markAsRead(event.notificationId);
      final updated = current.notifications.map((n) {
        return n.id == event.notificationId
            ? AppNotification(
                id: n.id,
                userId: n.userId,
                title: n.title,
                body: n.body,
                type: n.type,
                read: true,
                createdAt: n.createdAt,
              )
            : n;
      }).toList();
      emit(NotificationsSuccess(notifications: updated));
    } catch (e, st) {
      log(
        'Failed to mark notification as read',
        name: 'notifications',
        error: e,
        stackTrace: st,
      );
    }
  }

  Future<void> _onAllMarkedRead(
    NotificationsAllMarkedRead event,
    Emitter<NotificationsState> emit,
  ) async {
    final current = state;
    if (current is! NotificationsSuccess) return;
    try {
      await _notificationRepository.markAllAsRead(event.userId);
      final updated = current.notifications.map((n) {
        return AppNotification(
          id: n.id,
          userId: n.userId,
          title: n.title,
          body: n.body,
          type: n.type,
          read: true,
          createdAt: n.createdAt,
        );
      }).toList();
      emit(NotificationsSuccess(notifications: updated));
    } catch (e, st) {
      log(
        'Failed to mark all notifications as read',
        name: 'notifications',
        error: e,
        stackTrace: st,
      );
    }
  }
}
