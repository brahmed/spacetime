part of 'teachers_bloc.dart';

sealed class TeachersState extends Equatable {
  const TeachersState();

  @override
  List<Object?> get props => [];
}

final class TeachersInitial extends TeachersState {
  const TeachersInitial();
}

final class TeachersLoading extends TeachersState {
  const TeachersLoading();
}

final class TeachersFailure extends TeachersState {
  const TeachersFailure();
}

base class TeachersSuccess extends TeachersState {
  const TeachersSuccess({
    required this.teachers,
    required this.courses,
  });

  final List<Profile> teachers;
  final List<Course> courses;

  @override
  List<Object?> get props => [teachers, courses];
}

final class TeachersSaving extends TeachersSuccess {
  const TeachersSaving({required super.teachers, required super.courses});
}

final class TeacherCreateSuccess extends TeachersSuccess {
  const TeacherCreateSuccess({
    required super.teachers,
    required super.courses,
  });
}

final class TeacherCreateFailure extends TeachersSuccess {
  const TeacherCreateFailure({
    required super.teachers,
    required super.courses,
  });
}

final class TeacherAssignSuccess extends TeachersSuccess {
  const TeacherAssignSuccess({
    required super.teachers,
    required super.courses,
  });
}

final class TeacherAssignFailure extends TeachersSuccess {
  const TeacherAssignFailure({
    required super.teachers,
    required super.courses,
  });
}

final class TeacherUnassignSuccess extends TeachersSuccess {
  const TeacherUnassignSuccess({
    required super.teachers,
    required super.courses,
  });
}

final class TeacherUnassignFailure extends TeachersSuccess {
  const TeacherUnassignFailure({
    required super.teachers,
    required super.courses,
  });
}
