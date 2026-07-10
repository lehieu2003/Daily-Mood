import '../../core/database/app_database.dart' as db;
import '../../domain/models/mood_activity.dart';
import '../services/activity_local_service.dart';

final class ActivityRepository {
  ActivityRepository({required ActivityLocalService localService})
    : _localService = localService;

  final ActivityLocalService _localService;

  Stream<List<MoodActivity>> watchActiveActivities() {
    return _localService.watchActiveActivities().map(
      (activities) => activities.map(_toDomain).toList(growable: false),
    );
  }

  Future<int> createCustomActivity({
    required String name,
    String category = 'Other',
  }) {
    return _localService.createCustomActivity(name: name, category: category);
  }

  MoodActivity _toDomain(db.Activity activity) {
    return MoodActivity(
      id: activity.id,
      name: activity.name,
      category: activity.category,
      isCustom: activity.isCustom,
    );
  }
}
