import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:core/core.dart';
import 'package:supabase_client/supabase.dart';
import 'package:ui/ui.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../bloc/attendance_bloc.dart';

class SessionDetailScreen extends StatelessWidget {
  const SessionDetailScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is! AuthAuthenticated) return const SizedBox.shrink();
        return BlocProvider(
          create: (_) => AttendanceBloc(
            sessionRepository: context.read<SessionRepository>(),
            attendanceRepository: context.read<AttendanceRepository>(),
          )..add(AttendanceLoaded(
              sessionId: sessionId,
              studentId: authState.profile.id,
            )),
          child: _SessionDetailView(
            sessionId: sessionId,
            studentId: authState.profile.id,
          ),
        );
      },
    );
  }
}

class _SessionDetailView extends StatelessWidget {
  const _SessionDetailView({
    required this.sessionId,
    required this.studentId,
  });

  final String sessionId;
  final String studentId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.sessionDetail)),
      body: BlocConsumer<AttendanceBloc, AttendanceState>(
        listener: (context, state) {
          if (state is AttendanceUpdateFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.somethingWentWrong)),
            );
          }
        },
        builder: (context, state) {
          return switch (state) {
            AttendanceInitial() || AttendanceLoading() =>
              const Center(child: CircularProgressIndicator()),
            AttendanceFailure() => Center(
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
                      onPressed: () => context.read<AttendanceBloc>().add(
                            AttendanceLoaded(
                              sessionId: sessionId,
                              studentId: studentId,
                            ),
                          ),
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            AttendanceSuccess(:final session, :final attendance) ||
            AttendanceUpdating(:final session, :final attendance) ||
            AttendanceUpdateFailure(:final session, :final attendance) =>
              _DetailContent(
                session: session,
                attendance: attendance,
                studentId: studentId,
                isUpdating: state is AttendanceUpdating,
              ),
          };
        },
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({
    required this.session,
    required this.attendance,
    required this.studentId,
    required this.isUpdating,
  });

  final Session session;
  final Attendance? attendance;
  final String studentId;
  final bool isUpdating;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = Theme.of(context).appColors;
    final dateFormat = DateFormat('EEEE, d MMMM yyyy');
    final timeFormat = DateFormat('HH:mm');
    final isCancelled = session.status == SessionStatus.cancelled;

    return ListView(
      padding: const EdgeInsets.all(Sizes.p16),
      children: [
        if (isCancelled)
          Container(
            margin: const EdgeInsets.only(bottom: Sizes.p16),
            padding: const EdgeInsets.all(Sizes.p12),
            decoration: BoxDecoration(
              color: colors.danger.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Sizes.radiusCard),
              border: Border.all(color: colors.danger),
            ),
            child: Row(
              spacing: Sizes.p8,
              children: [
                Icon(Icons.cancel_outlined, color: colors.danger, size: 20),
                Expanded(
                  child: Text(
                    l10n.sessionCancelled,
                    style: TextStyle(color: colors.danger),
                  ),
                ),
              ],
            ),
          ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Sizes.p12,
              children: [
                _InfoRow(
                  icon: Icons.calendar_today_outlined,
                  text: dateFormat.format(session.startsAt.toLocal()),
                ),
                _InfoRow(
                  icon: Icons.access_time_outlined,
                  text: l10n.sessionTime(
                    timeFormat.format(session.startsAt.toLocal()),
                    timeFormat.format(session.endsAt.toLocal()),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!isCancelled && attendance != null) ...[
          gapH16,
          _AttendanceCard(attendance: attendance!),
        ],
        if (!isCancelled) ...[
          gapH24,
          _AttendanceActions(
            sessionId: session.id,
            studentId: studentId,
            attendance: attendance,
            isUpdating: isUpdating,
          ),
        ],
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: Sizes.p12,
      children: [
        Icon(icon, color: Theme.of(context).appColors.textMuted, size: 20),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class _AttendanceCard extends StatelessWidget {
  const _AttendanceCard({required this.attendance});

  final Attendance attendance;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Attendance',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            StatusBadge(status: attendance.status),
          ],
        ),
      ),
    );
  }
}

class _AttendanceActions extends StatelessWidget {
  const _AttendanceActions({
    required this.sessionId,
    required this.studentId,
    required this.attendance,
    required this.isUpdating,
  });

  final String sessionId;
  final String studentId;
  final Attendance? attendance;
  final bool isUpdating;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = attendance?.status;

    if (isUpdating) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      spacing: Sizes.p12,
      children: [
        if (status != AttendanceStatus.confirmed)
          PrimaryButton(
            label: l10n.confirmAttendance,
            onPressed: () => context.read<AttendanceBloc>().add(
                  AttendanceConfirmed(
                    sessionId: sessionId,
                    studentId: studentId,
                  ),
                ),
          ),
        if (status != AttendanceStatus.cancelled)
          SecondaryButton(
            label: l10n.cancelAttendance,
            onPressed: () => context.read<AttendanceBloc>().add(
                  AttendanceCancelled(
                    sessionId: sessionId,
                    studentId: studentId,
                  ),
                ),
          ),
      ],
    );
  }
}
