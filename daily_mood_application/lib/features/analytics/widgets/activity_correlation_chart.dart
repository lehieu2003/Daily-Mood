import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/theme/app_colors.dart';
import '../../../domain/models/activity_mood_correlation.dart';
import 'activity_correlation_empty_state.dart';

class ActivityCorrelationChart extends StatelessWidget {
  const ActivityCorrelationChart({required this.correlations, super.key});

  final List<ActivityMoodCorrelation> correlations;

  @override
  Widget build(BuildContext context) {
    if (correlations.isEmpty) {
      return const ActivityCorrelationEmptyState();
    }

    final maxCount = correlations
        .map((correlation) => correlation.entryCount)
        .fold<int>(1, (max, count) => count > max ? count : max);
    final l10n = context.l10n;

    return Container(
      key: const ValueKey('activity_correlation_chart'),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.activityImpact,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Icon(
                Icons.bar_chart_rounded,
                color: AppColors.textTertiary,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 14),
          for (var index = 0; index < correlations.length; index++) ...[
            _ActivityCorrelationBar(
              correlation: correlations[index],
              color:
                  AppColors.chartPalette[index % AppColors.chartPalette.length],
              maxCount: maxCount,
            ),
            if (index != correlations.length - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _ActivityCorrelationBar extends StatelessWidget {
  const _ActivityCorrelationBar({
    required this.correlation,
    required this.color,
    required this.maxCount,
  });

  final ActivityMoodCorrelation correlation;
  final Color color;
  final int maxCount;

  @override
  Widget build(BuildContext context) {
    final fraction = correlation.entryCount / maxCount;
    final l10n = context.l10n;
    final activityName = l10n.activityLabel(correlation.activityName);

    return Semantics(
      label: l10n.activityCorrelationSemantics(
        activityName: activityName,
        count: correlation.entryCount,
        average: correlation.averageMood,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  activityName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                l10n.averageMood(correlation.averageMood),
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: Stack(
                    children: [
                      Container(
                        height: 12,
                        color: AppColors.textPrimary.withValues(alpha: 0.07),
                      ),
                      FractionallySizedBox(
                        widthFactor: fraction,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOut,
                          height: 12,
                          decoration: BoxDecoration(color: color),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 58,
                child: Text(
                  l10n.entryCount(correlation.entryCount),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
