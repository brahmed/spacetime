part of 'teacher_schedule_bloc.dart';

sealed class TeacherScheduleEvent extends Equatable {
  const TeacherScheduleEvent();
}

final class TeacherScheduleLoaded extends TeacherScheduleEvent {
  const TeacherScheduleLoaded({required this.teacherId});
  final String teacherId;

  @override
  List<Object?> get props => [teacherId];
}
