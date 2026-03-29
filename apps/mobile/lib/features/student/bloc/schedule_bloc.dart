import 'dart:developer';

import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_client/supabase.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc({required SessionRepository sessionRepository})
      : _sessionRepository = sessionRepository,
        super(const ScheduleInitial()) {
    on<ScheduleLoaded>(_onLoaded);
  }

  final SessionRepository _sessionRepository;

  Future<void> _onLoaded(
    ScheduleLoaded event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(const ScheduleLoading());
    try {
      final sessions = await _sessionRepository
          .fetchUpcomingSessionsForStudent(event.studentId);
      emit(ScheduleSuccess(sessions: sessions));
    } catch (e, st) {
      log(
        'Failed to load schedule',
        name: 'student.schedule',
        error: e,
        stackTrace: st,
      );
      emit(const ScheduleFailure());
    }
  }
}
