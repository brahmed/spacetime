import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';

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
          GoRoute(
            path: '/dashboard',
            builder: (_, _) => const DashboardScreen(),
          ),
        ],
      );
}

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
