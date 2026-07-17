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

  test('watches custom activities and toggles archived state', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final dao = ActivityDao(db);

    try {
      final readingId = await dao.createCustomActivity(
        name: 'Reading',
        category: 'Other',
      );
      await dao.createCustomActivity(name: 'Sketching', category: 'Other');

      final customActivities = await dao.watchCustomActivities().first;

      expect(customActivities.map((activity) => activity.name), [
        'Reading',
        'Sketching',
      ]);
      expect(customActivities.every((activity) => activity.isCustom), isTrue);

      await dao.archiveActivity(readingId);
      final archived = await dao.watchCustomActivities().firstWhere((items) {
        return items.any(
          (activity) => activity.id == readingId && activity.isArchived,
        );
      });

      expect(archived.last.name, 'Reading');
      expect(
        await dao.watchActiveActivities().first,
        isNot(contains(isA<Activity>().having((a) => a.id, 'id', readingId))),
      );

      await dao.restoreActivity(readingId);
      final restored = await dao.watchCustomActivities().firstWhere((items) {
        return items.any(
          (activity) => activity.id == readingId && !activity.isArchived,
        );
      });

      expect(
        restored.singleWhere((activity) => activity.id == readingId).isArchived,
        isFalse,
      );
    } finally {
      await db.close();
    }
  });
}
