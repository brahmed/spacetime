import 'dart:developer';

import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_client/supabase.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  AttendanceBloc({
    required SessionRepository sessionRepository,
    required AttendanceRepository attendanceRepository,
  })  : _sessionRepository = sessionRepository,
        _attendanceRepository = attendanceRepository,
        super(const AttendanceInitial()) {
    on<AttendanceLoaded>(_onLoaded);
    on<AttendanceConfirmed>(_onConfirmed);
    on<AttendanceCancelled>(_onCancelled);
  }

  final SessionRepository _sessionRepository;
  final AttendanceRepository _attendanceRepository;

  Future<void> _onLoaded(
    AttendanceLoaded event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(const AttendanceLoading());
    try {
      final results = await Future.wait([
        _sessionRepository.fetchSession(event.sessionId),
        _attendanceRepository.fetchAttendanceForStudentSession(
          sessionId: event.sessionId,
          studentId: event.studentId,
        ),
      ]);
      emit(AttendanceSuccess(
        session: results[0] as Session,
        attendance: results[1] as Attendance?,
      ));
    } catch (e, st) {
      log(
        'Failed to load session detail',
        name: 'student.attendance',
        error: e,
        stackTrace: st,
      );
      emit(const AttendanceFailure());
    }
  }

  Future<void> _onConfirmed(
    AttendanceConfirmed event,
    Emitter<AttendanceState> emit,
  ) async {
    final current = state;
    if (current is! AttendanceSuccess) return;
    emit(AttendanceUpdating(
      session: current.session,
      attendance: current.attendance,
    ));
    try {
      final updated = await _attendanceRepository.updateAttendanceStatus(
        sessionId: event.sessionId,
        studentId: event.studentId,
        status: AttendanceStatus.confirmed,
      );
      emit(AttendanceSuccess(session: current.session, attendance: updated));
    } catch (e, st) {
      log(
        'Failed to confirm attendance',
        name: 'student.attendance',
        error: e,
        stackTrace: st,
      );
      emit(AttendanceUpdateFailure(
        session: current.session,
        attendance: current.attendance,
      ));
    }
  }

  Future<void> _onCancelled(
    AttendanceCancelled event,
    Emitter<AttendanceState> emit,
  ) async {
    final current = state;
    if (current is! AttendanceSuccess) return;
    emit(AttendanceUpdating(
      session: current.session,
      attendance: current.attendance,
    ));
    try {
      final updated = await _attendanceRepository.updateAttendanceStatus(
        sessionId: event.sessionId,
        studentId: event.studentId,
        status: AttendanceStatus.cancelled,
      );
      emit(AttendanceSuccess(session: current.session, attendance: updated));
    } catch (e, st) {
      log(
        'Failed to cancel attendance',
        name: 'student.attendance',
        error: e,
        stackTrace: st,
      );
      emit(AttendanceUpdateFailure(
        session: current.session,
        attendance: current.attendance,
      ));
    }
  }
}
