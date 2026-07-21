import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
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

/// Persistent bottom-nav shell built on `animated_notch_bottom_bar`.
///
/// Home / Stats / History / Setting live in a [PageView] driven by a
/// [PageController]; [NotchBottomBarController] animates the notch to
/// match. "Add mood" (index 2) is NOT a tab — it's a floating action
/// item that pushes the existing [AppRoutes.quickLog] route, then snaps
/// the notch back to whichever tab the PageView is still showing.
///
/// Drop-in replacement for the old `_HomePlaceholder` — mount it at
/// [AppRoutes.home] and nothing else in the router needs to change.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final _pageController = PageController(initialPage: 0);
  final _notchController = NotchBottomBarController(index: 0);
  int _selectedTab = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    if (index == 2) {
      // "Add mood" is an action, not a page: push Quick Log and, once
      // the user comes back, snap the notch to the real tab underneath.
      final currentTab = _pageController.page?.round() ?? 0;
      context.push(AppRoutes.quickLog).then((_) {
        if (mounted) _notchController.jumpTo(currentTab);
      });
      return;
    }
    _selectTab(index);
  }

  void _openStatsTab() {
    _selectTab(1);
  }

  void _selectTab(int index) {
    setState(() => _selectedTab = index);
    _pageController.jumpToPage(index);
    _notchController.jumpTo(index);
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
        _onTap(2);
        break;
      case ShellDrawerDestination.history:
        _selectTab(3);
        break;
      case ShellDrawerDestination.settings:
        _selectTab(4);
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
        children: [
          DashboardScreen(onOpenTrend: _openStatsTab),
          const StatsScreen(),
          const SizedBox.shrink(),
          const HistoryScreen(),
          const SettingsScreen(),
        ],
      ),
      bottomNavigationBar: AnimatedNotchBottomBar(
        kIconSize: 30,
        notchBottomBarController: _notchController,
        color: navSurface,
        notchColor: notchColor,
        showLabel: false,
        durationInMilliSeconds: 300,
        itemLabelStyle: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        elevation: 4,
        kBottomRadius: 24,
        bottomBarItems: [
          BottomBarItem(
            inActiveItem: Icon(Icons.home_outlined, color: inactiveItemColor),
            activeItem: Icon(Icons.home, color: activeItemColor),
            itemLabel: l10n.home,
          ),
          BottomBarItem(
            inActiveItem: Icon(
              Icons.bar_chart_outlined,
              color: inactiveItemColor,
            ),
            activeItem: Icon(Icons.bar_chart, color: activeItemColor),
            itemLabel: l10n.stats,
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.add, color: inactiveItemColor),
            activeItem: Icon(Icons.add, color: activeItemColor),
            itemLabel: l10n.addMood,
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.history, color: inactiveItemColor),
            activeItem: Icon(Icons.history, color: activeItemColor),
            itemLabel: l10n.history,
          ),
          BottomBarItem(
            inActiveItem: Icon(
              Icons.settings_outlined,
              color: inactiveItemColor,
            ),
            activeItem: Icon(Icons.settings, color: activeItemColor),
            itemLabel: l10n.setting,
          ),
        ],
        onTap: _onTap,
      ),
    );
  }

  ShellDrawerDestination _drawerDestinationForTab(int tabIndex) {
    return switch (tabIndex) {
      1 => ShellDrawerDestination.stats,
      3 => ShellDrawerDestination.history,
      4 => ShellDrawerDestination.settings,
      _ => ShellDrawerDestination.home,
    };
  }
}
