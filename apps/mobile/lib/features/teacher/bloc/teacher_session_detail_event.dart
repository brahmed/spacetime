part of 'teacher_session_detail_bloc.dart';

sealed class TeacherSessionDetailEvent extends Equatable {
  const TeacherSessionDetailEvent();
}

final class TeacherSessionDetailLoaded extends TeacherSessionDetailEvent {
  const TeacherSessionDetailLoaded({required this.sessionId});
  final String sessionId;

  @override
  List<Object?> get props => [sessionId];
}

/// Fired when the realtime attendance stream emits new rows.
final class TeacherSessionAttendanceUpdated extends TeacherSessionDetailEvent {
  const TeacherSessionAttendanceUpdated({required this.rows});
  final List<Map<String, dynamic>> rows;

  @override
  List<Object?> get props => [rows];
}

final class TeacherSessionCancelRequested extends TeacherSessionDetailEvent {
  const TeacherSessionCancelRequested();

  @override
  List<Object?> get props => [];
}

final class TeacherSessionEditRequested extends TeacherSessionDetailEvent {
  const TeacherSessionEditRequested({this.room, this.startsAt, this.endsAt});
  final String? room;
  final DateTime? startsAt;
  final DateTime? endsAt;

  @override
  List<Object?> get props => [room, startsAt, endsAt];
}
