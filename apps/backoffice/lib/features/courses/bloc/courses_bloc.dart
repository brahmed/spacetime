import 'dart:developer';

import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_client/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Session;

part 'courses_event.dart';
part 'courses_state.dart';

class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  CoursesBloc({
    required CourseRepository courseRepository,
    required ProfileRepository profileRepository,
    required SupabaseClient supabase,
  })  : _courseRepository = courseRepository,
        _profileRepository = profileRepository,
        _supabase = supabase,
        super(const CoursesInitial()) {
    on<CoursesLoaded>(_onLoaded);
    on<CourseCreated>(_onCreated);
    on<CourseUpdated>(_onUpdated);
    on<CourseSessionsGenerated>(_onSessionsGenerated);
  }

  final CourseRepository _courseRepository;
  final ProfileRepository _profileRepository;
  final SupabaseClient _supabase;

  Future<void> _onLoaded(
    CoursesLoaded event,
    Emitter<CoursesState> emit,
  ) async {
    emit(const CoursesLoading());
    try {
      final courses = await _courseRepository.fetchAllCourses();
      final teachers =
          await _profileRepository.fetchProfilesByRole(UserRole.teacher);
      emit(CoursesSuccess(courses: courses, teachers: teachers));
    } catch (e, st) {
      log('Failed to load courses', name: 'courses', error: e, stackTrace: st);
      emit(const CoursesFailure());
    }
  }

  Future<void> _onCreated(
    CourseCreated event,
    Emitter<CoursesState> emit,
  ) async {
    final current = state;
    if (current is! CoursesSuccess) return;
    emit(CoursesSaving(courses: current.courses, teachers: current.teachers));
    try {
      final course = await _courseRepository.createCourse(
        name: event.name,
        discipline: event.discipline,
        room: event.room,
        teacherId: event.teacherId,
        recurrenceDays: event.recurrenceDays,
        recurrenceTime: event.recurrenceTime,
        recurrenceEndsAt: event.recurrenceEndsAt,
      );
      final updated = [...current.courses, course];
      emit(CoursesSaveSuccess(courses: updated, teachers: current.teachers));
    } catch (e, st) {
      log('Failed to create course', name: 'courses', error: e, stackTrace: st);
      emit(CoursesSaveFailure(
        courses: current.courses,
        teachers: current.teachers,
      ));
    }
  }

  Future<void> _onUpdated(
    CourseUpdated event,
    Emitter<CoursesState> emit,
  ) async {
    final current = state;
    if (current is! CoursesSuccess) return;
    emit(CoursesSaving(courses: current.courses, teachers: current.teachers));
    try {
      final course = await _courseRepository.updateCourse(
        courseId: event.courseId,
        name: event.name,
        discipline: event.discipline,
        room: event.room,
        teacherId: event.teacherId,
      );
      final updated = current.courses
          .map((c) => c.id == course.id ? course : c)
          .toList();
      emit(CoursesSaveSuccess(courses: updated, teachers: current.teachers));
    } catch (e, st) {
      log('Failed to update course', name: 'courses', error: e, stackTrace: st);
      emit(CoursesSaveFailure(
        courses: current.courses,
        teachers: current.teachers,
      ));
    }
  }

  Future<void> _onSessionsGenerated(
    CourseSessionsGenerated event,
    Emitter<CoursesState> emit,
  ) async {
    final current = state;
    if (current is! CoursesSuccess) return;
    emit(CoursesGeneratingSessions(
      courses: current.courses,
      teachers: current.teachers,
    ));
    try {
      await _supabase.functions.invoke(
        'generate-sessions',
        body: {'course_id': event.courseId},
      );
      emit(CoursesSessionsGenerated(
        courses: current.courses,
        teachers: current.teachers,
      ));
    } catch (e, st) {
      log(
        'Failed to generate sessions for course ${event.courseId}',
        name: 'courses',
        error: e,
        stackTrace: st,
      );
      emit(CoursesSessionsGenerateFailure(
        courses: current.courses,
        teachers: current.teachers,
      ));
    }
  }
}
