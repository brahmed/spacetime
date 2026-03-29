import 'dart:developer';

import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_client/supabase.dart';

part 'sessions_event.dart';
part 'sessions_state.dart';

class SessionsBloc extends Bloc<SessionsEvent, SessionsState> {
  SessionsBloc({required SessionRepository sessionRepository})
      : _sessionRepository = sessionRepository,
        super(const SessionsInitial()) {
    on<SessionsLoaded>(_onLoaded);
    on<SessionCancelRequested>(_onCancelRequested);
    on<SessionAllFutureCancelRequested>(_onAllFutureCancelRequested);
    on<SessionUpdateRequested>(_onUpdateRequested);
  }

  final SessionRepository _sessionRepository;

  Future<void> _onLoaded(
    SessionsLoaded event,
    Emitter<SessionsState> emit,
  ) async {
    emit(const SessionsLoading());
    try {
      final sessions =
          await _sessionRepository.fetchSessionsByCourse(event.courseId);
      emit(SessionsSuccess(sessions: sessions, courseId: event.courseId));
    } catch (e, st) {
      log(
        'Failed to load sessions for course ${event.courseId}',
        name: 'sessions',
        error: e,
        stackTrace: st,
      );
      emit(const SessionsFailure());
    }
  }

  Future<void> _onCancelRequested(
    SessionCancelRequested event,
    Emitter<SessionsState> emit,
  ) async {
    final current = state;
    if (current is! SessionsSuccess) return;
    emit(SessionsUpdating(sessions: current.sessions, courseId: current.courseId));
    try {
      final updated = await _sessionRepository.cancelSession(event.sessionId);
      final sessions = current.sessions
          .map((s) => s.id == updated.id ? updated : s)
          .toList();
      emit(SessionCancelSuccess(sessions: sessions, courseId: current.courseId));
    } catch (e, st) {
      log(
        'Failed to cancel session ${event.sessionId}',
        name: 'sessions',
        error: e,
        stackTrace: st,
      );
      emit(SessionCancelFailure(
        sessions: current.sessions,
        courseId: current.courseId,
      ));
    }
  }

  Future<void> _onAllFutureCancelRequested(
    SessionAllFutureCancelRequested event,
    Emitter<SessionsState> emit,
  ) async {
    final current = state;
    if (current is! SessionsSuccess) return;
    emit(SessionsUpdating(sessions: current.sessions, courseId: current.courseId));
    try {
      final count =
          await _sessionRepository.cancelAllFutureSessions(event.courseId);
      final sessions =
          await _sessionRepository.fetchSessionsByCourse(event.courseId);
      emit(SessionAllFutureCancelSuccess(
        sessions: sessions,
        courseId: current.courseId,
        cancelledCount: count,
      ));
    } catch (e, st) {
      log(
        'Failed to cancel future sessions for course ${event.courseId}',
        name: 'sessions',
        error: e,
        stackTrace: st,
      );
      emit(SessionAllFutureCancelFailure(
        sessions: current.sessions,
        courseId: current.courseId,
      ));
    }
  }

  Future<void> _onUpdateRequested(
    SessionUpdateRequested event,
    Emitter<SessionsState> emit,
  ) async {
    final current = state;
    if (current is! SessionsSuccess) return;
    emit(SessionsUpdating(sessions: current.sessions, courseId: current.courseId));
    try {
      final updated = await _sessionRepository.updateSession(
        sessionId: event.sessionId,
        room: event.room,
        startsAt: event.startsAt,
        endsAt: event.endsAt,
      );
      final sessions = current.sessions
          .map((s) => s.id == updated.id ? updated : s)
          .toList();
      emit(SessionUpdateSuccess(sessions: sessions, courseId: current.courseId));
    } catch (e, st) {
      log(
        'Failed to update session ${event.sessionId}',
        name: 'sessions',
        error: e,
        stackTrace: st,
      );
      emit(SessionUpdateFailure(
        sessions: current.sessions,
        courseId: current.courseId,
      ));
    }
  }
}
