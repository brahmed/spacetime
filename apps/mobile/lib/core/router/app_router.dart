import 'package:core/core.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/student/presentation/student_home_screen.dart';
import '../../features/teacher/presentation/teacher_home_screen.dart';

abstract final class AppRouter {
  static GoRouter router(AuthBloc authBloc) => GoRouter(
        initialLocation: '/login',
        refreshListenable: _AuthBlocListenable(authBloc),
        redirect: (context, state) {
          final authState = authBloc.state;
          final isLoginRoute = state.uri.path == '/login';

          if (authState is AuthInitial || authState is AuthLoading) {
            return null; // wait for auth to resolve
          }

          if (authState is AuthUnauthenticated || authState is AuthFailure) {
            return isLoginRoute ? null : '/login';
          }

          if (authState is AuthAuthenticated) {
            final role = authState.profile.role;
            if (isLoginRoute) {
              return switch (role) {
                UserRole.student => '/student/home',
                UserRole.teacher => '/teacher/home',
                UserRole.admin   => '/login', // admin uses backoffice
              };
            }
          }

          return null;
        },
        routes: [
          GoRoute(
            path: '/login',
            builder: (_, _) => const LoginScreen(),
          ),
          GoRoute(
            path: '/student/home',
            builder: (_, _) => const StudentHomeScreen(),
          ),
          GoRoute(
            path: '/teacher/home',
            builder: (_, _) => const TeacherHomeScreen(),
          ),
        ],
      );
}

/// Notifies go_router to re-evaluate the redirect when AuthBloc emits.
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
