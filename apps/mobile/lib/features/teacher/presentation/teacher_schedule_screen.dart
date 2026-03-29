import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:core/core.dart';
import 'package:supabase_client/supabase.dart';
import 'package:ui/ui.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../bloc/teacher_schedule_bloc.dart';

class TeacherScheduleScreen extends StatelessWidget {
  const TeacherScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is! AuthAuthenticated) return const SizedBox.shrink();
        return BlocProvider(
          create: (_) => TeacherScheduleBloc(
            sessionRepository: context.read<SessionRepository>(),
          )..add(TeacherScheduleLoaded(teacherId: authState.profile.id)),
          child: _TeacherScheduleView(teacherId: authState.profile.id),
        );
      },
    );
  }
}

class _TeacherScheduleView extends StatelessWidget {
  const _TeacherScheduleView({required this.teacherId});

  final String teacherId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.teacherSchedule)),
      body: BlocBuilder<TeacherScheduleBloc, TeacherScheduleState>(
        builder: (context, state) {
          return switch (state) {
            TeacherScheduleInitial() || TeacherScheduleLoading() =>
              const Center(child: CircularProgressIndicator()),
            TeacherScheduleFailure() => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: Sizes.p16,
                  children: [
                    Text(
                      l10n.somethingWentWrong,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).appColors.textMuted,
                          ),
                    ),
                    TextButton(
                      onPressed: () => context
                          .read<TeacherScheduleBloc>()
                          .add(TeacherScheduleLoaded(teacherId: teacherId)),
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            TeacherScheduleSuccess(:final sessions) =>
              _TeacherSessionList(sessions: sessions),
          };
        },
      ),
    );
  }
}

class _TeacherSessionList extends StatelessWidget {
  const _TeacherSessionList({required this.sessions});

  final List<Session> sessions;

  Map<DateTime, List<Session>> _groupByWeek() {
    final grouped = <DateTime, List<Session>>{};
    for (final session in sessions) {
      final local = session.startsAt.toLocal();
      final monday = local.subtract(Duration(days: local.weekday - 1));
      final weekStart = DateTime(monday.year, monday.month, monday.day);
      grouped.putIfAbsent(weekStart, () => []).add(session);
    }
    return Map.fromEntries(
      grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (sessions.isEmpty) {
      return Center(
        child: Text(
          l10n.noTeacherSessions,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).appColors.textMuted,
              ),
        ),
      );
    }

    final grouped = _groupByWeek();
    final weekDateFormat = DateFormat('d MMMM');

    return ListView(
      padding: const EdgeInsets.all(Sizes.p16),
      children: [
        for (final entry in grouped.entries) ...[
          Padding(
            padding: const EdgeInsets.only(top: Sizes.p16, bottom: Sizes.p8),
            child: Text(
              l10n.weekOf(weekDateFormat.format(entry.key)),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).appColors.accent,
                  ),
            ),
          ),
          ...entry.value.map((s) => _SessionTile(session: s)),
        ],
      ],
    );
  }
}

class _SessionTile extends StatelessWidget {
  const _SessionTile({required this.session});

  final Session session;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('EEE, d MMM');
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
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.p16,
            vertical: Sizes.p12,
          ),
          child: Row(
            spacing: Sizes.p12,
            children: [
              Container(
                width: 4,
                height: 48,
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
                      dateFormat.format(session.startsAt.toLocal()),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isCancelled ? colors.textMuted : null,
                            decoration: isCancelled
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                    ),
                    Text(
                      l10n.sessionTime(
                        timeFormat.format(session.startsAt.toLocal()),
                        timeFormat.format(session.endsAt.toLocal()),
                      ),
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
