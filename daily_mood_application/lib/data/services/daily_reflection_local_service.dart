import '../../core/database/app_database.dart';
import '../../core/database/daos/daily_reflection_dao.dart';

final class DailyReflectionLocalService {
  DailyReflectionLocalService({required DailyReflectionDao dao}) : _dao = dao;

  final DailyReflectionDao _dao;

  Stream<DailyReflection?> watchReflectionForDate(DateTime date) {
    return _dao.watchReflectionForDate(date);
  }

  Future<void> saveReflection({
    required DateTime date,
    required String prompt,
    required String response,
  }) {
    return _dao.saveReflection(
      date: date,
      prompt: prompt,
      response: response,
    );
  }
}
