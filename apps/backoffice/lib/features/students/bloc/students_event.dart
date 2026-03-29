part of 'students_bloc.dart';

sealed class StudentsEvent extends Equatable {
  const StudentsEvent();

  @override
  List<Object?> get props => [];
}

final class StudentsLoaded extends StudentsEvent {
  const StudentsLoaded();
}

final class StudentAccountCreated extends StudentsEvent {
  const StudentAccountCreated({
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

final class StudentEnrolled extends StudentsEvent {
  const StudentEnrolled({
    required this.studentId,
    required this.courseId,
  });

  final String studentId;
  final String courseId;

  @override
  List<Object?> get props => [studentId, courseId];
}

final class StudentUnenrolled extends StudentsEvent {
  const StudentUnenrolled({
    required this.studentId,
    required this.courseId,
  });

  final String studentId;
  final String courseId;

  @override
  List<Object?> get props => [studentId, courseId];
}
