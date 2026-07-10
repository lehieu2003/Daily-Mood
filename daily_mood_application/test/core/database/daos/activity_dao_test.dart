import 'package:daily_mood_application/core/database/app_database.dart';
import 'package:daily_mood_application/core/database/daos/activity_dao.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('creates a trimmed custom activity', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final dao = ActivityDao(db);

    try {
      final id = await dao.createCustomActivity(
        name: '  Reading  ',
        category: 'Other',
      );

      final activity = await (db.select(
        db.activities,
      )..where((row) => row.id.equals(id))).getSingle();
      expect(activity.name, 'Reading');
      expect(activity.category, 'Other');
      expect(activity.isCustom, isTrue);
      expect(activity.isArchived, isFalse);
      expect(activity.uuid, isNotEmpty);
    } finally {
      await db.close();
    }
  });

  test('rejects invalid custom activity names', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final dao = ActivityDao(db);

    try {
      expect(
        () => dao.createCustomActivity(name: '   ', category: 'Other'),
        throwsArgumentError,
      );
      expect(
        () => dao.createCustomActivity(
          name: 'This reason is too long',
          category: 'Other',
        ),
        throwsArgumentError,
      );
    } finally {
      await db.close();
    }
  });

  test('enforces the custom activity limit', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final dao = ActivityDao(db);

    try {
      for (var i = 0; i < ActivityDao.maxCustomTags; i++) {
        await dao.createCustomActivity(name: 'Custom $i', category: 'Other');
      }

      expect(
        () => dao.createCustomActivity(name: 'Overflow', category: 'Other'),
        throwsA(isA<ActivityLimitExceeded>()),
      );
    } finally {
      await db.close();
    }
  });
}
