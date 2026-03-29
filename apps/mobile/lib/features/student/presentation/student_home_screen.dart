import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:core/core.dart';
import 'package:supabase_client/supabase.dart';
import 'package:ui/ui.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../bloc/student_home_bloc.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is! AuthAuthenticated) return const SizedBox.shrink();
        return BlocProvider(
          create: (_) => StudentHomeBloc(
            sessionRepository: context.read<SessionRepository>(),
            announcementRepository: context.read<AnnouncementRepository>(),
          )..add(StudentHomeLoaded(studentId: authState.profile.id)),
          child: const _StudentHomeView(),
        );
      },
    );
  }
}

class _StudentHomeView extends StatelessWidget {
  const _StudentHomeView();

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
      body: BlocBuilder<StudentHomeBloc, StudentHomeState>(
        builder: (context, state) {
          return switch (state) {
            StudentHomeInitial() || StudentHomeLoading() =>
              const Center(child: CircularProgressIndicator()),
            StudentHomeFailure() => _ErrorView(
                onRetry: () => context.read<StudentHomeBloc>().add(
                      StudentHomeLoaded(studentId: authState.profile.id),
                    ),
              ),
            StudentHomeSuccess(:final sessions, :final announcements) =>
              _HomeContent(sessions: sessions, announcements: announcements),
          };
        },
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.sessions,
    required this.announcements,
  });

  final List<Session> sessions;
  final List<Announcement> announcements;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ListView(
      padding: const EdgeInsets.all(Sizes.p16),
      children: [
        _SectionHeader(title: l10n.nextSession),
        gapH8,
        sessions.isEmpty
            ? _EmptyCard(message: l10n.noUpcomingSessions)
            : _NextSessionCard(session: sessions.first),
        gapH24,
        _SectionHeader(title: l10n.announcements),
        gapH8,
        if (announcements.isEmpty)
          _EmptyCard(message: l10n.noAnnouncements)
        else
          ...announcements.map((a) => _AnnouncementCard(announcement: a)),
      ],
    );
  }
}

class _NextSessionCard extends StatelessWidget {
  const _NextSessionCard({required this.session});

  final Session session;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('EEEE, d MMMM');
    final l10n = context.l10n;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(Sizes.radiusCard),
        onTap: () => context.go('/student/schedule/${session.id}'),
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: Row(
            spacing: Sizes.p12,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colors.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(Sizes.radiusButton),
                ),
                child: Icon(Icons.event_outlined, color: colors.accent),
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
              Icon(Icons.chevron_right, color: colors.textMuted),
            ],
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
    final dateFormat = DateFormat('d MMM');

    return Card(
      margin: const EdgeInsets.only(bottom: Sizes.p8),
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Sizes.p12,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colors.warning.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(Sizes.radiusButton),
              ),
              child: Icon(Icons.campaign_outlined, color: colors.warning, size: 20),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: Sizes.p4,
                children: [
                  Text(
                    announcement.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    announcement.body,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.textMuted,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Text(
              dateFormat.format(announcement.createdAt.toLocal()),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colors.textMuted,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p24),
        child: Center(
          child: Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).appColors.textMuted,
                ),
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
          TextButton(
            onPressed: onRetry,
            child: Text(l10n.retry),
          ),
        ],
      ),
    );
  }
}
