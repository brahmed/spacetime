part of 'teacher_home_bloc.dart';

sealed class TeacherHomeEvent extends Equatable {
  const TeacherHomeEvent();
}

final class TeacherHomeLoaded extends TeacherHomeEvent {
  const TeacherHomeLoaded({required this.teacherId});
  final String teacherId;

  @override
  List<Object?> get props => [teacherId];
}
