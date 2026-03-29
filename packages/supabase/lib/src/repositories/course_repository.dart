import 'dart:developer';

import 'package:core/core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CourseRepository {
  CourseRepository(this._supabase);

  final SupabaseClient _supabase;

  Future<List<Course>> fetchAllCourses() async {
    try {
      final data = await _supabase.from('courses').select();
      return data.map(Course.fromJson).toList();
    } on PostgrestException catch (e, st) {
      log('Failed to fetch courses', name: 'courses', error: e, stackTrace: st);
      throw NetworkException(e.message);
    }
  }

  Future<List<Course>> fetchCoursesByTeacher(String teacherId) async {
    try {
      final data = await _supabase
          .from('courses')
          .select()
          .eq('teacher_id', teacherId);
      return data.map(Course.fromJson).toList();
    } on PostgrestException catch (e, st) {
      log(
        'Failed to fetch courses for teacher $teacherId',
        name: 'courses',
        error: e,
        stackTrace: st,
      );
      throw NetworkException(e.message);
    }
  }

  Future<Course> fetchCourse(String courseId) async {
    try {
      final data = await _supabase
          .from('courses')
          .select()
          .eq('id', courseId)
          .single();
      return Course.fromJson(data);
    } on PostgrestException catch (e, st) {
      log(
        'Failed to fetch course $courseId',
        name: 'courses',
        error: e,
        stackTrace: st,
      );
      throw NetworkException(e.message);
    }
  }

  Future<Course> createCourse({
    required String name,
    String? discipline,
    String? room,
    String? teacherId,
    required List<int> recurrenceDays,
    required String recurrenceTime,
    DateTime? recurrenceEndsAt,
  }) async {
    try {
      final data = await _supabase
          .from('courses')
          .insert({
            'name': name,
            'discipline': discipline,
            'room': room,
            'teacher_id': teacherId,
            'recurrence_days': recurrenceDays,
            'recurrence_time': recurrenceTime,
            'recurrence_ends_at': recurrenceEndsAt?.toIso8601String(),
          })
          .select()
          .single();
      return Course.fromJson(data);
    } on PostgrestException catch (e, st) {
      log('Failed to create course', name: 'courses', error: e, stackTrace: st);
      throw NetworkException(e.message);
    }
  }

  Future<Course> unassignTeacher(String courseId) async {
    try {
      final data = await _supabase
          .from('courses')
          .update({'teacher_id': null})
          .eq('id', courseId)
          .select()
          .single();
      return Course.fromJson(data);
    } on PostgrestException catch (e, st) {
      log(
        'Failed to unassign teacher from course $courseId',
        name: 'courses',
        error: e,
        stackTrace: st,
      );
      throw NetworkException(e.message);
    }
  }

  Future<Course> updateCourse({
    required String courseId,
    String? name,
    String? discipline,
    String? room,
    String? teacherId,
  }) async {
    try {
      final data = await _supabase
          .from('courses')
          .update({
            if (name != null) 'name': name,
            if (discipline != null) 'discipline': discipline,
            if (room != null) 'room': room,
            if (teacherId != null) 'teacher_id': teacherId,
          })
          .eq('id', courseId)
          .select()
          .single();
      return Course.fromJson(data);
    } on PostgrestException catch (e, st) {
      log(
        'Failed to update course $courseId',
        name: 'courses',
        error: e,
        stackTrace: st,
      );
      throw NetworkException(e.message);
    }
  }
}
