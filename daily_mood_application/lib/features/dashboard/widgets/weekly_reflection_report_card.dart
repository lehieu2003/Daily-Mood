import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/theme/app_typography.dart';
import '../dashboard_palette.dart';
import '../weekly_reflection_report.dart';
import 'dashboard_card_decoration.dart';

class WeeklyReflectionReportCard extends StatelessWidget {
  const WeeklyReflectionReportCard({required this.report, super.key});

  final WeeklyReflectionReport report;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      key: const ValueKey('weekly_reflection_report_card'),
      padding: const EdgeInsets.all(18),
      decoration: dashboardCardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: DashboardPalette.blue.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.summarize_rounded,
                  color: DashboardPalette.blue,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.weeklyReflectionReport,
                      style: AppTypography.subText3Regular,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.weeklyReportRange(report.weekStart, report.weekEnd),
                      style: AppTypography.heading2,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.weeklyReflectionReportSubtitle,
                      style: AppTypography.subText2Regular.copyWith(
                        color: DashboardPalette.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _takeaway(l10n),
            style: AppTypography.subText2Regular.copyWith(
              color: DashboardPalette.deepText,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MetricChip(
                label: l10n.weeklyReportCheckIns(
                  report.entryCount,
                  report.activeDayCount,
                ),
              ),
              _MetricChip(
                label: l10n.weeklyReportReflections(report.reflectionCount),
              ),
              if (report.averageMood != null)
                _MetricChip(
                  label:
                      '${l10n.weeklyReportAverageMoodLabel}: '
                      '${l10n.weeklyReportAverage(report.averageMood!)}',
                ),
              if (report.topEmotion != null)
                _MetricChip(
                  label:
                      '${l10n.topEmotion}: '
                      '${l10n.subEmotionLabel(report.topEmotion!.id, report.topEmotion!.name)}',
                ),
              if (report.topActivity != null)
                _MetricChip(
                  label:
                      '${l10n.topReason}: '
                      '${l10n.activityLabel(report.topActivity!.name)}',
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _takeaway(AppLocalizations l10n) {
    return switch (report.tone) {
      WeeklyReportTone.empty => l10n.weeklyReportEmpty,
      WeeklyReportTone.sparse => l10n.weeklyReportSparse,
      WeeklyReportTone.reflected => l10n.weeklyReportReflected,
      WeeklyReportTone.steady => l10n.weeklyReportSteady,
    };
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: DashboardPalette.lilacPanel,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Text(
          label,
          style: AppTypography.subText3Regular.copyWith(
            color: DashboardPalette.deepText,
          ),
        ),
      ),
    );
  }
}
