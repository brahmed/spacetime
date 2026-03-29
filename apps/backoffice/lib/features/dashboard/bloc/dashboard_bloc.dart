import 'dart:developer';

import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_client/supabase.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({
    required ProfileRepository profileRepository,
    required CourseRepository courseRepository,
    required SessionRepository sessionRepository,
  })  : _profileRepository = profileRepository,
        _courseRepository = courseRepository,
        _sessionRepository = sessionRepository,
        super(const DashboardInitial()) {
    on<DashboardLoaded>(_onLoaded);
  }

  final ProfileRepository _profileRepository;
  final CourseRepository _courseRepository;
  final SessionRepository _sessionRepository;

  Future<void> _onLoaded(
    DashboardLoaded event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());
    try {
      final results = await Future.wait([
        _profileRepository.fetchProfilesByRole(UserRole.student),
        _profileRepository.fetchProfilesByRole(UserRole.teacher),
        _courseRepository.fetchAllCourses(),
        _sessionRepository.fetchTodaySessions(),
      ]);

      emit(DashboardSuccess(
        studentCount: (results[0] as List).length,
        teacherCount: (results[1] as List).length,
        courseCount: (results[2] as List).length,
        todaySessionCount: (results[3] as List).length,
      ));
    } catch (e, st) {
      log('Failed to load dashboard', name: 'dashboard', error: e, stackTrace: st);
      emit(const DashboardFailure());
    }
  }
}
