import 'dart:developer';

import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_client/supabase.dart';

part 'student_home_event.dart';
part 'student_home_state.dart';

class StudentHomeBloc extends Bloc<StudentHomeEvent, StudentHomeState> {
  StudentHomeBloc({
    required SessionRepository sessionRepository,
    required AnnouncementRepository announcementRepository,
  })  : _sessionRepository = sessionRepository,
        _announcementRepository = announcementRepository,
        super(const StudentHomeInitial()) {
    on<StudentHomeLoaded>(_onLoaded);
  }

  final SessionRepository _sessionRepository;
  final AnnouncementRepository _announcementRepository;

  Future<void> _onLoaded(
    StudentHomeLoaded event,
    Emitter<StudentHomeState> emit,
  ) async {
    emit(const StudentHomeLoading());
    try {
      final results = await Future.wait([
        _sessionRepository.fetchUpcomingSessionsForStudent(event.studentId),
        _announcementRepository.fetchAnnouncements(),
      ]);
      emit(StudentHomeSuccess(
        sessions: results[0] as List<Session>,
        announcements: results[1] as List<Announcement>,
      ));
    } catch (e, st) {
      log(
        'Failed to load student home',
        name: 'student.home',
        error: e,
        stackTrace: st,
      );
      emit(const StudentHomeFailure());
    }
  }
}
