import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/localization/app_localizations.dart';
import '../../app/routes/app_router.dart';
import '../../app/theme/app_colors.dart';
import '../analytics/stats_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../history/history_screen.dart';
import '../settings/settings_screen.dart';
import 'shell_drawer.dart';

/// Persistent bottom-nav shell built on plain Material widgets
/// (`Scaffold` + `BottomAppBar` + `FloatingActionButton`).
///
/// Home / Stats / History / Setting live in a [PageView] driven by a
/// [PageController]; the [BottomAppBar] icons animate themselves via
/// [AnimatedContainer]/[AnimatedSwitcher] to track the selected page.
/// "Add mood" is NOT a tab — it's the docked [FloatingActionButton]
/// that pushes the existing [AppRoutes.quickLog] route. Because it's
/// no longer a slot inside the tab strip, the remaining four tabs are
/// simply indices 0..3 (home, stats, history, settings).
///
/// Drop-in replacement for the old `_HomePlaceholder` — mount it at
/// [AppRoutes.home] and nothing else in the router needs to change.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  static const _animDuration = Duration(milliseconds: 300);

  final _pageController = PageController(initialPage: 0);
  int _selectedTab = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onAddMoodTap() {
    final currentTab = _pageController.page?.round() ?? _selectedTab;
    context.push(AppRoutes.quickLog).then((_) {
      if (mounted) _selectTab(currentTab);
    });
  }

  void _openStatsTab() {
    _selectTab(1);
  }

  void _selectTab(int index) {
    setState(() => _selectedTab = index);
    _pageController.animateToPage(
      index,
      duration: _animDuration,
      curve: Curves.easeInOut,
    );
  }

  Future<void> _selectDrawerDestination(
    ShellDrawerDestination destination,
  ) async {
    Navigator.of(context).pop();
    await Future<void>.delayed(const Duration(milliseconds: 160));
    if (!mounted) return;

    switch (destination) {
      case ShellDrawerDestination.home:
        _selectTab(0);
        break;
      case ShellDrawerDestination.stats:
        _selectTab(1);
        break;
      case ShellDrawerDestination.addMood:
        _onAddMoodTap();
        break;
      case ShellDrawerDestination.history:
        _selectTab(2);
        break;
      case ShellDrawerDestination.settings:
        _selectTab(3);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final navSurface = isDark ? AppColors.darkNavSurface : AppColors.navSurface;
    final notchColor = isDark
        ? AppColors.darkPrimaryPurple
        : AppColors.primaryPurple;
    final inactiveItemColor = isDark
        ? AppColors.darkNavInactiveItem
        : AppColors.navInactiveItem;
    final activeItemColor = isDark
        ? AppColors.darkBackground
        : AppColors.navSurface;
    final l10n = context.l10n;

    return Scaffold(
      extendBody: true,
      drawer: ShellDrawer(
        selectedDestination: _drawerDestinationForTab(_selectedTab),
        onDestinationSelected: _selectDrawerDestination,
      ),
      drawerEnableOpenDragGesture: true,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) => setState(() => _selectedTab = index),
        children: [
          DashboardScreen(onOpenTrend: _openStatsTab),
          const StatsScreen(),
          const HistoryScreen(),
          const SettingsScreen(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddMoodTap,
        backgroundColor: notchColor,
        tooltip: l10n.addMood,
        child: Icon(Icons.add, color: activeItemColor),
      ),
      bottomNavigationBar: BottomAppBar(
        color: navSurface,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        padding: EdgeInsets.zero,
        height: 64,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NavBarItem(
              inactiveIcon: Icons.home_outlined,
              activeIcon: Icons.home,
              label: l10n.home,
              isSelected: _selectedTab == 0,
              activeColor: notchColor,
              inactiveColor: inactiveItemColor,
              duration: _animDuration,
              onTap: () => _selectTab(0),
            ),
            _NavBarItem(
              inactiveIcon: Icons.bar_chart_outlined,
              activeIcon: Icons.bar_chart,
              label: l10n.stats,
              isSelected: _selectedTab == 1,
              activeColor: notchColor,
              inactiveColor: inactiveItemColor,
              duration: _animDuration,
              onTap: () => _selectTab(1),
            ),
            // Gap reserved for the docked FAB notch.
            const SizedBox(width: 48),
            _NavBarItem(
              inactiveIcon: Icons.history,
              activeIcon: Icons.history,
              label: l10n.history,
              isSelected: _selectedTab == 2,
              activeColor: notchColor,
              inactiveColor: inactiveItemColor,
              duration: _animDuration,
              onTap: () => _selectTab(2),
            ),
            _NavBarItem(
              inactiveIcon: Icons.settings_outlined,
              activeIcon: Icons.settings,
              label: l10n.setting,
              isSelected: _selectedTab == 3,
              activeColor: notchColor,
              inactiveColor: inactiveItemColor,
              duration: _animDuration,
              onTap: () => _selectTab(3),
            ),
          ],
        ),
      ),
    );
  }

  ShellDrawerDestination _drawerDestinationForTab(int tabIndex) {
    return switch (tabIndex) {
      1 => ShellDrawerDestination.stats,
      2 => ShellDrawerDestination.history,
      3 => ShellDrawerDestination.settings,
      _ => ShellDrawerDestination.home,
    };
  }
}

/// A single bottom-bar destination that animates its own icon swap
/// (outline -> filled) and color/scale change when selected, replacing
/// the notch-bar package's built-in item animation.
class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.inactiveIcon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.activeColor,
    required this.inactiveColor,
    required this.duration,
    required this.onTap,
  });

  final IconData inactiveIcon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final Color activeColor;
  final Color inactiveColor;
  final Duration duration;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? activeColor : inactiveColor;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: duration,
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? activeColor.withValues(alpha: 0.12)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: AnimatedSwitcher(
                  duration: duration,
                  transitionBuilder: (child, animation) => ScaleTransition(
                    scale: animation,
                    child: FadeTransition(opacity: animation, child: child),
                  ),
                  child: Icon(
                    isSelected ? activeIcon : inactiveIcon,
                    key: ValueKey<bool>(isSelected),
                    color: color,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: duration,
                curve: Curves.easeInOut,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
