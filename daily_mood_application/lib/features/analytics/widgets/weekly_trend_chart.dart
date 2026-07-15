import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/theme/app_colors.dart';
import '../../../domain/models/weekly_mood_point.dart';
import '../../dashboard/dashboard_formatters.dart';
import 'weekly_trend_empty_state.dart';

class WeeklyTrendChart extends StatelessWidget {
  const WeeklyTrendChart({required this.points, super.key});

  final List<WeeklyMoodPoint> points;

  @override
  Widget build(BuildContext context) {
    final entryCount = points.fold<int>(
      0,
      (total, point) => total + point.entryCount,
    );

    if (entryCount < 3) {
      return WeeklyTrendEmptyState(entryCount: entryCount);
    }

    final spots = <FlSpot>[
      for (var index = 0; index < points.length; index++)
        if (points[index].averageMood != null)
          FlSpot(index.toDouble(), points[index].averageMood!),
    ];

    if (spots.length < 2) {
      return WeeklyTrendEmptyState(entryCount: entryCount);
    }

    final lineColor = moodColor(_latestRoundedMood(points));
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
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
                  l10n.weeklyTrend,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                l10n.entryCount(entryCount),
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: LineChart(
              key: const ValueKey('weekly_trend_line_chart'),
              LineChartData(
                minX: 0,
                maxX: 6,
                minY: 1,
                maxY: 5,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: AppColors.textPrimary.withValues(alpha: 0.08),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= _dayLabels.length) {
                          return const SizedBox.shrink();
                        }

                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            l10n.weekdayShort(index + 1),
                            style: TextStyle(
                              color: AppColors.textTertiary,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return [
                        for (final spot in touchedSpots)
                          LineTooltipItem(
                            l10n.moodTooltip(spot.y),
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                      ];
                    },
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    preventCurveOverShooting: true,
                    color: lineColor,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: lineColor.withValues(alpha: 0.14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _latestRoundedMood(List<WeeklyMoodPoint> points) {
    final latest = points
        .where((point) => point.averageMood != null)
        .last
        .averageMood!;
    return latest.round().clamp(1, 5);
  }
}

const _dayLabels = [0, 1, 2, 3, 4, 5, 6];
