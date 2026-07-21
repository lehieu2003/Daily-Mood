import 'package:flutter/material.dart';

import '../../app/localization/app_localizations.dart';
import '../../app/theme/app_colors.dart';

enum ShellDrawerDestination { home, stats, addMood, history, settings }

class ShellDrawer extends StatelessWidget {
  const ShellDrawer({
    required this.selectedDestination,
    required this.onDestinationSelected,
    super.key,
  });

  final ShellDrawerDestination selectedDestination;
  final ValueChanged<ShellDrawerDestination> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final headerColor = isDark
        ? AppColors.darkPrimaryPurple
        : AppColors.primaryPurple;

    return Drawer(
      key: const ValueKey('main_shell_drawer'),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: headerColor.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.spa_rounded,
                      color: headerColor,
                      semanticLabel: l10n.appTitle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.appTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                children: [
                  _DrawerItem(
                    key: const ValueKey('drawer_destination_home'),
                    icon: Icons.home_outlined,
                    selectedIcon: Icons.home,
                    label: l10n.home,
                    selected:
                        selectedDestination == ShellDrawerDestination.home,
                    onTap: () =>
                        onDestinationSelected(ShellDrawerDestination.home),
                  ),
                  _DrawerItem(
                    key: const ValueKey('drawer_destination_stats'),
                    icon: Icons.bar_chart_outlined,
                    selectedIcon: Icons.bar_chart,
                    label: l10n.stats,
                    selected:
                        selectedDestination == ShellDrawerDestination.stats,
                    onTap: () =>
                        onDestinationSelected(ShellDrawerDestination.stats),
                  ),
                  _DrawerItem(
                    key: const ValueKey('drawer_destination_add_mood'),
                    icon: Icons.add_circle_outline_rounded,
                    selectedIcon: Icons.add_circle_rounded,
                    label: l10n.addMood,
                    selected: false,
                    onTap: () =>
                        onDestinationSelected(ShellDrawerDestination.addMood),
                  ),
                  _DrawerItem(
                    key: const ValueKey('drawer_destination_history'),
                    icon: Icons.history_rounded,
                    selectedIcon: Icons.history_rounded,
                    label: l10n.history,
                    selected:
                        selectedDestination == ShellDrawerDestination.history,
                    onTap: () =>
                        onDestinationSelected(ShellDrawerDestination.history),
                  ),
                  _DrawerItem(
                    key: const ValueKey('drawer_destination_settings'),
                    icon: Icons.settings_outlined,
                    selectedIcon: Icons.settings,
                    label: l10n.settings,
                    selected:
                        selectedDestination == ShellDrawerDestination.settings,
                    onTap: () =>
                        onDestinationSelected(ShellDrawerDestination.settings),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
              child: Text(
                l10n.settingsSubtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required super.key,
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        leading: Icon(selected ? selectedIcon : icon),
        title: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
        selected: selected,
        selectedTileColor: AppColors.primaryPurple.withValues(alpha: 0.10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        onTap: onTap,
      ),
    );
  }
}
