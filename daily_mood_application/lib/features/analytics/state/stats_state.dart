import '../../../domain/models/activity_mood_correlation.dart';
import '../../../domain/models/mood_distribution_item.dart';
import '../../../domain/models/monthly_mood_day.dart';
import '../../../domain/models/weekly_mood_point.dart';

enum StatsPeriod { week, month, year }

enum StatsLoadStatus { loading, ready, failure }

final class StatsRange {
  const StatsRange({required this.start, required this.end});

  final DateTime start;
  final DateTime end;

  factory StatsRange.forPeriod(StatsPeriod period, DateTime anchorDate) {
    final local = anchorDate.toLocal();
    return switch (period) {
      StatsPeriod.week => () {
        final day = DateTime(local.year, local.month, local.day);
        final start = day.subtract(Duration(days: day.weekday - 1));
        return StatsRange(
          start: start,
          end: start.add(const Duration(days: 7)),
        );
      }(),
      StatsPeriod.month => StatsRange(
        start: DateTime(local.year, local.month),
        end: DateTime(local.year, local.month + 1),
      ),
      StatsPeriod.year => StatsRange(
        start: DateTime(local.year),
        end: DateTime(local.year + 1),
      ),
    };
  }
}

final class StatsState {
  const StatsState({
    required this.status,
    required this.period,
    required this.anchorDate,
    required this.range,
    required this.calendarMonth,
    required this.weeklyTrend,
    required this.monthlyHeatmap,
    required this.activityCorrelations,
    required this.moodDistribution,
  });

  factory StatsState.initial(DateTime anchorDate) {
    final range = StatsRange.forPeriod(StatsPeriod.week, anchorDate);
    return StatsState(
      status: StatsLoadStatus.loading,
      period: StatsPeriod.week,
      anchorDate: anchorDate,
      range: range,
      calendarMonth: DateTime(anchorDate.year, anchorDate.month),
      weeklyTrend: const [],
      monthlyHeatmap: const [],
      activityCorrelations: const [],
      moodDistribution: const [],
    );
  }

  final StatsLoadStatus status;
  final StatsPeriod period;
  final DateTime anchorDate;
  final StatsRange range;
  final DateTime calendarMonth;
  final List<WeeklyMoodPoint> weeklyTrend;
  final List<MonthlyMoodDay> monthlyHeatmap;
  final List<ActivityMoodCorrelation> activityCorrelations;
  final List<MoodDistributionItem> moodDistribution;

  bool get isLoading => status == StatsLoadStatus.loading;
  bool get hasError => status == StatsLoadStatus.failure;

  StatsState copyWith({
    StatsLoadStatus? status,
    StatsPeriod? period,
    DateTime? anchorDate,
    StatsRange? range,
    DateTime? calendarMonth,
    List<WeeklyMoodPoint>? weeklyTrend,
    List<MonthlyMoodDay>? monthlyHeatmap,
    List<ActivityMoodCorrelation>? activityCorrelations,
    List<MoodDistributionItem>? moodDistribution,
  }) {
    return StatsState(
      status: status ?? this.status,
      period: period ?? this.period,
      anchorDate: anchorDate ?? this.anchorDate,
      range: range ?? this.range,
      calendarMonth: calendarMonth ?? this.calendarMonth,
      weeklyTrend: weeklyTrend ?? this.weeklyTrend,
      monthlyHeatmap: monthlyHeatmap ?? this.monthlyHeatmap,
      activityCorrelations: activityCorrelations ?? this.activityCorrelations,
      moodDistribution: moodDistribution ?? this.moodDistribution,
    );
  }
}
