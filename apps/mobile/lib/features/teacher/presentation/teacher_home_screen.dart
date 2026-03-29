import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:core/core.dart';
import 'package:supabase_client/supabase.dart';
import 'package:ui/ui.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../bloc/teacher_home_bloc.dart';

class TeacherHomeScreen extends StatelessWidget {
  const TeacherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is! AuthAuthenticated) return const SizedBox.shrink();
        return BlocProvider(
          create: (_) => TeacherHomeBloc(
            sessionRepository: context.read<SessionRepository>(),
            attendanceRepository: context.read<AttendanceRepository>(),
          )..add(TeacherHomeLoaded(teacherId: authState.profile.id)),
          child: _TeacherHomeView(teacherId: authState.profile.id),
        );
      },
    );
  }
}

class _TeacherHomeView extends StatelessWidget {
  const _TeacherHomeView({required this.teacherId});

  final String teacherId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final authState = context.read<AuthBloc>().state as AuthAuthenticated;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.welcomeBack,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).appColors.textMuted,
                  ),
            ),
            Text(
              authState.profile.fullName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
        toolbarHeight: 64,
      ),
      body: BlocBuilder<TeacherHomeBloc, TeacherHomeState>(
        builder: (context, state) {
          return switch (state) {
            TeacherHomeInitial() || TeacherHomeLoading() =>
              const Center(child: CircularProgressIndicator()),
            TeacherHomeFailure() => _ErrorView(
                onRetry: () => context
                    .read<TeacherHomeBloc>()
                    .add(TeacherHomeLoaded(teacherId: teacherId)),
              ),
            TeacherHomeSuccess(:final todaySessions, :final attendanceCounts) =>
              _HomeContent(
                todaySessions: todaySessions,
                attendanceCounts: attendanceCounts,
              ),
          };
        },
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.todaySessions,
    required this.attendanceCounts,
  });

  final List<Session> todaySessions;
  final Map<String, int> attendanceCounts;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ListView(
      padding: const EdgeInsets.all(Sizes.p16),
      children: [
        Text(
          l10n.todaysSessions,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        gapH8,
        if (todaySessions.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(Sizes.p24),
              child: Center(
                child: Text(
                  l10n.noUpcomingSessions,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).appColors.textMuted,
                      ),
                ),
              ),
            ),
          )
        else
          ...todaySessions.map(
            (session) => _SessionCard(
              session: session,
              confirmedCount: attendanceCounts[session.id] ?? 0,
            ),
          ),
      ],
    );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({
    required this.session,
    required this.confirmedCount,
  });

  final Session session;
  final int confirmedCount;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final timeFormat = DateFormat('HH:mm');
    final l10n = context.l10n;
    final isCancelled = session.status == SessionStatus.cancelled;

    return Card(
      margin: const EdgeInsets.only(bottom: Sizes.p8),
      child: InkWell(
        borderRadius: BorderRadius.circular(Sizes.radiusCard),
        onTap: isCancelled
            ? null
            : () => context.go('/teacher/schedule/${session.id}'),
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: Row(
            spacing: Sizes.p12,
            children: [
              Container(
                width: 4,
                height: 56,
                decoration: BoxDecoration(
                  color: isCancelled ? colors.danger : colors.accent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: Sizes.p4,
                  children: [
                    Text(
                      l10n.sessionTime(
                        timeFormat.format(session.startsAt.toLocal()),
                        timeFormat.format(session.endsAt.toLocal()),
                      ),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isCancelled ? colors.textMuted : null,
                            decoration: isCancelled
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                    ),
                    if (!isCancelled)
                      Text(
                        l10n.attendees(confirmedCount),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colors.textMuted,
                            ),
                      ),
                  ],
                ),
              ),
              if (isCancelled)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.p8,
                    vertical: Sizes.p4,
                  ),
                  decoration: BoxDecoration(
                    color: colors.danger.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Sizes.radiusBadge),
                    border: Border.all(color: colors.danger),
                  ),
                  child: Text(
                    'Cancelled',
                    style: TextStyle(
                      color: colors.danger,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else
                Icon(Icons.chevron_right, color: colors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: Sizes.p16,
        children: [
          Text(
            l10n.somethingWentWrong,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).appColors.textMuted,
                ),
            textAlign: TextAlign.center,
          ),
          TextButton(onPressed: onRetry, child: Text(l10n.retry)),
        ],
      ),
    );
  }
}
