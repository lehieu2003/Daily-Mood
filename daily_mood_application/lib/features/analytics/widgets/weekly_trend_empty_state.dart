import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

class WeeklyTrendEmptyState extends StatelessWidget {
  const WeeklyTrendEmptyState({required this.entryCount, super.key});

  final int entryCount;

  @override
  Widget build(BuildContext context) {
    final remaining = (3 - entryCount).clamp(1, 3);

    return Container(
      key: const ValueKey('weekly_trend_empty_state'),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.lavender.withValues(alpha: 0.72),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.show_chart_rounded,
              color: AppColors.primaryPurple,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Weekly trend',
                  style: TextStyle(
                    color: AppColors.primaryPurple,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Log $remaining more mood ${remaining == 1 ? 'entry' : 'entries'} to unlock the chart.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
