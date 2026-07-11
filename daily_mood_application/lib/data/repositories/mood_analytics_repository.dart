import '../../domain/models/weekly_mood_point.dart';
import '../services/mood_analytics_local_service.dart';

final class MoodAnalyticsRepository {
  MoodAnalyticsRepository({required MoodAnalyticsLocalService localService})
    : _localService = localService;

  final MoodAnalyticsLocalService _localService;

  Stream<List<WeeklyMoodPoint>> watchWeeklyMoodTrend(DateTime weekStart) {
    return _localService.watchWeeklyMoodTrend(weekStart);
  }
}
