import 'dart:convert';
import 'dart:io';

import 'package:daily_mood_application/core/database/app_database.dart';
import 'package:daily_mood_application/core/database/daos/activity_dao.dart';
import 'package:daily_mood_application/core/database/daos/daily_reflection_dao.dart';
import 'package:daily_mood_application/core/database/daos/mood_entry_dao.dart';
import 'package:daily_mood_application/features/settings/data/backup_export_service.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'builds JSON export with entries, tags, emotions, and media refs',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final activityDao = ActivityDao(db);
      final dailyReflectionDao = DailyReflectionDao(db);
      final moodEntryDao = MoodEntryDao(db);
      final documentsDirectory = await Directory.systemTemp.createTemp(
        'daily_mood_export_documents',
      );

      try {
        final photo = File('${documentsDirectory.path}/mood_photos/photo-1.jpg');
        await photo.parent.create(recursive: true);
        await photo.writeAsBytes([1, 2, 3, 4]);

        final activityId = await activityDao.createCustomActivity(
          name: 'Reading',
          category: 'Other',
        );
        final calm = await (db.select(
          db.subEmotions,
        )..where((row) => row.name.equals('Calm'))).getSingle();
        await moodEntryDao.createEntry(
          moodScore: 4,
          note: 'Quiet morning',
          photoRelativePath: 'mood_photos/photo-1.jpg',
          activityIds: [activityId],
          subEmotionIds: [calm.id],
        );
        await dailyReflectionDao.saveReflection(
          date: DateTime(2026, 7, 13, 20),
          prompt: 'What made today better?',
          response: 'Reading before bed.',
        );

        final service = DriftBackupExportService(
          database: db,
          clock: () => DateTime.utc(2026, 7, 13, 9, 30, 5),
          documentsDirectoryProvider: () async => documentsDirectory,
        );

        final file = await service.buildExport(BackupExportFormat.json);
        final json = jsonDecode(file.content) as Map<String, Object?>;
        final entries = json['moodEntries'] as List<Object?>;
        final entry = entries.single as Map<String, Object?>;
        final mediaFiles = json['mediaFiles'] as List<Object?>;
        final mediaFile = mediaFiles.single as Map<String, Object?>;
        final reflections = json['dailyReflections'] as List<Object?>;
        final reflection = reflections.single as Map<String, Object?>;

        expect(file.fileName, 'daily_mood_export_20260713_093005.json');
        expect(json['exportVersion'], 1);
        expect(json['schemaVersion'], db.schemaVersion);
        expect(json['mediaPackaging'], 'embedded_base64');
        expect(mediaFile['relativePath'], 'mood_photos/photo-1.jpg');
        expect(base64Decode(mediaFile['contentBase64']! as String), [
          1,
          2,
          3,
          4,
        ]);
        expect(json['activities'], isA<List<Object?>>());
        expect(entry['moodScore'], 4);
        expect(entry['note'], 'Quiet morning');
        expect(entry['photoRelativePath'], 'mood_photos/photo-1.jpg');
        expect(entry['activities'], ['Reading']);
        expect(entry['subEmotions'], ['Calm']);
        expect(entry['uuid'], isNotEmpty);
        expect(reflection['dateKey'], '2026-07-13');
        expect(reflection['prompt'], 'What made today better?');
        expect(reflection['response'], 'Reading before bed.');
        expect(reflection['uuid'], isNotEmpty);
      } finally {
        await db.close();
        if (documentsDirectory.existsSync()) {
          documentsDirectory.deleteSync(recursive: true);
        }
      }
    },
  );

  test('builds escaped CSV export for readable spreadsheet use', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final activityDao = ActivityDao(db);
    final moodEntryDao = MoodEntryDao(db);

    try {
      final activityId = await activityDao.createCustomActivity(
        name: 'Friends',
        category: 'Life',
      );
      await moodEntryDao.createEntry(
        moodScore: 5,
        note: 'Lunch, "great"',
        activityIds: [activityId],
      );

      final service = DriftBackupExportService(
        database: db,
        clock: () => DateTime.utc(2026, 7, 13),
      );

      final file = await service.buildExport(BackupExportFormat.csv);
      final lines = file.content.split('\n');

      expect(file.fileName, 'daily_mood_export_20260713_000000.csv');
      expect(lines.first, contains('"uuid","moodScore","note"'));
      expect(
        lines.singleWhere((line) => line.contains('Friends')),
        contains('"5"'),
      );
      expect(file.content, contains('"Lunch, ""great"""'));
    } finally {
      await db.close();
    }
  });
}
