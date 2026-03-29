part of 'courses_bloc.dart';

sealed class CoursesEvent extends Equatable {
  const CoursesEvent();

  @override
  List<Object?> get props => [];
}

final class CoursesLoaded extends CoursesEvent {
  const CoursesLoaded();
}

final class CourseCreated extends CoursesEvent {
  const CourseCreated({
    required this.name,
    this.discipline,
    this.room,
    this.teacherId,
    required this.recurrenceDays,
    required this.recurrenceTime,
    this.recurrenceEndsAt,
  });

  final String name;
  final String? discipline;
  final String? room;
  final String? teacherId;
  final List<int> recurrenceDays;
  final String recurrenceTime;
  final DateTime? recurrenceEndsAt;

  @override
  List<Object?> get props => [
        name,
        discipline,
        room,
        teacherId,
        recurrenceDays,
        recurrenceTime,
        recurrenceEndsAt,
      ];
}

final class CourseUpdated extends CoursesEvent {
  const CourseUpdated({
    required this.courseId,
    this.name,
    this.discipline,
    this.room,
    this.teacherId,
  });

  final String courseId;
  final String? name;
  final String? discipline;
  final String? room;
  final String? teacherId;

  @override
  List<Object?> get props => [courseId, name, discipline, room, teacherId];
}

final class CourseSessionsGenerated extends CoursesEvent {
  const CourseSessionsGenerated({required this.courseId});

  final String courseId;

  @override
  List<Object?> get props => [courseId];
}
