part of 'teacher_home_bloc.dart';

sealed class TeacherHomeState extends Equatable {
  const TeacherHomeState();
}

final class TeacherHomeInitial extends TeacherHomeState {
  const TeacherHomeInitial();

  @override
  List<Object?> get props => [];
}

final class TeacherHomeLoading extends TeacherHomeState {
  const TeacherHomeLoading();

  @override
  List<Object?> get props => [];
}

final class TeacherHomeSuccess extends TeacherHomeState {
  const TeacherHomeSuccess({
    required this.todaySessions,
    required this.attendanceCounts,
  });

  /// Sessions starting today.
  final List<Session> todaySessions;

  /// Map of sessionId → confirmed attendance count.
  final Map<String, int> attendanceCounts;

  @override
  List<Object?> get props => [todaySessions, attendanceCounts];
}

final class TeacherHomeFailure extends TeacherHomeState {
  const TeacherHomeFailure();

  @override
  List<Object?> get props => [];
}
