import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../guided_insights.dart';

class GuidedInsightsCard extends StatelessWidget {
  const GuidedInsightsCard({required this.insights, super.key});

  final List<GuidedInsight> insights;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      key: const ValueKey('guided_insights_card'),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.guidedInsights,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Icon(
                Icons.psychology_alt_outlined,
                color: colorScheme.primary,
                size: 22,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            l10n.guidedInsightsSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 14),
          for (var index = 0; index < insights.length; index++) ...[
            _InsightTile(insight: insights[index]),
            if (index != insights.length - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _InsightTile extends StatelessWidget {
  const _InsightTile({required this.insight});

  final GuidedInsight insight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_iconFor(insight.type), color: colorScheme.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _title(context, insight),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _body(context, insight),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.32,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(GuidedInsightType type) {
    return switch (type) {
      GuidedInsightType.activityLift => Icons.arrow_upward_rounded,
      GuidedInsightType.activityWeight => Icons.arrow_downward_rounded,
      GuidedInsightType.trendShift => Icons.timeline_rounded,
      GuidedInsightType.starter => Icons.edit_note_rounded,
    };
  }

  String _title(BuildContext context, GuidedInsight insight) {
    final l10n = context.l10n;
    return switch (insight.type) {
      GuidedInsightType.activityLift => l10n.activityLiftInsightTitle(
        l10n.activityLabel(insight.activityName ?? ''),
      ),
      GuidedInsightType.activityWeight => l10n.activityWeightInsightTitle(
        l10n.activityLabel(insight.activityName ?? ''),
      ),
      GuidedInsightType.trendShift => l10n.trendShiftInsightTitle,
      GuidedInsightType.starter => l10n.starterInsightTitle,
    };
  }

  String _body(BuildContext context, GuidedInsight insight) {
    final l10n = context.l10n;
    final activity = l10n.activityLabel(insight.activityName ?? '');
    return switch (insight.type) {
      GuidedInsightType.activityLift => l10n.activityLiftInsightBody(
        activityName: activity,
        activityAverage: insight.activityAverage ?? 0,
        overallAverage: insight.overallAverage ?? 0,
      ),
      GuidedInsightType.activityWeight => l10n.activityWeightInsightBody(
        activityName: activity,
        activityAverage: insight.activityAverage ?? 0,
        overallAverage: insight.overallAverage ?? 0,
      ),
      GuidedInsightType.trendShift => l10n.trendShiftInsightBody(
        recentAverage: insight.activityAverage ?? 0,
        earlierAverage: insight.overallAverage ?? 0,
      ),
      GuidedInsightType.starter => l10n.starterInsightBody,
    };
  }
}
