import '../../domain/models/activity_mood_correlation.dart';
import '../../domain/models/mood_distribution_item.dart';
import '../../domain/models/weekly_mood_point.dart';

enum GuidedInsightType { activityLift, activityWeight, trendShift, starter }

final class GuidedInsight {
  const GuidedInsight({
    required this.type,
    this.activityName,
    this.activityAverage,
    this.overallAverage,
    this.entryCount = 0,
  });

  final GuidedInsightType type;
  final String? activityName;
  final double? activityAverage;
  final double? overallAverage;
  final int entryCount;
}

List<GuidedInsight> buildGuidedInsights({
  required List<WeeklyMoodPoint> weeklyTrend,
  required List<ActivityMoodCorrelation> activityCorrelations,
  required List<MoodDistributionItem> moodDistribution,
  int maxCount = 3,
}) {
  final insights = <GuidedInsight>[];
  final totalEntries = _totalEntries(weeklyTrend, moodDistribution);
  final overallAverage = _overallAverage(weeklyTrend, moodDistribution);

  if (totalEntries < 3 || overallAverage == null) {
    return const [
      GuidedInsight(type: GuidedInsightType.starter, entryCount: 0),
    ];
  }

  insights.addAll(
    _activityInsights(
      activityCorrelations: activityCorrelations,
      overallAverage: overallAverage,
    ),
  );

  final trendInsight = _trendInsight(weeklyTrend);
  if (trendInsight != null) insights.add(trendInsight);

  if (insights.isEmpty) {
    insights.add(
      GuidedInsight(type: GuidedInsightType.starter, entryCount: totalEntries),
    );
  }

  return insights.take(maxCount).toList(growable: false);
}

List<GuidedInsight> _activityInsights({
  required List<ActivityMoodCorrelation> activityCorrelations,
  required double overallAverage,
}) {
  final repeated = activityCorrelations
      .where((correlation) => correlation.entryCount >= 2)
      .toList(growable: false);
  final lower =
      repeated
          .where(
            (correlation) => correlation.averageMood <= overallAverage - 0.4,
          )
          .toList()
        ..sort((a, b) => a.averageMood.compareTo(b.averageMood));
  final higher =
      repeated
          .where(
            (correlation) => correlation.averageMood >= overallAverage + 0.4,
          )
          .toList()
        ..sort((a, b) => b.averageMood.compareTo(a.averageMood));

  return [
    if (lower.isNotEmpty)
      GuidedInsight(
        type: GuidedInsightType.activityWeight,
        activityName: lower.first.activityName,
        activityAverage: lower.first.averageMood,
        overallAverage: overallAverage,
        entryCount: lower.first.entryCount,
      ),
    if (higher.isNotEmpty)
      GuidedInsight(
        type: GuidedInsightType.activityLift,
        activityName: higher.first.activityName,
        activityAverage: higher.first.averageMood,
        overallAverage: overallAverage,
        entryCount: higher.first.entryCount,
      ),
  ];
}

GuidedInsight? _trendInsight(List<WeeklyMoodPoint> weeklyTrend) {
  final points = weeklyTrend
      .where((point) => point.averageMood != null && point.entryCount > 0)
      .toList(growable: false);
  if (points.length < 4) return null;

  final midpoint = (points.length / 2).floor();
  final earlier = _average(
    points.take(midpoint).map((point) => point.averageMood!),
  );
  final recent = _average(
    points.skip(midpoint).map((point) => point.averageMood!),
  );
  final delta = recent - earlier;
  if (delta.abs() < 0.4) return null;

  return GuidedInsight(
    type: GuidedInsightType.trendShift,
    activityAverage: recent,
    overallAverage: earlier,
    entryCount: points.fold<int>(0, (sum, point) => sum + point.entryCount),
  );
}

int _totalEntries(
  List<WeeklyMoodPoint> weeklyTrend,
  List<MoodDistributionItem> moodDistribution,
) {
  if (moodDistribution.isNotEmpty) return moodDistribution.first.totalCount;
  return weeklyTrend.fold<int>(0, (sum, point) => sum + point.entryCount);
}

double? _overallAverage(
  List<WeeklyMoodPoint> weeklyTrend,
  List<MoodDistributionItem> moodDistribution,
) {
  if (moodDistribution.isNotEmpty) {
    final total = moodDistribution.first.totalCount;
    if (total == 0) return null;
    final weighted = moodDistribution.fold<int>(
      0,
      (sum, item) => sum + item.moodScore * item.entryCount,
    );
    return weighted / total;
  }

  final weighted = weeklyTrend.fold<double>(
    0,
    (sum, point) => sum + (point.averageMood ?? 0) * point.entryCount,
  );
  final count = weeklyTrend.fold<int>(
    0,
    (sum, point) => sum + point.entryCount,
  );
  if (count == 0) return null;
  return weighted / count;
}

double _average(Iterable<double> values) {
  final list = values.toList(growable: false);
  final total = list.fold<double>(0, (sum, value) => sum + value);
  return total / list.length;
}
