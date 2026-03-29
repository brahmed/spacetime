import 'dart:developer';

import 'package:core/core.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Session;

class SessionRepository {
  SessionRepository(this._supabase);

  final SupabaseClient _supabase;

  Future<List<Session>> fetchSessionsByCourse(String courseId) async {
    try {
      final data = await _supabase
          .from('sessions')
          .select()
          .eq('course_id', courseId)
          .order('starts_at');
      return data.map(Session.fromJson).toList();
    } on PostgrestException catch (e, st) {
      log(
        'Failed to fetch sessions for course $courseId',
        name: 'sessions',
        error: e,
        stackTrace: st,
      );
      throw NetworkException(e.message);
    }
  }

  Future<List<Session>> fetchUpcomingSessionsForStudent(
    String studentId,
  ) async {
    try {
      final now = DateTime.now().toUtc().toIso8601String();
      final enrollments = await _supabase
          .from('enrollments')
          .select('course_id')
          .eq('student_id', studentId);
      final courseIds =
          enrollments.map<String>((e) => e['course_id'] as String).toList();
      if (courseIds.isEmpty) return [];

      final data = await _supabase
          .from('sessions')
          .select()
          .inFilter('course_id', courseIds)
          .gte('starts_at', now)
          .eq('status', 'scheduled')
          .order('starts_at');
      return data.map(Session.fromJson).toList();
    } on PostgrestException catch (e, st) {
      log(
        'Failed to fetch upcoming sessions for student $studentId',
        name: 'sessions',
        error: e,
        stackTrace: st,
      );
      throw NetworkException(e.message);
    }
  }

  Future<List<Session>> fetchUpcomingSessionsForTeacher(
    String teacherId,
  ) async {
    try {
      final now = DateTime.now().toUtc().toIso8601String();
      // Fetch course_ids for this teacher first, then filter sessions.
      final courses = await _supabase
          .from('courses')
          .select('id')
          .eq('teacher_id', teacherId);
      final courseIds =
          courses.map<String>((c) => c['id'] as String).toList();
      if (courseIds.isEmpty) return [];

      final data = await _supabase
          .from('sessions')
          .select()
          .inFilter('course_id', courseIds)
          .gte('starts_at', now)
          .order('starts_at');
      return data.map(Session.fromJson).toList();
    } on PostgrestException catch (e, st) {
      log(
        'Failed to fetch sessions for teacher $teacherId',
        name: 'sessions',
        error: e,
        stackTrace: st,
      );
      throw NetworkException(e.message);
    }
  }

  Future<Session> fetchSession(String sessionId) async {
    try {
      final data = await _supabase
          .from('sessions')
          .select()
          .eq('id', sessionId)
          .single();
      return Session.fromJson(data);
    } on PostgrestException catch (e, st) {
      log(
        'Failed to fetch session $sessionId',
        name: 'sessions',
        error: e,
        stackTrace: st,
      );
      throw NetworkException(e.message);
    }
  }

  Future<Session> cancelSession(String sessionId) async {
    try {
      final data = await _supabase
          .from('sessions')
          .update({'status': 'cancelled'})
          .eq('id', sessionId)
          .select()
          .single();
      return Session.fromJson(data);
    } on PostgrestException catch (e, st) {
      log(
        'Failed to cancel session $sessionId',
        name: 'sessions',
        error: e,
        stackTrace: st,
      );
      throw NetworkException(e.message);
    }
  }

  Future<int> cancelAllFutureSessions(String courseId) async {
    try {
      final now = DateTime.now().toUtc().toIso8601String();
      final result = await _supabase
          .from('sessions')
          .update({'status': 'cancelled'})
          .eq('course_id', courseId)
          .gte('starts_at', now)
          .eq('status', 'scheduled')
          .select('id');
      return result.length;
    } on PostgrestException catch (e, st) {
      log(
        'Failed to cancel future sessions for course $courseId',
        name: 'sessions',
        error: e,
        stackTrace: st,
      );
      throw NetworkException(e.message);
    }
  }

  Future<Session> updateSession({
    required String sessionId,
    String? room,
    DateTime? startsAt,
    DateTime? endsAt,
  }) async {
    try {
      final data = await _supabase
          .from('sessions')
          .update({
            if (room != null) 'room': room,
            if (startsAt != null) 'starts_at': startsAt.toIso8601String(),
            if (endsAt != null) 'ends_at': endsAt.toIso8601String(),
          })
          .eq('id', sessionId)
          .select()
          .single();
      return Session.fromJson(data);
    } on PostgrestException catch (e, st) {
      log(
        'Failed to update session $sessionId',
        name: 'sessions',
        error: e,
        stackTrace: st,
      );
      throw NetworkException(e.message);
    }
  }

  Future<List<Session>> fetchTodaySessions() async {
    try {
      final now = DateTime.now();
      final startOfDay =
          DateTime(now.year, now.month, now.day).toUtc().toIso8601String();
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59)
          .toUtc()
          .toIso8601String();
      final data = await _supabase
          .from('sessions')
          .select()
          .gte('starts_at', startOfDay)
          .lte('starts_at', endOfDay);
      return data.map(Session.fromJson).toList();
    } on PostgrestException catch (e, st) {
      log(
        'Failed to fetch today\'s sessions',
        name: 'sessions',
        error: e,
        stackTrace: st,
      );
      throw NetworkException(e.message);
    }
  }

  /// Streams real-time attendance updates for a specific session.
  Stream<List<Map<String, dynamic>>> streamAttendanceForSession(
    String sessionId,
  ) =>
      _supabase
          .from('attendance')
          .stream(primaryKey: ['id']).eq('session_id', sessionId);
}
