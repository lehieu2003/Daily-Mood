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

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  static const _animDuration = Duration(milliseconds: 300);

  // Bottom bar geometry — kept as constants so the clipper, the FAB
  // position, and the bar's own padding all agree with each other.
  static const _barHeight = 70.0;
  static const _fabDiameter = 56.0;
  static const _notchMargin = 8.0;
  static const _notchRadius = (_fabDiameter / 2) + _notchMargin;

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
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView(
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
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _CustomBottomBar(
              height: _barHeight,
              notchRadius: _notchRadius,
              backgroundColor: navSurface,
              selectedTab: _selectedTab,
              activeColor: notchColor,
              inactiveColor: inactiveItemColor,
              duration: _animDuration,
              onTabSelected: _selectTab,
              homeLabel: l10n.home,
              statsLabel: l10n.stats,
              historyLabel: l10n.history,
              settingsLabel: l10n.setting,
            ),
          ),
          Positioned(
            bottom: _barHeight - (_fabDiameter / 2),
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: _fabDiameter,
                height: _fabDiameter,
                child: FloatingActionButton(
                  onPressed: _onAddMoodTap,
                  backgroundColor: notchColor,
                  tooltip: l10n.addMood,
                  shape: const CircleBorder(),
                  elevation: 0,
                  highlightElevation: 0,
                  focusElevation: 0,
                  hoverElevation: 0,
                  disabledElevation: 0,
                  child: Icon(Icons.add, color: activeItemColor),
                ),
              ),
            ),
          ),
        ],
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

/// Replaces `BottomAppBar` + `CircularNotchedRectangle`.
///
/// This paints the same [Row] of [_NavBarItem]s inside a container that
/// is clipped by [_NotchClipper]. Because the clip path is built with
/// the even-odd fill rule (full rect MINUS a circle), the circle region
/// is never painted at all — it's a real hole, not just a shape drawn
/// in the background color. Whatever sits behind this widget in the
/// Stack (the PageView) shows straight through it.
class _CustomBottomBar extends StatelessWidget {
  const _CustomBottomBar({
    required this.height,
    required this.notchRadius,
    required this.backgroundColor,
    required this.selectedTab,
    required this.activeColor,
    required this.inactiveColor,
    required this.duration,
    required this.onTabSelected,
    required this.homeLabel,
    required this.statsLabel,
    required this.historyLabel,
    required this.settingsLabel,
  });

  final double height;
  final double notchRadius;
  final Color backgroundColor;
  final int selectedTab;
  final Color activeColor;
  final Color inactiveColor;
  final Duration duration;
  final ValueChanged<int> onTabSelected;
  final String homeLabel;
  final String statsLabel;
  final String historyLabel;
  final String settingsLabel;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _NotchClipper(notchRadius: notchRadius),
      child: Container(
        height: height,
        padding: EdgeInsets.zero,
        color: backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NavBarItem(
              inactiveIcon: Icons.home_outlined,
              activeIcon: Icons.home,
              label: homeLabel,
              isSelected: selectedTab == 0,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              duration: duration,
              onTap: () => onTabSelected(0),
            ),
            _NavBarItem(
              inactiveIcon: Icons.bar_chart_outlined,
              activeIcon: Icons.bar_chart,
              label: statsLabel,
              isSelected: selectedTab == 1,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              duration: duration,
              onTap: () => onTabSelected(1),
            ),
            // Gap reserved for the FAB's transparent notch.
            const SizedBox(width: 48),
            _NavBarItem(
              inactiveIcon: Icons.history,
              activeIcon: Icons.history,
              label: historyLabel,
              isSelected: selectedTab == 2,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              duration: duration,
              onTap: () => onTabSelected(2),
            ),
            _NavBarItem(
              inactiveIcon: Icons.settings_outlined,
              activeIcon: Icons.settings,
              label: settingsLabel,
              isSelected: selectedTab == 3,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              duration: duration,
              onTap: () => onTabSelected(3),
            ),
          ],
        ),
      ),
    );
  }
}

/// Clips a rectangle with a circular hole centered at the top-middle
/// edge, producing a genuine notch (not just a re-shaped silhouette).
///
/// Uses [PathFillType.evenOdd]: the outer rect and the inner circle
/// overlap, and even-odd fill means overlapping regions cancel out,
/// leaving the circle area completely unpainted (transparent) while
/// the rest of the rect paints normally.
class _NotchClipper extends CustomClipper<Path> {
  const _NotchClipper({required this.notchRadius});

  final double notchRadius;

  @override
  Path getClip(Size size) {
    final notchCenter = Offset(size.width / 2, 0);

    return Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addOval(Rect.fromCircle(center: notchCenter, radius: notchRadius));
  }

  @override
  bool shouldReclip(covariant _NotchClipper oldClipper) {
    return oldClipper.notchRadius != notchRadius;
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
