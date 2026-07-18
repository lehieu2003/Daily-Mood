import '../../core/database/app_database.dart' as db;
import '../../domain/models/daily_reflection.dart';
import '../services/daily_reflection_local_service.dart';

final class DailyReflectionRepository {
  DailyReflectionRepository({required DailyReflectionLocalService localService})
    : _localService = localService;

  final DailyReflectionLocalService _localService;

  Stream<DailyReflectionModel?> watchReflectionForDate(DateTime date) {
    return _localService.watchReflectionForDate(date).map((reflection) {
      if (reflection == null) return null;
      return _toDomain(reflection);
    });
  }

  Future<void> saveReflection({
    required DateTime date,
    required String prompt,
    required String response,
  }) {
    return _localService.saveReflection(
      date: date,
      prompt: prompt,
      response: response,
    );
  }

  DailyReflectionModel _toDomain(db.DailyReflection reflection) {
    return DailyReflectionModel(
      id: reflection.id,
      uuid: reflection.uuid,
      date: _dateFromKey(reflection.dateKey),
      prompt: reflection.prompt,
      response: reflection.response,
      createdAt: reflection.createdAt,
      updatedAt: reflection.updatedAt,
    );
  }

  DateTime _dateFromKey(String dateKey) {
    final parts = dateKey.split('-');
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }
}
