part of 'teacher_schedule_bloc.dart';

sealed class TeacherScheduleState extends Equatable {
  const TeacherScheduleState();
}

final class TeacherScheduleInitial extends TeacherScheduleState {
  const TeacherScheduleInitial();

  @override
  List<Object?> get props => [];
}

final class TeacherScheduleLoading extends TeacherScheduleState {
  const TeacherScheduleLoading();

  @override
  List<Object?> get props => [];
}

final class TeacherScheduleSuccess extends TeacherScheduleState {
  const TeacherScheduleSuccess({required this.sessions});
  final List<Session> sessions;

  @override
  List<Object?> get props => [sessions];
}

final class TeacherScheduleFailure extends TeacherScheduleState {
  const TeacherScheduleFailure();

  @override
  List<Object?> get props => [];
}
