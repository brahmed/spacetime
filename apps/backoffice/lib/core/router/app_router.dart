import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/admin_shell.dart';
import '../../features/announcements/presentation/announcements_screen.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/courses/presentation/courses_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/sessions/presentation/sessions_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/students/presentation/students_screen.dart';
import '../../features/teachers/presentation/teachers_screen.dart';

abstract final class AppRouter {
  static GoRouter router(AuthBloc authBloc) => GoRouter(
        initialLocation: '/login',
        refreshListenable: _AuthBlocListenable(authBloc),
        redirect: (context, state) {
          final authState = authBloc.state;
          final isLoginRoute = state.uri.path == '/login';

          if (authState is AuthInitial || authState is AuthLoading) {
            return null;
          }

          if (authState is AuthUnauthenticated || authState is AuthFailure) {
            return isLoginRoute ? null : '/login';
          }

          if (authState is AuthAuthenticated) {
            return isLoginRoute ? '/dashboard' : null;
          }

          return null;
        },
        routes: [
          GoRoute(
            path: '/login',
            builder: (_, _) => const LoginScreen(),
          ),
          ShellRoute(
            builder: (_, _, child) => AdminShell(child: child),
            routes: [
              GoRoute(
                path: '/dashboard',
                pageBuilder: (_, _) => _fadePage(const DashboardScreen()),
              ),
              GoRoute(
                path: '/courses',
                pageBuilder: (_, _) => _fadePage(const CoursesScreen()),
              ),
              GoRoute(
                path: '/sessions/:courseId',
                pageBuilder: (_, state) => _fadePage(SessionsScreen(
                  courseId: state.pathParameters['courseId']!,
                )),
              ),
              GoRoute(
                path: '/students',
                pageBuilder: (_, _) => _fadePage(const StudentsScreen()),
              ),
              GoRoute(
                path: '/teachers',
                pageBuilder: (_, _) => _fadePage(const TeachersScreen()),
              ),
              GoRoute(
                path: '/announcements',
                pageBuilder: (_, _) => _fadePage(const AnnouncementsScreen()),
              ),
              GoRoute(
                path: '/settings',
                pageBuilder: (_, _) => _fadePage(const SettingsScreen()),
              ),
            ],
          ),
        ],
      );
}

CustomTransitionPage<void> _fadePage(Widget child) =>
    CustomTransitionPage<void>(
      child: child,
      transitionDuration: const Duration(milliseconds: 150),
      transitionsBuilder: (_, animation, __, child) =>
          FadeTransition(opacity: animation, child: child),
    );

class _AuthBlocListenable extends ChangeNotifier {
  _AuthBlocListenable(AuthBloc bloc) {
    _subscription = bloc.stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
