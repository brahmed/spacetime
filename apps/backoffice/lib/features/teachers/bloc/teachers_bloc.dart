import 'dart:developer';

import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_client/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Session;

part 'teachers_event.dart';
part 'teachers_state.dart';

class TeachersBloc extends Bloc<TeachersEvent, TeachersState> {
  TeachersBloc({
    required ProfileRepository profileRepository,
    required CourseRepository courseRepository,
    required SupabaseClient supabase,
  })  : _profileRepository = profileRepository,
        _courseRepository = courseRepository,
        _supabase = supabase,
        super(const TeachersInitial()) {
    on<TeachersLoaded>(_onLoaded);
    on<TeacherAccountCreated>(_onAccountCreated);
    on<TeacherCourseAssigned>(_onCourseAssigned);
  }

  final ProfileRepository _profileRepository;
  final CourseRepository _courseRepository;
  final SupabaseClient _supabase;

  Future<void> _onLoaded(
    TeachersLoaded event,
    Emitter<TeachersState> emit,
  ) async {
    emit(const TeachersLoading());
    try {
      final teachers =
          await _profileRepository.fetchProfilesByRole(UserRole.teacher);
      final courses = await _courseRepository.fetchAllCourses();
      emit(TeachersSuccess(teachers: teachers, courses: courses));
    } catch (e, st) {
      log('Failed to load teachers', name: 'teachers', error: e, stackTrace: st);
      emit(const TeachersFailure());
    }
  }

  Future<void> _onAccountCreated(
    TeacherAccountCreated event,
    Emitter<TeachersState> emit,
  ) async {
    final current = state;
    if (current is! TeachersSuccess) return;
    emit(TeachersSaving(teachers: current.teachers, courses: current.courses));
    try {
      await _supabase.functions.invoke(
        'create-user',
        body: {
          'full_name': event.fullName,
          'email': event.email,
          'password': event.password,
          'role': 'teacher',
        },
      );
      final teachers =
          await _profileRepository.fetchProfilesByRole(UserRole.teacher);
      emit(TeacherCreateSuccess(teachers: teachers, courses: current.courses));
    } catch (e, st) {
      log(
        'Failed to create teacher account',
        name: 'teachers',
        error: e,
        stackTrace: st,
      );
      emit(TeacherCreateFailure(
        teachers: current.teachers,
        courses: current.courses,
      ));
    }
  }

  Future<void> _onCourseAssigned(
    TeacherCourseAssigned event,
    Emitter<TeachersState> emit,
  ) async {
    final current = state;
    if (current is! TeachersSuccess) return;
    emit(TeachersSaving(teachers: current.teachers, courses: current.courses));
    try {
      final updated = await _courseRepository.updateCourse(
        courseId: event.courseId,
        teacherId: event.teacherId,
      );
      final courses = current.courses
          .map((c) => c.id == updated.id ? updated : c)
          .toList();
      emit(TeacherAssignSuccess(teachers: current.teachers, courses: courses));
    } catch (e, st) {
      log(
        'Failed to assign course ${event.courseId} to teacher ${event.teacherId}',
        name: 'teachers',
        error: e,
        stackTrace: st,
      );
      emit(TeacherAssignFailure(
        teachers: current.teachers,
        courses: current.courses,
      ));
    }
  }
}
