import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:core/core.dart';
import 'package:supabase_client/supabase.dart';
import 'package:ui/ui.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../bloc/notifications_bloc.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is! AuthAuthenticated) return const SizedBox.shrink();
        return BlocProvider(
          create: (_) => NotificationsBloc(
            notificationRepository: context.read<NotificationRepository>(),
          )..add(NotificationsLoaded(userId: authState.profile.id)),
          child: _NotificationsView(userId: authState.profile.id),
        );
      },
    );
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notifications),
        actions: [
          BlocBuilder<NotificationsBloc, NotificationsState>(
            builder: (context, state) {
              if (state is! NotificationsSuccess) return const SizedBox.shrink();
              final hasUnread = state.notifications.any((n) => !n.read);
              if (!hasUnread) return const SizedBox.shrink();
              return TextButton(
                onPressed: () => context
                    .read<NotificationsBloc>()
                    .add(NotificationsAllMarkedRead(userId: userId)),
                child: Text(l10n.markAllRead),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          return switch (state) {
            NotificationsInitial() || NotificationsLoading() =>
              const Center(child: CircularProgressIndicator()),
            NotificationsFailure() => Center(
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
                          .read<NotificationsBloc>()
                          .add(NotificationsLoaded(userId: userId)),
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            NotificationsSuccess(:final notifications) =>
              notifications.isEmpty
                  ? Center(
                      child: Text(
                        l10n.noNotifications,
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color:
                                      Theme.of(context).appColors.textMuted,
                                ),
                      ),
                    )
                  : _NotificationsList(notifications: notifications),
          };
        },
      ),
    );
  }
}

class _NotificationsList extends StatelessWidget {
  const _NotificationsList({required this.notifications});

  final List<AppNotification> notifications;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
      itemCount: notifications.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return _NotificationTile(notification: notifications[index]);
      },
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification});

  final AppNotification notification;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final timeFormat = DateFormat('d MMM, HH:mm');

    IconData icon;
    Color iconColor;
    switch (notification.type) {
      case NotificationType.reminder:
        icon = Icons.alarm_outlined;
        iconColor = colors.accent;
      case NotificationType.cancellation:
        icon = Icons.cancel_outlined;
        iconColor = colors.danger;
      case NotificationType.announcement:
        icon = Icons.campaign_outlined;
        iconColor = colors.warning;
    }

    return InkWell(
      onTap: notification.read
          ? null
          : () => context
              .read<NotificationsBloc>()
              .add(NotificationMarkedRead(notificationId: notification.id)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.p16,
          vertical: Sizes.p12,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Sizes.p12,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(Sizes.radiusButton),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: Sizes.p4,
                children: [
                  if (notification.title != null)
                    Text(
                      notification.title!,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: notification.read
                                ? FontWeight.w400
                                : FontWeight.w700,
                          ),
                    ),
                  if (notification.body != null)
                    Text(
                      notification.body!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colors.textMuted,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  Text(
                    timeFormat.format(notification.createdAt.toLocal()),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colors.textMuted,
                        ),
                  ),
                ],
              ),
            ),
            if (!notification.read)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: Sizes.p4),
                decoration: BoxDecoration(
                  color: colors.accent,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
