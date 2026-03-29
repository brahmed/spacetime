part of 'attendance_bloc.dart';

sealed class AttendanceEvent extends Equatable {
  const AttendanceEvent();
}

final class AttendanceLoaded extends AttendanceEvent {
  const AttendanceLoaded({
    required this.sessionId,
    required this.studentId,
  });

  final String sessionId;
  final String studentId;

  @override
  List<Object?> get props => [sessionId, studentId];
}

final class AttendanceConfirmed extends AttendanceEvent {
  const AttendanceConfirmed({
    required this.sessionId,
    required this.studentId,
  });

  final String sessionId;
  final String studentId;

  @override
  List<Object?> get props => [sessionId, studentId];
}

final class AttendanceCancelled extends AttendanceEvent {
  const AttendanceCancelled({
    required this.sessionId,
    required this.studentId,
  });

  final String sessionId;
  final String studentId;

  @override
  List<Object?> get props => [sessionId, studentId];
}
