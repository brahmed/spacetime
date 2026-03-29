part of 'courses_bloc.dart';

sealed class CoursesState extends Equatable {
  const CoursesState();

  @override
  List<Object?> get props => [];
}

final class CoursesInitial extends CoursesState {
  const CoursesInitial();
}

final class CoursesLoading extends CoursesState {
  const CoursesLoading();
}

final class CoursesFailure extends CoursesState {
  const CoursesFailure();
}

base class CoursesSuccess extends CoursesState {
  const CoursesSuccess({required this.courses, required this.teachers});

  final List<Course> courses;
  final List<Profile> teachers;

  @override
  List<Object?> get props => [courses, teachers];
}

final class CoursesSaving extends CoursesSuccess {
  const CoursesSaving({required super.courses, required super.teachers});
}

final class CoursesSaveSuccess extends CoursesSuccess {
  const CoursesSaveSuccess({required super.courses, required super.teachers});
}

final class CoursesSaveFailure extends CoursesSuccess {
  const CoursesSaveFailure({required super.courses, required super.teachers});
}

final class CoursesGeneratingSessions extends CoursesSuccess {
  const CoursesGeneratingSessions({
    required super.courses,
    required super.teachers,
  });
}

final class CoursesSessionsGenerated extends CoursesSuccess {
  const CoursesSessionsGenerated({
    required super.courses,
    required super.teachers,
  });
}

final class CoursesSessionsGenerateFailure extends CoursesSuccess {
  const CoursesSessionsGenerateFailure({
    required super.courses,
    required super.teachers,
  });
}
