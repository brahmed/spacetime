import 'dart:developer';

import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_client/supabase.dart';

part 'teacher_home_event.dart';
part 'teacher_home_state.dart';

class TeacherHomeBloc extends Bloc<TeacherHomeEvent, TeacherHomeState> {
  TeacherHomeBloc({
    required SessionRepository sessionRepository,
    required AttendanceRepository attendanceRepository,
  })  : _sessionRepository = sessionRepository,
        _attendanceRepository = attendanceRepository,
        super(const TeacherHomeInitial()) {
    on<TeacherHomeLoaded>(_onLoaded);
  }

  final SessionRepository _sessionRepository;
  final AttendanceRepository _attendanceRepository;

  Future<void> _onLoaded(
    TeacherHomeLoaded event,
    Emitter<TeacherHomeState> emit,
  ) async {
    emit(const TeacherHomeLoading());
    try {
      final allSessions = await _sessionRepository
          .fetchUpcomingSessionsForTeacher(event.teacherId);

      final now = DateTime.now().toLocal();
      final todaySessions = allSessions.where((s) {
        final local = s.startsAt.toLocal();
        return local.year == now.year &&
            local.month == now.month &&
            local.day == now.day;
      }).toList();

      final counts = <String, int>{};
      for (final session in todaySessions) {
        final attendance =
            await _attendanceRepository.fetchAttendanceForSession(session.id);
        counts[session.id] =
            attendance.where((a) => a.status == AttendanceStatus.confirmed).length;
      }

      emit(TeacherHomeSuccess(
        todaySessions: todaySessions,
        attendanceCounts: counts,
      ));
    } catch (e, st) {
      log(
        'Failed to load teacher home',
        name: 'teacher.home',
        error: e,
        stackTrace: st,
      );
      emit(const TeacherHomeFailure());
    }
  }
}
