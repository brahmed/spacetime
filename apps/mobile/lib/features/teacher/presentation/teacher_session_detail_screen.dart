import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:core/core.dart';
import 'package:supabase_client/supabase.dart';
import 'package:ui/ui.dart';

import '../../../common/widgets/show_alert_dialog.dart';
import '../bloc/teacher_session_detail_bloc.dart';

class TeacherSessionDetailScreen extends StatelessWidget {
  const TeacherSessionDetailScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TeacherSessionDetailBloc(
        sessionRepository: context.read<SessionRepository>(),
        attendanceRepository: context.read<AttendanceRepository>(),
      )..add(TeacherSessionDetailLoaded(sessionId: sessionId)),
      child: _TeacherSessionDetailView(sessionId: sessionId),
    );
  }
}

class _TeacherSessionDetailView extends StatelessWidget {
  const _TeacherSessionDetailView({required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.sessionDetail)),
      body: BlocConsumer<TeacherSessionDetailBloc, TeacherSessionDetailState>(
        listener: (context, state) {
          if (state is TeacherSessionCancelled) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.sessionCancelledSuccess)),
            );
            context.pop();
          } else if (state is TeacherSessionEdited) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.sessionUpdated)),
            );
          } else if (state is TeacherSessionDetailActionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.somethingWentWrong)),
            );
          }
        },
        builder: (context, state) {
          return switch (state) {
            TeacherSessionDetailInitial() || TeacherSessionDetailLoading() =>
              const Center(child: CircularProgressIndicator()),
            TeacherSessionDetailFailure() => Center(
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
                          .read<TeacherSessionDetailBloc>()
                          .add(TeacherSessionDetailLoaded(
                              sessionId: sessionId)),
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            TeacherSessionDetailSuccess(:final session, :final attendance) ||
            TeacherSessionDetailActing(:final session, :final attendance) ||
            TeacherSessionDetailActionFailure(:final session, :final attendance) ||
            TeacherSessionEdited(:final session, :final attendance) =>
              _DetailContent(
                session: session,
                attendance: attendance,
                isActing: state is TeacherSessionDetailActing,
              ),
            TeacherSessionCancelled() => const SizedBox.shrink(),
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
    required this.isActing,
  });

  final Session session;
  final List<Attendance> attendance;
  final bool isActing;

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

        // Session info card
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

        gapH16,

        // Attendance section header
        Text(
          l10n.attendanceList,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        gapH8,

        // Realtime attendance list
        if (attendance.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(Sizes.p24),
              child: Center(
                child: Text(
                  l10n.noUpcomingSessions,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.textMuted,
                      ),
                ),
              ),
            ),
          )
        else
          ...attendance.map((a) => _AttendanceTile(attendance: a)),

        if (!isCancelled) ...[
          gapH24,
          if (isActing)
            const Center(child: CircularProgressIndicator())
          else
            _TeacherActions(session: session),
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
          child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}

class _AttendanceTile extends StatelessWidget {
  const _AttendanceTile({required this.attendance});

  final Attendance attendance;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    final (Color statusColor, IconData statusIcon) = switch (attendance.status) {
      AttendanceStatus.confirmed => (colors.success, Icons.check_circle_outline),
      AttendanceStatus.cancelled => (colors.danger, Icons.cancel_outlined),
      AttendanceStatus.pending   => (colors.warning, Icons.radio_button_unchecked),
    };

    return Card(
      margin: const EdgeInsets.only(bottom: Sizes.p8),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.p16,
          vertical: Sizes.p12,
        ),
        child: Row(
          spacing: Sizes.p12,
          children: [
            Icon(statusIcon, color: statusColor, size: 20),
            Expanded(
              child: Text(
                attendance.studentId, // studentId shown — profile join not in scope
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            StatusBadge(status: attendance.status),
          ],
        ),
      ),
    );
  }
}

class _TeacherActions extends StatelessWidget {
  const _TeacherActions({required this.session});

  final Session session;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      spacing: Sizes.p12,
      children: [
        SecondaryButton(
          label: l10n.editSession,
          onPressed: () => _showEditSheet(context),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).appColors.danger,
          ),
          onPressed: () => _confirmCancel(context),
          child: Text(l10n.cancelSession),
        ),
      ],
    );
  }

  Future<void> _confirmCancel(BuildContext context) async {
    final l10n = context.l10n;

    final confirmed = await showAlertDialog(
      context: context,
      title: l10n.cancelSessionConfirmTitle,
      content: l10n.cancelSessionConfirmMessage,
      cancelActionText: l10n.cancel,
      defaultActionText: l10n.cancelSessionConfirmButton,
      isDestructive: true,
    );

    if (confirmed == true && context.mounted) {
      context
          .read<TeacherSessionDetailBloc>()
          .add(const TeacherSessionCancelRequested());
    }
  }

  Future<void> _showEditSheet(BuildContext context) async {
    final bloc = context.read<TeacherSessionDetailBloc>();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: _EditSessionSheet(session: session),
      ),
    );
  }
}

class _EditSessionSheet extends StatefulWidget {
  const _EditSessionSheet({required this.session});

  final Session session;

  @override
  State<_EditSessionSheet> createState() => _EditSessionSheetState();
}

class _EditSessionSheetState extends State<_EditSessionSheet> {
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

  @override
  void initState() {
    super.initState();
    final local = widget.session.startsAt.toLocal();
    final localEnd = widget.session.endsAt.toLocal();
    _startTime = TimeOfDay(hour: local.hour, minute: local.minute);
    _endTime = TimeOfDay(hour: localEnd.hour, minute: localEnd.minute);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = Theme.of(context).appColors;

    return Padding(
      padding: EdgeInsets.only(
        left: Sizes.p24,
        right: Sizes.p24,
        top: Sizes.p24,
        bottom: MediaQuery.viewInsetsOf(context).bottom + Sizes.p24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Sizes.p16,
        children: [
          Text(
            l10n.editSession,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          _TimePicker(
            label: 'Start time',
            time: _startTime,
            onChanged: (t) => setState(() => _startTime = t),
          ),
          _TimePicker(
            label: 'End time',
            time: _endTime,
            onChanged: (t) => setState(() => _endTime = t),
          ),
          PrimaryButton(
            label: l10n.saveChanges,
            onPressed: () {
              final base = widget.session.startsAt.toLocal();
              final newStart = DateTime(
                base.year, base.month, base.day,
                _startTime.hour, _startTime.minute,
              ).toUtc();
              final newEnd = DateTime(
                base.year, base.month, base.day,
                _endTime.hour, _endTime.minute,
              ).toUtc();

              context
                  .read<TeacherSessionDetailBloc>()
                  .add(TeacherSessionEditRequested(
                    startsAt: newStart,
                    endsAt: newEnd,
                  ));
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: colors.textMuted),
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }
}

class _TimePicker extends StatelessWidget {
  const _TimePicker({
    required this.label,
    required this.time,
    required this.onChanged,
  });

  final String label;
  final TimeOfDay time;
  final ValueChanged<TimeOfDay> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return InkWell(
      borderRadius: BorderRadius.circular(Sizes.radiusCard),
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: time,
        );
        if (picked != null) onChanged(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.p16,
          vertical: Sizes.p12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizes.radiusCard),
          border: Border.all(color: colors.borderSubtle),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.textMuted,
                  ),
            ),
            Text(
              time.format(context),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
