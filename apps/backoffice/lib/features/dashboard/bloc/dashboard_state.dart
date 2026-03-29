part of 'dashboard_bloc.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

final class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

final class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

final class DashboardSuccess extends DashboardState {
  const DashboardSuccess({
    required this.studentCount,
    required this.teacherCount,
    required this.courseCount,
    required this.todaySessionCount,
  });

  final int studentCount;
  final int teacherCount;
  final int courseCount;
  final int todaySessionCount;

  @override
  List<Object?> get props => [
        studentCount,
        teacherCount,
        courseCount,
        todaySessionCount,
      ];
}

final class DashboardFailure extends DashboardState {
  const DashboardFailure();
}
