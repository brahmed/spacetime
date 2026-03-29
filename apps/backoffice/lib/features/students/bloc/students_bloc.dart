import 'dart:developer';

import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_client/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Session;

part 'students_event.dart';
part 'students_state.dart';

class StudentsBloc extends Bloc<StudentsEvent, StudentsState> {
  StudentsBloc({
    required ProfileRepository profileRepository,
    required CourseRepository courseRepository,
    required EnrollmentRepository enrollmentRepository,
    required SupabaseClient supabase,
  })  : _profileRepository = profileRepository,
        _courseRepository = courseRepository,
        _enrollmentRepository = enrollmentRepository,
        _supabase = supabase,
        super(const StudentsInitial()) {
    on<StudentsLoaded>(_onLoaded);
    on<StudentAccountCreated>(_onAccountCreated);
    on<StudentEnrolled>(_onEnrolled);
    on<StudentUnenrolled>(_onUnenrolled);
  }

  final ProfileRepository _profileRepository;
  final CourseRepository _courseRepository;
  final EnrollmentRepository _enrollmentRepository;
  final SupabaseClient _supabase;

  Future<void> _onLoaded(
    StudentsLoaded event,
    Emitter<StudentsState> emit,
  ) async {
    emit(const StudentsLoading());
    try {
      final students =
          await _profileRepository.fetchProfilesByRole(UserRole.student);
      final courses = await _courseRepository.fetchAllCourses();

      final enrollmentsByCourse = <String, List<String>>{};
      for (final course in courses) {
        final enrollments =
            await _enrollmentRepository.fetchEnrollmentsByCourse(course.id);
        enrollmentsByCourse[course.id] =
            enrollments.map((e) => e.studentId).toList();
      }

      emit(StudentsSuccess(
        students: students,
        courses: courses,
        enrollmentsByCourse: enrollmentsByCourse,
      ));
    } catch (e, st) {
      log('Failed to load students', name: 'students', error: e, stackTrace: st);
      emit(const StudentsFailure());
    }
  }

  Future<void> _onAccountCreated(
    StudentAccountCreated event,
    Emitter<StudentsState> emit,
  ) async {
    final current = state;
    if (current is! StudentsSuccess) return;
    emit(StudentsSaving(
      students: current.students,
      courses: current.courses,
      enrollmentsByCourse: current.enrollmentsByCourse,
    ));
    try {
      await _supabase.functions.invoke(
        'create-user',
        body: {
          'full_name': event.fullName,
          'email': event.email,
          'password': event.password,
          'role': 'student',
        },
      );
      final students =
          await _profileRepository.fetchProfilesByRole(UserRole.student);
      emit(StudentCreateSuccess(
        students: students,
        courses: current.courses,
        enrollmentsByCourse: current.enrollmentsByCourse,
      ));
    } catch (e, st) {
      log(
        'Failed to create student account',
        name: 'students',
        error: e,
        stackTrace: st,
      );
      emit(StudentCreateFailure(
        students: current.students,
        courses: current.courses,
        enrollmentsByCourse: current.enrollmentsByCourse,
      ));
    }
  }

  Future<void> _onEnrolled(
    StudentEnrolled event,
    Emitter<StudentsState> emit,
  ) async {
    final current = state;
    if (current is! StudentsSuccess) return;
    emit(StudentsSaving(
      students: current.students,
      courses: current.courses,
      enrollmentsByCourse: current.enrollmentsByCourse,
    ));
    try {
      await _enrollmentRepository.enroll(
        courseId: event.courseId,
        studentId: event.studentId,
      );
      final updated = Map<String, List<String>>.from(
        current.enrollmentsByCourse,
      );
      updated[event.courseId] = [
        ...?updated[event.courseId],
        event.studentId,
      ];
      emit(StudentEnrollSuccess(
        students: current.students,
        courses: current.courses,
        enrollmentsByCourse: updated,
      ));
    } catch (e, st) {
      log(
        'Failed to enroll student ${event.studentId}',
        name: 'students',
        error: e,
        stackTrace: st,
      );
      emit(StudentEnrollFailure(
        students: current.students,
        courses: current.courses,
        enrollmentsByCourse: current.enrollmentsByCourse,
      ));
    }
  }

  Future<void> _onUnenrolled(
    StudentUnenrolled event,
    Emitter<StudentsState> emit,
  ) async {
    final current = state;
    if (current is! StudentsSuccess) return;
    emit(StudentsSaving(
      students: current.students,
      courses: current.courses,
      enrollmentsByCourse: current.enrollmentsByCourse,
    ));
    try {
      await _enrollmentRepository.unenroll(
        courseId: event.courseId,
        studentId: event.studentId,
      );
      final updated = Map<String, List<String>>.from(
        current.enrollmentsByCourse,
      );
      updated[event.courseId] =
          (updated[event.courseId] ?? [])
              .where((id) => id != event.studentId)
              .toList();
      emit(StudentUnenrollSuccess(
        students: current.students,
        courses: current.courses,
        enrollmentsByCourse: updated,
      ));
    } catch (e, st) {
      log(
        'Failed to unenroll student ${event.studentId}',
        name: 'students',
        error: e,
        stackTrace: st,
      );
      emit(StudentUnenrollFailure(
        students: current.students,
        courses: current.courses,
        enrollmentsByCourse: current.enrollmentsByCourse,
      ));
    }
  }
}
