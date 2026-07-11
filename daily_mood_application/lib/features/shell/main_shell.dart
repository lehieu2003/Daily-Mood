import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/app_router.dart';
import '../../app/theme/app_colors.dart';
import '../dashboard/dashboard_screen.dart';
import '../dashboard/history_screen.dart';

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
    _pageController.jumpToPage(index);
  }

  void _openStatsTab() {
    _pageController.jumpToPage(1);
    _notchController.jumpTo(1);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final inactiveItemColor = AppColors.textTertiary;
    final activeItemColor = AppColors.primaryPurple;

    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          DashboardScreen(onOpenTrend: _openStatsTab),
          const _StatsTab(),
          const SizedBox.shrink(),
          const HistoryScreen(),
          const _SettingTab(),
        ],
      ),
      bottomNavigationBar: AnimatedNotchBottomBar(
        kIconSize: 30,
        notchBottomBarController: _notchController,
        color: colorScheme.surface,
        notchColor: colorScheme.primary,
        showLabel: true,
        durationInMilliSeconds: 300,
        itemLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        elevation: 4,
        kBottomRadius: 24,
        bottomBarItems: [
          BottomBarItem(
            inActiveItem: Icon(Icons.home_outlined, color: inactiveItemColor),
            activeItem: Icon(Icons.home, color: activeItemColor),
            itemLabel: 'Home',
          ),
          BottomBarItem(
            inActiveItem: Icon(
              Icons.bar_chart_outlined,
              color: inactiveItemColor,
            ),
            activeItem: Icon(Icons.bar_chart, color: activeItemColor),
            itemLabel: 'Stats',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.add, color: inactiveItemColor),
            activeItem: Icon(Icons.add, color: activeItemColor),
            itemLabel: 'Add mood',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.history, color: inactiveItemColor),
            activeItem: Icon(Icons.history, color: activeItemColor),
            itemLabel: 'History',
          ),
          BottomBarItem(
            inActiveItem: Icon(
              Icons.settings_outlined,
              color: inactiveItemColor,
            ),
            activeItem: Icon(Icons.settings, color: activeItemColor),
            itemLabel: 'Setting',
          ),
        ],
        onTap: _onTap,
      ),
    );
  }
}

// --- Tab placeholders ---------------------------------------------------
// Swap each of these for the real screens later; the shell/nav logic
// above won't need to change when you do.

class _StatsTab extends StatelessWidget {
  const _StatsTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stats')),
      body: const Center(child: Text('Stats — TODO')),
    );
  }
}

class _SettingTab extends StatelessWidget {
  const _SettingTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setting')),
      body: const Center(child: Text('Setting — TODO')),
    );
  }
}
