part of 'schedule_bloc.dart';

sealed class ScheduleEvent extends Equatable {
  const ScheduleEvent();
}

final class ScheduleLoaded extends ScheduleEvent {
  const ScheduleLoaded({required this.studentId});

  final String studentId;

  @override
  List<Object?> get props => [studentId];
}
