import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';

import '../../features/auth/bloc/auth_bloc.dart';

class AdminShell extends StatelessWidget {
  const AdminShell({super.key, required this.child});

  final Widget child;

  static const _navItems = [
    _NavItem(
      route: '/dashboard',
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
    ),
    _NavItem(
      route: '/courses',
      icon: Icons.menu_book_outlined,
      selectedIcon: Icons.menu_book,
    ),
    _NavItem(
      route: '/students',
      icon: Icons.people_outline,
      selectedIcon: Icons.people,
    ),
    _NavItem(
      route: '/teachers',
      icon: Icons.school_outlined,
      selectedIcon: Icons.school,
    ),
    _NavItem(
      route: '/announcements',
      icon: Icons.campaign_outlined,
      selectedIcon: Icons.campaign,
    ),
    _NavItem(
      route: '/settings',
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final labels = [
      l10n.dashboard,
      l10n.navCourses,
      l10n.navStudents,
      l10n.navTeachers,
      l10n.navAnnouncements,
      l10n.navSettings,
    ];

    final location = GoRouterState.of(context).uri.path;
    final selectedIndex = _navItems.indexWhere(
      (item) => location.startsWith(item.route),
    );

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: MediaQuery.sizeOf(context).width >= 1200,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: Sizes.p16),
              child: Column(
                spacing: Sizes.p4,
                children: [
                  Icon(
                    Icons.access_time_filled,
                    color: Theme.of(context).appColors.accent,
                    size: 28,
                  ),
                ],
              ),
            ),
            trailing: Padding(
              padding: const EdgeInsets.only(bottom: Sizes.p16),
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final name = state is AuthAuthenticated
                      ? state.profile.fullName
                      : '';
                  final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
                  return CircleAvatar(
                    radius: 16,
                    backgroundColor: Theme.of(context)
                        .appColors
                        .accent
                        .withValues(alpha: 0.15),
                    child: Text(
                      initial,
                      style: TextStyle(
                        color: Theme.of(context).appColors.accent,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  );
                },
              ),
            ),
            selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
            onDestinationSelected: (index) {
              context.go(_navItems[index].route);
            },
            destinations: List.generate(_navItems.length, (index) {
              final item = _navItems[index];
              return NavigationRailDestination(
                icon: Icon(item.icon),
                selectedIcon: Icon(item.selectedIcon),
                label: Text(labels[index]),
              );
            }),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.route,
    required this.icon,
    required this.selectedIcon,
  });

  final String route;
  final IconData icon;
  final IconData selectedIcon;
}
