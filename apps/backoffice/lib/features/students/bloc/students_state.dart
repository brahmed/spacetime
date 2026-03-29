part of 'students_bloc.dart';

sealed class StudentsState extends Equatable {
  const StudentsState();

  @override
  List<Object?> get props => [];
}

final class StudentsInitial extends StudentsState {
  const StudentsInitial();
}

final class StudentsLoading extends StudentsState {
  const StudentsLoading();
}

final class StudentsFailure extends StudentsState {
  const StudentsFailure();
}

base class StudentsSuccess extends StudentsState {
  const StudentsSuccess({
    required this.students,
    required this.courses,
    required this.enrollmentsByCourse,
  });

  final List<Profile> students;
  final List<Course> courses;

  /// courseId → list of studentIds enrolled
  final Map<String, List<String>> enrollmentsByCourse;

  @override
  List<Object?> get props => [students, courses, enrollmentsByCourse];
}

final class StudentsSaving extends StudentsSuccess {
  const StudentsSaving({
    required super.students,
    required super.courses,
    required super.enrollmentsByCourse,
  });
}

final class StudentCreateSuccess extends StudentsSuccess {
  const StudentCreateSuccess({
    required super.students,
    required super.courses,
    required super.enrollmentsByCourse,
  });
}

final class StudentCreateFailure extends StudentsSuccess {
  const StudentCreateFailure({
    required super.students,
    required super.courses,
    required super.enrollmentsByCourse,
  });
}

final class StudentEnrollSuccess extends StudentsSuccess {
  const StudentEnrollSuccess({
    required super.students,
    required super.courses,
    required super.enrollmentsByCourse,
  });
}

final class StudentEnrollFailure extends StudentsSuccess {
  const StudentEnrollFailure({
    required super.students,
    required super.courses,
    required super.enrollmentsByCourse,
  });
}

final class StudentUnenrollSuccess extends StudentsSuccess {
  const StudentUnenrollSuccess({
    required super.students,
    required super.courses,
    required super.enrollmentsByCourse,
  });
}

final class StudentUnenrollFailure extends StudentsSuccess {
  const StudentUnenrollFailure({
    required super.students,
    required super.courses,
    required super.enrollmentsByCourse,
  });
}
