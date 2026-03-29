part of 'teacher_session_detail_bloc.dart';

sealed class TeacherSessionDetailState extends Equatable {
  const TeacherSessionDetailState();
}

final class TeacherSessionDetailInitial extends TeacherSessionDetailState {
  const TeacherSessionDetailInitial();

  @override
  List<Object?> get props => [];
}

final class TeacherSessionDetailLoading extends TeacherSessionDetailState {
  const TeacherSessionDetailLoading();

  @override
  List<Object?> get props => [];
}

final class TeacherSessionDetailFailure extends TeacherSessionDetailState {
  const TeacherSessionDetailFailure();

  @override
  List<Object?> get props => [];
}

final class TeacherSessionDetailSuccess extends TeacherSessionDetailState {
  const TeacherSessionDetailSuccess({
    required this.session,
    required this.attendance,
  });
  final Session session;
  final List<Attendance> attendance;

  @override
  List<Object?> get props => [session, attendance];
}

final class TeacherSessionDetailActing extends TeacherSessionDetailState {
  const TeacherSessionDetailActing({
    required this.session,
    required this.attendance,
  });
  final Session session;
  final List<Attendance> attendance;

  @override
  List<Object?> get props => [session, attendance];
}

final class TeacherSessionDetailActionFailure extends TeacherSessionDetailState {
  const TeacherSessionDetailActionFailure({
    required this.session,
    required this.attendance,
  });
  final Session session;
  final List<Attendance> attendance;

  @override
  List<Object?> get props => [session, attendance];
}

final class TeacherSessionCancelled extends TeacherSessionDetailState {
  const TeacherSessionCancelled();

  @override
  List<Object?> get props => [];
}

final class TeacherSessionEdited extends TeacherSessionDetailState {
  const TeacherSessionEdited({
    required this.session,
    required this.attendance,
  });
  final Session session;
  final List<Attendance> attendance;

  @override
  List<Object?> get props => [session, attendance];
}
