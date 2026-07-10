import 'package:flutter/material.dart';

import '../dashboard_formatters.dart';
import '../dashboard_palette.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({required this.onLogMood, super.key});

  final VoidCallback onLogMood;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return Row(
      children: [
        Expanded(
          child: RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: const TextSpan(
              style: TextStyle(
                color: DashboardPalette.deepText,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              children: [
                TextSpan(text: 'Hey, '),
                TextSpan(
                  text: 'Alex!',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(text: '👋'),
              ],
            ),
          ),
        ),
        _HeaderPill(
          label: formatCompactDate(today),
          icon: Icons.calendar_month_outlined,
          iconColor: DashboardPalette.purple,
        ),
        const SizedBox(width: 8),
        _StreakPill(onTap: onLogMood),
      ],
    );
  }
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
            style: const TextStyle(
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
      message: 'Log mood',
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
          child: const Row(
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
