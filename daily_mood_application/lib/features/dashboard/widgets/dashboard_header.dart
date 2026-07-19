import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../dashboard_formatters.dart';
import '../dashboard_palette.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({required this.onLogMood, this.now, super.key});

  final VoidCallback onLogMood;
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final today = now ?? DateTime.now();
    final l10n = context.l10n;
    final timeOfDayIcon = dashboardHeaderTimeOfDayIcon(today);
    final timeOfDayGreeting = dashboardHeaderTimeOfDayGreeting(today, l10n);

    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(
                timeOfDayIcon,
                key: const ValueKey('dashboard_time_of_day_icon'),
                color: DashboardPalette.purple,
                size: 30,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  timeOfDayGreeting,
                  key: const ValueKey('dashboard_time_of_day_greeting'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: DashboardPalette.deepText,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
        _HeaderPill(
          label: formatLocalizedCompactDate(today, l10n),
          icon: Icons.calendar_month_outlined,
          iconColor: DashboardPalette.purple,
        ),
        const SizedBox(width: 8),
        _StreakPill(onTap: onLogMood),
      ],
    );
  }
}

IconData dashboardHeaderTimeOfDayIcon(DateTime dateTime) {
  final hour = dateTime.hour;
  if (hour < 12) return Icons.wb_sunny_outlined;
  if (hour < 18) return Icons.light_mode_outlined;
  return Icons.nights_stay_outlined;
}

String dashboardHeaderTimeOfDayGreeting(
  DateTime dateTime,
  AppLocalizations l10n,
) {
  final hour = dateTime.hour;
  if (hour < 12) return l10n.goodMorning;
  if (hour < 18) return l10n.goodAfternoon;
  return l10n.goodNight;
}

class _HeaderPill extends StatelessWidget {
  const _HeaderPill({
    required this.label,
    required this.icon,
    required this.iconColor,
  });

  final String label;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: DashboardPalette.surface,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: DashboardPalette.deepText,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 6),
          Icon(icon, color: iconColor, size: 16),
        ],
      ),
    );
  }
}

class _StreakPill extends StatelessWidget {
  const _StreakPill({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: context.l10n.logMood,
      child: InkWell(
        key: const ValueKey('dashboard_log_mood_button'),
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Ink(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: DashboardPalette.surface,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            children: [
              Text('🔥', style: TextStyle(fontSize: 16)),
              SizedBox(width: 5),
              Text(
                '5',
                style: TextStyle(
                  color: DashboardPalette.deepText,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
