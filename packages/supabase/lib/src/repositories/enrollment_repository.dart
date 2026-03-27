import 'dart:developer';

import 'package:core/core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EnrollmentRepository {
  EnrollmentRepository(this._supabase);

  final SupabaseClient _supabase;

  Future<List<Enrollment>> fetchEnrollmentsByCourse(String courseId) async {
    try {
      final data = await _supabase
          .from('enrollments')
          .select()
          .eq('course_id', courseId);
      return data.map(Enrollment.fromJson).toList();
    } on PostgrestException catch (e, st) {
      log(
        'Failed to fetch enrollments for course $courseId',
        name: 'enrollments',
        error: e,
        stackTrace: st,
      );
      throw NetworkException(e.message);
    }
  }

  Future<List<Enrollment>> fetchEnrollmentsByStudent(String studentId) async {
    try {
      final data = await _supabase
          .from('enrollments')
          .select()
          .eq('student_id', studentId);
      return data.map(Enrollment.fromJson).toList();
    } on PostgrestException catch (e, st) {
      log(
        'Failed to fetch enrollments for student $studentId',
        name: 'enrollments',
        error: e,
        stackTrace: st,
      );
      throw NetworkException(e.message);
    }
  }

  Future<Enrollment> enroll({
    required String courseId,
    required String studentId,
  }) async {
    try {
      final data = await _supabase
          .from('enrollments')
          .insert({'course_id': courseId, 'student_id': studentId})
          .select()
          .single();
      return Enrollment.fromJson(data);
    } on PostgrestException catch (e, st) {
      log(
        'Failed to enroll student $studentId in course $courseId',
        name: 'enrollments',
        error: e,
        stackTrace: st,
      );
      throw NetworkException(e.message);
    }
  }

  Future<void> unenroll({
    required String courseId,
    required String studentId,
  }) async {
    try {
      await _supabase
          .from('enrollments')
          .delete()
          .eq('course_id', courseId)
          .eq('student_id', studentId);
    } on PostgrestException catch (e, st) {
      log(
        'Failed to unenroll student $studentId from course $courseId',
        name: 'enrollments',
        error: e,
        stackTrace: st,
      );
      throw NetworkException(e.message);
    }
  }
}
