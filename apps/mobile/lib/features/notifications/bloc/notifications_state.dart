part of 'notifications_bloc.dart';

sealed class NotificationsState extends Equatable {
  const NotificationsState();
}

final class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();

  @override
  List<Object?> get props => [];
}

final class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();

  @override
  List<Object?> get props => [];
}

final class NotificationsSuccess extends NotificationsState {
  const NotificationsSuccess({required this.notifications});

  final List<AppNotification> notifications;

  @override
  List<Object?> get props => [notifications];
}

final class NotificationsFailure extends NotificationsState {
  const NotificationsFailure();

  @override
  List<Object?> get props => [];
}
