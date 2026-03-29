import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:core/core.dart';
import 'package:supabase_client/supabase.dart';
import 'package:ui/ui.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../bloc/announcements_bloc.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AnnouncementsBloc(
        announcementRepository: context.read<AnnouncementRepository>(),
      )..add(const AnnouncementsLoaded()),
      child: const _AnnouncementsView(),
    );
  }
}

class _AnnouncementsView extends StatelessWidget {
  const _AnnouncementsView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final authState = context.read<AuthBloc>().state;
    final adminId = authState is AuthAuthenticated
        ? authState.profile.id
        : '';

    return BlocListener<AnnouncementsBloc, AnnouncementsState>(
      listener: (context, state) {
        if (state is AnnouncementSendSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.announcementSent)),
          );
        } else if (state is AnnouncementSendFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.somethingWentWrong)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.announcements)),
        body: BlocBuilder<AnnouncementsBloc, AnnouncementsState>(
          builder: (context, state) {
            return switch (state) {
              AnnouncementsInitial() || AnnouncementsLoading() =>
                const Center(child: CircularProgressIndicator()),
              AnnouncementsFailure() => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: Sizes.p16,
                    children: [
                      Text(l10n.somethingWentWrong),
                      TextButton(
                        onPressed: () => context
                            .read<AnnouncementsBloc>()
                            .add(const AnnouncementsLoaded()),
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                ),
              AnnouncementsSuccess(:final announcements) => CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: _ComposeCard(adminId: adminId),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        Sizes.p24,
                        Sizes.p8,
                        Sizes.p24,
                        Sizes.p24,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Text(
                          l10n.history,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    if (announcements.isEmpty)
                      SliverFillRemaining(
                        child: Center(
                          child: Text(
                            l10n.noAnnouncementsHistory,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  color:
                                      Theme.of(context).appColors.textMuted,
                                ),
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Sizes.p24,
                        ),
                        sliver: SliverList.separated(
                          itemCount: announcements.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: Sizes.p8),
                          itemBuilder: (context, index) =>
                              _AnnouncementCard(
                                announcement: announcements[index],
                              ),
                        ),
                      ),
                  ],
                ),
            };
          },
        ),
      ),
    );
  }
}

class _ComposeCard extends StatefulWidget {
  const _ComposeCard({required this.adminId});

  final String adminId;

  @override
  State<_ComposeCard> createState() => _ComposeCardState();
}

class _ComposeCardState extends State<_ComposeCard> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  TargetRole _targetRole = TargetRole.all;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AnnouncementsBloc>().add(AnnouncementSent(
          title: _titleController.text.trim(),
          body: _bodyController.text.trim(),
          targetRole: _targetRole,
          sentBy: widget.adminId,
        ));
    _titleController.clear();
    _bodyController.clear();
    setState(() => _targetRole = TargetRole.all);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isSending = context.watch<AnnouncementsBloc>().state
        is AnnouncementsSending;

    return Padding(
      padding: const EdgeInsets.all(Sizes.p24),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Sizes.p16,
              children: [
                Text(
                  l10n.sendAnnouncement,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                TextFormField(
                  controller: _titleController,
                  decoration:
                      InputDecoration(labelText: l10n.announcementTitle),
                  validator: (value) =>
                      (value == null || value.trim().isEmpty)
                          ? l10n.fieldRequired
                          : null,
                ),
                TextFormField(
                  controller: _bodyController,
                  decoration:
                      InputDecoration(labelText: l10n.announcementBody),
                  maxLines: 3,
                  validator: (value) =>
                      (value == null || value.trim().isEmpty)
                          ? l10n.fieldRequired
                          : null,
                ),
                DropdownButtonFormField<TargetRole>(
                  initialValue: _targetRole,
                  decoration:
                      InputDecoration(labelText: l10n.targetAudience),
                  items: [
                    DropdownMenuItem(
                      value: TargetRole.all,
                      child: Text(l10n.targetAll),
                    ),
                    DropdownMenuItem(
                      value: TargetRole.student,
                      child: Text(l10n.targetStudents),
                    ),
                    DropdownMenuItem(
                      value: TargetRole.teacher,
                      child: Text(l10n.targetTeachers),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _targetRole = value);
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    onPressed: isSending ? null : _submit,
                    icon: isSending
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send_outlined, size: 16),
                    label: Text(l10n.sendAnnouncement),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard({required this.announcement});

  final Announcement announcement;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final dateFormat = DateFormat('d MMM yyyy, HH:mm');

    final targetColor = switch (announcement.targetRole) {
      TargetRole.all => colors.accent,
      TargetRole.student => colors.success,
      TargetRole.teacher => colors.warning,
    };

    final targetLabel = switch (announcement.targetRole) {
      TargetRole.all => context.l10n.targetAll,
      TargetRole.student => context.l10n.targetStudents,
      TargetRole.teacher => context.l10n.targetTeachers,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Sizes.p8,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    announcement.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.p8,
                    vertical: Sizes.p4,
                  ),
                  decoration: BoxDecoration(
                    color: targetColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Sizes.radiusBadge),
                    border: Border.all(color: targetColor),
                  ),
                  child: Text(
                    targetLabel,
                    style: TextStyle(
                      color: targetColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              announcement.body,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              dateFormat.format(announcement.createdAt.toLocal()),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.textMuted,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
