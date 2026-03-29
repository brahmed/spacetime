part of 'teachers_bloc.dart';

sealed class TeachersEvent extends Equatable {
  const TeachersEvent();

  @override
  List<Object?> get props => [];
}

final class TeachersLoaded extends TeachersEvent {
  const TeachersLoaded();
}

final class TeacherAccountCreated extends TeachersEvent {
  const TeacherAccountCreated({
    required this.fullName,
    required this.email,
    required this.password,
  });

  final String fullName;
  final String email;
  final String password;

  @override
  List<Object?> get props => [fullName, email, password];
}

final class TeacherCourseAssigned extends TeachersEvent {
  const TeacherCourseAssigned({
    required this.teacherId,
    required this.courseId,
  });

  final String teacherId;
  final String courseId;

  @override
  List<Object?> get props => [teacherId, courseId];
}

final class TeacherCourseUnassigned extends TeachersEvent {
  const TeacherCourseUnassigned({required this.courseId});

  final String courseId;

  @override
  List<Object?> get props => [courseId];
}
