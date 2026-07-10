import 'package:flutter/material.dart';

import '../../../app/theme/app_typography.dart';
import 'dashboard_card_decoration.dart';
import 'soft_icon.dart';

class TrendStatusCard extends StatelessWidget {
  const TrendStatusCard({required this.entryCount, super.key});

  final int entryCount;

  @override
  Widget build(BuildContext context) {
    if (entryCount >= 3) {
      return const _TrendReadyCard();
    }

    final remaining = 3 - entryCount;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: dashboardCardDecoration(context),
      child: Row(
        children: [
          const SoftIcon(icon: Icons.show_chart),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Weekly trend', style: AppTypography.heading3),
                const SizedBox(height: 6),
                Text(
                  remaining == 1
                      ? 'Log 1 more mood to unlock your first trend.'
                      : 'Log $remaining more moods to unlock your first trend.',
                  style: AppTypography.subText2Regular,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendReadyCard extends StatelessWidget {
  const _TrendReadyCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: dashboardCardDecoration(context),
      child: Row(
        children: [
          const SoftIcon(icon: Icons.show_chart),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Weekly trend is ready for the next analytics slice.',
              style: AppTypography.subText2Regular,
            ),
          ),
        ],
      ),
    );
  }
}
