part of 'sessions_bloc.dart';

sealed class SessionsEvent extends Equatable {
  const SessionsEvent();

  @override
  List<Object?> get props => [];
}

final class SessionsLoaded extends SessionsEvent {
  const SessionsLoaded({required this.courseId});

  final String courseId;

  @override
  List<Object?> get props => [courseId];
}

final class SessionCancelRequested extends SessionsEvent {
  const SessionCancelRequested({required this.sessionId});

  final String sessionId;

  @override
  List<Object?> get props => [sessionId];
}

final class SessionAllFutureCancelRequested extends SessionsEvent {
  const SessionAllFutureCancelRequested({required this.courseId});

  final String courseId;

  @override
  List<Object?> get props => [courseId];
}

final class SessionUpdateRequested extends SessionsEvent {
  const SessionUpdateRequested({
    required this.sessionId,
    this.room,
    this.startsAt,
    this.endsAt,
  });

  final String sessionId;
  final String? room;
  final DateTime? startsAt;
  final DateTime? endsAt;

  @override
  List<Object?> get props => [sessionId, room, startsAt, endsAt];
}
