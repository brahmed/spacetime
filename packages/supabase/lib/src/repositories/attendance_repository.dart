import 'dart:developer';

import 'package:core/core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AttendanceRepository {
  AttendanceRepository(this._supabase);

  final SupabaseClient _supabase;

  Future<List<Attendance>> fetchAttendanceForSession(
    String sessionId,
  ) async {
    try {
      final data = await _supabase
          .from('attendance')
          .select()
          .eq('session_id', sessionId);
      return data.map(Attendance.fromJson).toList();
    } on PostgrestException catch (e, st) {
      log(
        'Failed to fetch attendance for session $sessionId',
        name: 'attendance',
        error: e,
        stackTrace: st,
      );
      throw NetworkException(e.message);
    }
  }

  Future<Attendance?> fetchAttendanceForStudentSession({
    required String sessionId,
    required String studentId,
  }) async {
    try {
      final data = await _supabase
          .from('attendance')
          .select()
          .eq('session_id', sessionId)
          .eq('student_id', studentId)
          .maybeSingle();
      if (data == null) return null;
      return Attendance.fromJson(data);
    } on PostgrestException catch (e, st) {
      log(
        'Failed to fetch attendance for student $studentId session $sessionId',
        name: 'attendance',
        error: e,
        stackTrace: st,
      );
      throw NetworkException(e.message);
    }
  }

  Future<Attendance> updateAttendanceStatus({
    required String sessionId,
    required String studentId,
    required AttendanceStatus status,
  }) async {
    try {
      final data = await _supabase
          .from('attendance')
          .update({
            'status': status.toJson(),
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('session_id', sessionId)
          .eq('student_id', studentId)
          .select()
          .single();
      return Attendance.fromJson(data);
    } on PostgrestException catch (e, st) {
      log(
        'Failed to update attendance status',
        name: 'attendance',
        error: e,
        stackTrace: st,
      );
      throw NetworkException(e.message);
    }
  }
}
