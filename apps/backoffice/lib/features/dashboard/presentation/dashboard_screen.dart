import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

import '../../auth/bloc/auth_bloc.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appNameBackoffice),
        actions: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final name = state is AuthAuthenticated
                  ? state.profile.fullName
                  : '';
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
                child: Row(
                  spacing: Sizes.p16,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).appColors.textMuted,
                          ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout_outlined),
                      tooltip: l10n.signOut,
                      onPressed: () => context
                          .read<AuthBloc>()
                          .add(const AuthLogoutRequested()),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is! AuthAuthenticated) return const SizedBox.shrink();

          return Padding(
            padding: const EdgeInsets.all(Sizes.p32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Sizes.p8,
              children: [
                Text(
                  l10n.dashboard,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  l10n.welcomeBackNamed(state.profile.fullName),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).appColors.textMuted,
                      ),
                ),
                const SizedBox(height: Sizes.p32),
                Wrap(
                  spacing: Sizes.p16,
                  runSpacing: Sizes.p16,
                  children: [
                    _StatCard(label: l10n.students, icon: Icons.people_outline),
                    _StatCard(label: l10n.teachers, icon: Icons.school_outlined),
                    _StatCard(label: l10n.courses, icon: Icons.menu_book_outlined),
                    _StatCard(label: l10n.todaysSessionsCount, icon: Icons.today_outlined),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Sizes.p4,
            children: [
              Icon(icon, color: Theme.of(context).appColors.accent),
              const SizedBox(height: Sizes.p16),
              Text(
                '—',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).appColors.textMuted,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
