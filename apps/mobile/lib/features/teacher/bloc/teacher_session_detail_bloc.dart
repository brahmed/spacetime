import 'dart:async';
import 'dart:developer';

import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_client/supabase.dart';

part 'teacher_session_detail_event.dart';
part 'teacher_session_detail_state.dart';

class TeacherSessionDetailBloc
    extends Bloc<TeacherSessionDetailEvent, TeacherSessionDetailState> {
  TeacherSessionDetailBloc({
    required SessionRepository sessionRepository,
    required AttendanceRepository attendanceRepository,
  })  : _sessionRepository = sessionRepository,
        _attendanceRepository = attendanceRepository,
        super(const TeacherSessionDetailInitial()) {
    on<TeacherSessionDetailLoaded>(_onLoaded);
    on<TeacherSessionAttendanceUpdated>(_onAttendanceUpdated);
    on<TeacherSessionCancelRequested>(_onCancelRequested);
    on<TeacherSessionEditRequested>(_onEditRequested);
  }

  final SessionRepository _sessionRepository;
  final AttendanceRepository _attendanceRepository;
  StreamSubscription<List<Map<String, dynamic>>>? _attendanceSubscription;

  Future<void> _onLoaded(
    TeacherSessionDetailLoaded event,
    Emitter<TeacherSessionDetailState> emit,
  ) async {
    emit(const TeacherSessionDetailLoading());
    try {
      final session = await _sessionRepository.fetchSession(event.sessionId);
      final attendance =
          await _attendanceRepository.fetchAttendanceForSession(event.sessionId);

      emit(TeacherSessionDetailSuccess(
        session: session,
        attendance: attendance,
      ));

      // Subscribe to realtime updates.
      await _attendanceSubscription?.cancel();
      _attendanceSubscription = _sessionRepository
          .streamAttendanceForSession(event.sessionId)
          .listen((rows) => add(TeacherSessionAttendanceUpdated(rows: rows)));
    } catch (e, st) {
      log(
        'Failed to load teacher session detail',
        name: 'teacher.session',
        error: e,
        stackTrace: st,
      );
      emit(const TeacherSessionDetailFailure());
    }
  }

  void _onAttendanceUpdated(
    TeacherSessionAttendanceUpdated event,
    Emitter<TeacherSessionDetailState> emit,
  ) {
    final current = state;
    if (current is! TeacherSessionDetailSuccess &&
        current is! TeacherSessionDetailActing &&
        current is! TeacherSessionDetailActionFailure &&
        current is! TeacherSessionEdited) {
      return;
    }

    final Session session;
    if (current is TeacherSessionDetailSuccess) {
      session = current.session;
    } else if (current is TeacherSessionDetailActing) {
      session = current.session;
    } else if (current is TeacherSessionDetailActionFailure) {
      session = current.session;
    } else {
      session = (current as TeacherSessionEdited).session;
    }

    final updated = event.rows.map(Attendance.fromJson).toList();
    emit(TeacherSessionDetailSuccess(session: session, attendance: updated));
  }

  Future<void> _onCancelRequested(
    TeacherSessionCancelRequested event,
    Emitter<TeacherSessionDetailState> emit,
  ) async {
    final current = state;
    if (current is! TeacherSessionDetailSuccess) return;

    emit(TeacherSessionDetailActing(
      session: current.session,
      attendance: current.attendance,
    ));
    try {
      await _sessionRepository.cancelSession(current.session.id);
      emit(const TeacherSessionCancelled());
    } catch (e, st) {
      log(
        'Failed to cancel session ${current.session.id}',
        name: 'teacher.session',
        error: e,
        stackTrace: st,
      );
      emit(TeacherSessionDetailActionFailure(
        session: current.session,
        attendance: current.attendance,
      ));
    }
  }

  Future<void> _onEditRequested(
    TeacherSessionEditRequested event,
    Emitter<TeacherSessionDetailState> emit,
  ) async {
    final current = state;
    if (current is! TeacherSessionDetailSuccess) return;

    emit(TeacherSessionDetailActing(
      session: current.session,
      attendance: current.attendance,
    ));
    try {
      final updated = await _sessionRepository.updateSession(
        sessionId: current.session.id,
        room: event.room,
        startsAt: event.startsAt,
        endsAt: event.endsAt,
      );
      emit(TeacherSessionEdited(
        session: updated,
        attendance: current.attendance,
      ));
    } catch (e, st) {
      log(
        'Failed to edit session ${current.session.id}',
        name: 'teacher.session',
        error: e,
        stackTrace: st,
      );
      emit(TeacherSessionDetailActionFailure(
        session: current.session,
        attendance: current.attendance,
      ));
    }
  }

  @override
  Future<void> close() {
    _attendanceSubscription?.cancel();
    return super.close();
  }
}
