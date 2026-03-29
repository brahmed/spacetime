part of 'student_home_bloc.dart';

sealed class StudentHomeState extends Equatable {
  const StudentHomeState();
}

final class StudentHomeInitial extends StudentHomeState {
  const StudentHomeInitial();

  @override
  List<Object?> get props => [];
}

final class StudentHomeLoading extends StudentHomeState {
  const StudentHomeLoading();

  @override
  List<Object?> get props => [];
}

final class StudentHomeSuccess extends StudentHomeState {
  const StudentHomeSuccess({
    required this.sessions,
    required this.announcements,
  });

  final List<Session> sessions;
  final List<Announcement> announcements;

  @override
  List<Object?> get props => [sessions, announcements];
}

final class StudentHomeFailure extends StudentHomeState {
  const StudentHomeFailure();

  @override
  List<Object?> get props => [];
}
