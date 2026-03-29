part of 'attendance_bloc.dart';

sealed class AttendanceState extends Equatable {
  const AttendanceState();
}

final class AttendanceInitial extends AttendanceState {
  const AttendanceInitial();

  @override
  List<Object?> get props => [];
}

final class AttendanceLoading extends AttendanceState {
  const AttendanceLoading();

  @override
  List<Object?> get props => [];
}

final class AttendanceSuccess extends AttendanceState {
  const AttendanceSuccess({required this.session, required this.attendance});

  final Session session;
  final Attendance? attendance;

  @override
  List<Object?> get props => [session, attendance];
}

final class AttendanceUpdating extends AttendanceState {
  const AttendanceUpdating({required this.session, required this.attendance});

  final Session session;
  final Attendance? attendance;

  @override
  List<Object?> get props => [session, attendance];
}

final class AttendanceUpdateFailure extends AttendanceState {
  const AttendanceUpdateFailure({
    required this.session,
    required this.attendance,
  });

  final Session session;
  final Attendance? attendance;

  @override
  List<Object?> get props => [session, attendance];
}

final class AttendanceFailure extends AttendanceState {
  const AttendanceFailure();

  @override
  List<Object?> get props => [];
}
