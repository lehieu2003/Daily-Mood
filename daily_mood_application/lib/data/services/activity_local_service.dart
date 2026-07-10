import '../../core/database/app_database.dart';
import '../../core/database/daos/activity_dao.dart';

final class ActivityLocalService {
  ActivityLocalService({required ActivityDao activityDao})
    : _activityDao = activityDao;

  final ActivityDao _activityDao;

  Stream<List<Activity>> watchActiveActivities() {
    return _activityDao.watchActiveActivities();
  }

  Future<int> createCustomActivity({
    required String name,
    required String category,
  }) {
    return _activityDao.createCustomActivity(name: name, category: category);
  }
}
