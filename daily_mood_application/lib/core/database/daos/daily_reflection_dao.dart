import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../app_database.dart';

final class DailyReflectionDao {
  DailyReflectionDao(this.db);

  static const _uuid = Uuid();

  final AppDatabase db;

  Stream<DailyReflection?> watchReflectionForDate(DateTime date) {
    final dateKey = _dateKey(date);
    return (db.select(db.dailyReflections)
          ..where((reflection) => reflection.dateKey.equals(dateKey))
          ..limit(1))
        .watchSingleOrNull();
  }

  Future<void> saveReflection({
    required DateTime date,
    required String prompt,
    required String response,
  }) async {
    final dateKey = _dateKey(date);
    final now = DateTime.now();
    final normalizedResponse = response.trim();

    final existing = await (db.select(db.dailyReflections)
          ..where((reflection) => reflection.dateKey.equals(dateKey))
          ..limit(1))
        .getSingleOrNull();

    if (existing == null) {
      await db.into(db.dailyReflections).insert(
            DailyReflectionsCompanion.insert(
              uuid: _uuid.v4(),
              dateKey: dateKey,
              prompt: prompt,
              response: normalizedResponse,
              createdAt: now,
              updatedAt: now,
            ),
          );
      return;
    }

    await (db.update(db.dailyReflections)
          ..where((reflection) => reflection.id.equals(existing.id)))
        .write(
      DailyReflectionsCompanion(
        prompt: Value(prompt),
        response: Value(normalizedResponse),
        updatedAt: Value(now),
      ),
    );
  }

  static String _dateKey(DateTime date) {
    final local = date.toLocal();
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '${local.year}-$month-$day';
  }
}
