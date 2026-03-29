part of 'sessions_bloc.dart';

sealed class SessionsState extends Equatable {
  const SessionsState();

  @override
  List<Object?> get props => [];
}

final class SessionsInitial extends SessionsState {
  const SessionsInitial();
}

final class SessionsLoading extends SessionsState {
  const SessionsLoading();
}

final class SessionsFailure extends SessionsState {
  const SessionsFailure();
}

base class SessionsSuccess extends SessionsState {
  const SessionsSuccess({required this.sessions, required this.courseId});

  final List<Session> sessions;
  final String courseId;

  @override
  List<Object?> get props => [sessions, courseId];
}

final class SessionsUpdating extends SessionsSuccess {
  const SessionsUpdating({required super.sessions, required super.courseId});
}

final class SessionCancelSuccess extends SessionsSuccess {
  const SessionCancelSuccess({
    required super.sessions,
    required super.courseId,
  });
}

final class SessionCancelFailure extends SessionsSuccess {
  const SessionCancelFailure({
    required super.sessions,
    required super.courseId,
  });
}

final class SessionAllFutureCancelSuccess extends SessionsSuccess {
  const SessionAllFutureCancelSuccess({
    required super.sessions,
    required super.courseId,
    required this.cancelledCount,
  });

  final int cancelledCount;

  @override
  List<Object?> get props => [sessions, courseId, cancelledCount];
}

final class SessionAllFutureCancelFailure extends SessionsSuccess {
  const SessionAllFutureCancelFailure({
    required super.sessions,
    required super.courseId,
  });
}

final class SessionUpdateSuccess extends SessionsSuccess {
  const SessionUpdateSuccess({
    required super.sessions,
    required super.courseId,
  });
}

final class SessionUpdateFailure extends SessionsSuccess {
  const SessionUpdateFailure({
    required super.sessions,
    required super.courseId,
  });
}
