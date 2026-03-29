part of 'student_home_bloc.dart';

sealed class StudentHomeEvent extends Equatable {
  const StudentHomeEvent();
}

final class StudentHomeLoaded extends StudentHomeEvent {
  const StudentHomeLoaded({required this.studentId});

  final String studentId;

  @override
  List<Object?> get props => [studentId];
}
