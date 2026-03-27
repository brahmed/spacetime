import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Placeholder screens — will be replaced in Phase 3+
import 'package:flutter/material.dart';

abstract final class AppRouter {
  static final router = GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final session = Supabase.instance.client.auth.currentSession;
      final isLoggedIn = session != null;
      final isLoginRoute = state.uri.path == '/login';

      if (!isLoggedIn && !isLoginRoute) return '/login';
      if (isLoggedIn && isLoginRoute) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (_, _) => const _PlaceholderScreen(label: 'Login'),
      ),
      GoRoute(
        path: '/home',
        builder: (_, _) => const _PlaceholderScreen(label: 'Home'),
      ),
    ],
  );
}

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          label,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
