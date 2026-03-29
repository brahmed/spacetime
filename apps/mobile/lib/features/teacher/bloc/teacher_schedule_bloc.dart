import 'dart:developer';

import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_client/supabase.dart';

part 'teacher_schedule_event.dart';
part 'teacher_schedule_state.dart';

class TeacherScheduleBloc
    extends Bloc<TeacherScheduleEvent, TeacherScheduleState> {
  TeacherScheduleBloc({required SessionRepository sessionRepository})
      : _sessionRepository = sessionRepository,
        super(const TeacherScheduleInitial()) {
    on<TeacherScheduleLoaded>(_onLoaded);
  }

  final SessionRepository _sessionRepository;

  Future<void> _onLoaded(
    TeacherScheduleLoaded event,
    Emitter<TeacherScheduleState> emit,
  ) async {
    emit(const TeacherScheduleLoading());
    try {
      final sessions = await _sessionRepository
          .fetchUpcomingSessionsForTeacher(event.teacherId);
      emit(TeacherScheduleSuccess(sessions: sessions));
    } catch (e, st) {
      log(
        'Failed to load teacher schedule',
        name: 'teacher.schedule',
        error: e,
        stackTrace: st,
      );
      emit(const TeacherScheduleFailure());
    }
  }
}
