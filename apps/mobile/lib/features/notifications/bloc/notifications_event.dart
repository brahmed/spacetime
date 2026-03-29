part of 'notifications_bloc.dart';

sealed class NotificationsEvent extends Equatable {
  const NotificationsEvent();
}

final class NotificationsLoaded extends NotificationsEvent {
  const NotificationsLoaded({required this.userId});

  final String userId;

  @override
  List<Object?> get props => [userId];
}

final class NotificationMarkedRead extends NotificationsEvent {
  const NotificationMarkedRead({required this.notificationId});

  final String notificationId;

  @override
  List<Object?> get props => [notificationId];
}

final class NotificationsAllMarkedRead extends NotificationsEvent {
  const NotificationsAllMarkedRead({required this.userId});

  final String userId;

  @override
  List<Object?> get props => [userId];
}
