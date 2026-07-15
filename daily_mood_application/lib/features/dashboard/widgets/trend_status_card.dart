import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
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
    final l10n = context.l10n;

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
                Text(l10n.weeklyTrend, style: AppTypography.heading3),
                const SizedBox(height: 6),
                Text(
                  l10n.logMoreMoodsForTrend(remaining),
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
              context.l10n.weeklyTrendReady,
              style: AppTypography.subText2Regular,
            ),
          ),
        ],
      ),
    );
  }
}
