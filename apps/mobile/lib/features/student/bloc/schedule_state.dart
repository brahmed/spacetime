part of 'schedule_bloc.dart';

sealed class ScheduleState extends Equatable {
  const ScheduleState();
}

final class ScheduleInitial extends ScheduleState {
  const ScheduleInitial();

  @override
  List<Object?> get props => [];
}

final class ScheduleLoading extends ScheduleState {
  const ScheduleLoading();

  @override
  List<Object?> get props => [];
}

final class ScheduleSuccess extends ScheduleState {
  const ScheduleSuccess({required this.sessions});

  final List<Session> sessions;

  @override
  List<Object?> get props => [sessions];
}

final class ScheduleFailure extends ScheduleState {
  const ScheduleFailure();

  @override
  List<Object?> get props => [];
}
