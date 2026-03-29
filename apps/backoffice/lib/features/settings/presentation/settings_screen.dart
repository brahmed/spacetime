import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

import '../../../core/cubit/locale_cubit.dart';
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
              gapH32,
              const Divider(),
              gapH24,
              const _LanguageSwitcher(),
              gapH24,
              const Divider(),
              gapH8,
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

class _LanguageSwitcher extends StatelessWidget {
  const _LanguageSwitcher();

  static const _options = [
    (locale: Locale('en'), label: 'English'),
    (locale: Locale('fr'), label: 'Français'),
    (locale: Locale('ar'), label: 'العربية'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = Theme.of(context).appColors;

    return BlocBuilder<LocaleCubit, Locale?>(
      builder: (context, selected) {
        final current = selected ?? Localizations.localeOf(context);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Sizes.p8,
          children: [
            Text(
              l10n.language,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: colors.textMuted,
                  ),
            ),
            ..._options.map((option) {
              final isSelected =
                  current.languageCode == option.locale.languageCode;
              return InkWell(
                borderRadius: BorderRadius.circular(Sizes.radiusCard),
                onTap: () =>
                    context.read<LocaleCubit>().setLocale(option.locale),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.p16,
                    vertical: Sizes.p12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colors.accent.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(Sizes.radiusCard),
                    border: Border.all(
                      color:
                          isSelected ? colors.accent : colors.borderSubtle,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        option.label,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isSelected ? colors.accent : null,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                      ),
                      if (isSelected)
                        Icon(Icons.check, color: colors.accent, size: 18),
                    ],
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
