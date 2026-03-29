import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:core/core.dart';
import 'package:supabase_client/supabase.dart';
import 'package:ui/ui.dart';

import '../../../common/widgets/show_alert_dialog.dart';
import '../bloc/sessions_bloc.dart';

class SessionsScreen extends StatelessWidget {
  const SessionsScreen({super.key, required this.courseId});

  final String courseId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SessionsBloc(
        sessionRepository: context.read<SessionRepository>(),
      )..add(SessionsLoaded(courseId: courseId)),
      child: _SessionsView(courseId: courseId),
    );
  }
}

class _SessionsView extends StatelessWidget {
  const _SessionsView({required this.courseId});

  final String courseId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<SessionsBloc, SessionsState>(
      listener: (context, state) {
        if (state is SessionCancelSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.sessionCancelledSuccess)),
          );
        } else if (state is SessionAllFutureCancelSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                l10n.sessionsCancelledCount(state.cancelledCount),
              ),
            ),
          );
        } else if (state is SessionUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.sessionUpdated)),
          );
        } else if (state
            is SessionCancelFailure ||
            state is SessionAllFutureCancelFailure ||
            state is SessionUpdateFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.somethingWentWrong)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.navSessions),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: Sizes.p16),
              child: BlocBuilder<SessionsBloc, SessionsState>(
                builder: (context, state) {
                  if (state is! SessionsSuccess) return const SizedBox.shrink();
                  return OutlinedButton.icon(
                    onPressed: () =>
                        _confirmCancelAll(context, state.courseId),
                    icon: const Icon(Icons.cancel_outlined, size: 16),
                    label: Text(l10n.cancelAllFuture),
                  );
                },
              ),
            ),
          ],
        ),
        body: BlocBuilder<SessionsBloc, SessionsState>(
          builder: (context, state) {
            return switch (state) {
              SessionsInitial() || SessionsLoading() =>
                const Center(child: CircularProgressIndicator()),
              SessionsFailure() => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: Sizes.p16,
                    children: [
                      Text(l10n.somethingWentWrong),
                      TextButton(
                        onPressed: () => context
                            .read<SessionsBloc>()
                            .add(SessionsLoaded(courseId: courseId)),
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                ),
              SessionsSuccess(:final sessions) => sessions.isEmpty
                  ? Center(
                      child: Text(
                        l10n.noSessions,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).appColors.textMuted,
                            ),
                      ),
                    )
                  : _SessionsList(sessions: sessions),
            };
          },
        ),
      ),
    );
  }

  Future<void> _confirmCancelAll(
    BuildContext context,
    String courseId,
  ) async {
    final l10n = context.l10n;
    final confirmed = await showAlertDialog(
      context: context,
      title: l10n.cancelAllFutureConfirmTitle,
      content: l10n.cancelAllFutureConfirmMessage,
      cancelActionText: l10n.cancel,
      defaultActionText: l10n.cancelAllFutureConfirmButton,
      isDestructive: true,
    );
    if (confirmed == true && context.mounted) {
      context
          .read<SessionsBloc>()
          .add(SessionAllFutureCancelRequested(courseId: courseId));
    }
  }
}

class _SessionsList extends StatelessWidget {
  const _SessionsList({required this.sessions});

  final List<Session> sessions;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(Sizes.p24),
      itemCount: sessions.length,
      separatorBuilder: (_, _) => const SizedBox(height: Sizes.p8),
      itemBuilder: (context, index) =>
          _SessionRow(session: sessions[index]),
    );
  }
}

class _SessionRow extends StatelessWidget {
  const _SessionRow({required this.session});

  final Session session;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final l10n = context.l10n;
    final dateFormat = DateFormat('EEE, d MMM');
    final timeFormat = DateFormat('HH:mm');
    final isCancelled = session.status == SessionStatus.cancelled;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.p16,
          vertical: Sizes.p12,
        ),
        child: Row(
          spacing: Sizes.p16,
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
                          decoration: isCancelled
                              ? TextDecoration.lineThrough
                              : null,
                          color: isCancelled ? colors.textMuted : null,
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
              Row(
                spacing: Sizes.p8,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    tooltip: l10n.editSession,
                    onPressed: () => _openEditSheet(context),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.cancel_outlined,
                      size: 18,
                      color: colors.danger,
                    ),
                    tooltip: l10n.cancelSession,
                    onPressed: () => _confirmCancel(context),
                  ),
                ],
              ),
          ],
        ),
      ),
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
          .read<SessionsBloc>()
          .add(SessionCancelRequested(sessionId: session.id));
    }
  }

  void _openEditSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: context.read<SessionsBloc>(),
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
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _roomController;
  late DateTime _startsAt;
  late DateTime _endsAt;

  @override
  void initState() {
    super.initState();
    _roomController = TextEditingController();
    _startsAt = widget.session.startsAt.toLocal();
    _endsAt = widget.session.endsAt.toLocal();
  }

  @override
  void dispose() {
    _roomController.dispose();
    super.dispose();
  }

  Future<void> _pickTime({required bool isStart}) async {
    final initial = isStart ? _startsAt : _endsAt;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startsAt = DateTime(
          _startsAt.year,
          _startsAt.month,
          _startsAt.day,
          picked.hour,
          picked.minute,
        );
      } else {
        _endsAt = DateTime(
          _endsAt.year,
          _endsAt.month,
          _endsAt.day,
          picked.hour,
          picked.minute,
        );
      }
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<SessionsBloc>().add(
          SessionUpdateRequested(
            sessionId: widget.session.id,
            room: _roomController.text.trim().isEmpty
                ? null
                : _roomController.text.trim(),
            startsAt: _startsAt.toUtc(),
            endsAt: _endsAt.toUtc(),
          ),
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final timeFormat = DateFormat('HH:mm');

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
        left: Sizes.p24,
        right: Sizes.p24,
        top: Sizes.p24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Sizes.p16,
          children: [
            Row(
              children: [
                Text(
                  l10n.editSession,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            TextFormField(
              controller: _roomController,
              decoration: InputDecoration(labelText: l10n.editRoom),
            ),
            Row(
              spacing: Sizes.p16,
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickTime(isStart: true),
                    icon: const Icon(Icons.access_time_outlined, size: 16),
                    label: Text(timeFormat.format(_startsAt)),
                  ),
                ),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickTime(isStart: false),
                    icon: const Icon(Icons.access_time_outlined, size: 16),
                    label: Text(timeFormat.format(_endsAt)),
                  ),
                ),
              ],
            ),
            PrimaryButton(
              onPressed: _submit,
              label: l10n.saveChanges,
            ),
            const SizedBox(height: Sizes.p8),
          ],
        ),
      ),
    );
  }
}
