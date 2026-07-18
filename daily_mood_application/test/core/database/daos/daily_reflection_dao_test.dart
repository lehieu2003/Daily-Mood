import 'package:daily_mood_application/core/database/app_database.dart';
import 'package:daily_mood_application/core/database/daos/daily_reflection_dao.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('saves one editable reflection per calendar date', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final dao = DailyReflectionDao(db);
    final date = DateTime(2026, 7, 18, 21);

    try {
      await dao.saveReflection(
        date: date,
        prompt: 'What made today better?',
        response: '  A quiet walk after work.  ',
      );

      final created = await dao.watchReflectionForDate(date).first;
      expect(created, isNotNull);
      expect(created!.dateKey, '2026-07-18');
      expect(created.prompt, 'What made today better?');
      expect(created.response, 'A quiet walk after work.');

      await dao.saveReflection(
        date: DateTime(2026, 7, 18, 8),
        prompt: 'What helped today?',
        response: 'Coffee and a clear plan.',
      );

      final rows = await db.select(db.dailyReflections).get();
      final updated = await dao.watchReflectionForDate(date).first;
      expect(rows, hasLength(1));
      expect(updated!.id, created.id);
      expect(updated.prompt, 'What helped today?');
      expect(updated.response, 'Coffee and a clear plan.');
    } finally {
      await db.close();
    }
  });
}
