import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

import '../../auth/bloc/auth_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is! AuthAuthenticated) return const SizedBox.shrink();
          final profile = state.profile;

          return ListView(
            padding: const EdgeInsets.all(Sizes.p24),
            children: [
              Text(
                l10n.adminProfile,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              gapH16,
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.p24),
                  child: Row(
                    spacing: Sizes.p16,
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: Theme.of(context)
                            .appColors
                            .accent
                            .withValues(alpha: 0.15),
                        child: Text(
                          profile.fullName.isNotEmpty
                              ? profile.fullName[0].toUpperCase()
                              : '?',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Theme.of(context).appColors.accent,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: Sizes.p4,
                        children: [
                          Text(
                            profile.fullName,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            profile.role.name,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).appColors.textMuted,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              gapH24,
              ListTile(
                leading: const Icon(Icons.logout_outlined),
                title: Text(l10n.signOut),
                onTap: () => context
                    .read<AuthBloc>()
                    .add(const AuthLogoutRequested()),
              ),
            ],
          );
        },
      ),
    );
  }
}
