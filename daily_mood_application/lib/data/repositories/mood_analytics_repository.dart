import '../../domain/models/activity_mood_correlation.dart';
import '../../domain/models/mood_distribution_item.dart';
import '../../domain/models/monthly_mood_day.dart';
import '../../domain/models/weekly_mood_point.dart';
import '../services/mood_analytics_local_service.dart';

final class MoodAnalyticsRepository {
  MoodAnalyticsRepository({required MoodAnalyticsLocalService localService})
    : _localService = localService;

  final MoodAnalyticsLocalService _localService;

  Stream<List<WeeklyMoodPoint>> watchWeeklyMoodTrend(DateTime weekStart) {
    return _localService.watchWeeklyMoodTrend(weekStart);
  }

  Stream<List<MonthlyMoodDay>> watchMonthlyMoodHeatmap(DateTime month) {
    return _localService.watchMonthlyMoodHeatmap(month);
  }

  Stream<List<ActivityMoodCorrelation>> watchActivityMoodCorrelations({
    int limit = 6,
  }) {
    return _localService.watchActivityMoodCorrelations(limit: limit);
  }

  Stream<List<ActivityMoodCorrelation>> watchActivityMoodCorrelationsBetween({
    required DateTime start,
    required DateTime end,
    int limit = 6,
  }) {
    return _localService.watchActivityMoodCorrelationsBetween(
      start: start,
      end: end,
      limit: limit,
    );
  }

  Stream<List<MoodDistributionItem>> watchMoodDistribution(
    DateTime start,
    DateTime end,
  ) {
    return _localService.watchMoodDistribution(start, end);
  }
}
