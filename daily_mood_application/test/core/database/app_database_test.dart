import 'dart:io';

import 'package:daily_mood_application/core/database/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite3;

void main() {
  test('creates target schema and seeds default activities', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());

    try {
      final activities = await db.select(db.activities).get();
      expect(activities.length, 14);
      expect(
        activities.map((activity) => activity.name),
        containsAll([
          'Work',
          'Family',
          'Self esteem',
          'Sleep',
          'Social',
          'Hobbies',
          'Breakup',
          'Weather',
          'Wife',
          'Party',
          'Love',
          'Food',
        ]),
      );

      final moodEntryColumns = await db
          .customSelect('PRAGMA table_info(mood_entries)')
          .get();
      expect(
        moodEntryColumns.map((row) => row.data['name']),
        contains('voice_note_path'),
      );

      final tableRows = await db
          .customSelect(
            "SELECT name FROM sqlite_master WHERE type = 'table' "
            "AND name IN ('sub_emotions', 'mood_entry_sub_emotions')",
          )
          .get();
      expect(
        tableRows.map((row) => row.data['name']),
        containsAll(['sub_emotions', 'mood_entry_sub_emotions']),
      );

      final subEmotions = await db.select(db.subEmotions).get();
      expect(subEmotions, hasLength(15));
      expect(
        subEmotions.map((subEmotion) => subEmotion.name),
        containsAll(['Calm', 'Satisfied', 'Energized']),
      );
    } finally {
      await db.close();
    }
  });

  test('migrates schema version 1 data to schema version 2', () async {
    final tempDir = await Directory.systemTemp.createTemp(
      'daily_mood_migration_test_',
    );
    final dbFile = File('${tempDir.path}/daily_mood_v1.sqlite');

    _createVersion1Database(dbFile);

    final db = AppDatabase.forTesting(NativeDatabase(dbFile));

    try {
      final versionRow = await db
          .customSelect('PRAGMA user_version')
          .getSingle();
      expect(versionRow.data['user_version'], 2);

      final entries = await db.select(db.moodEntries).get();
      expect(entries, hasLength(1));
      expect(entries.single.uuid, 'mood-entry-1');
      expect(entries.single.moodScore, 4);
      expect(entries.single.note, 'Old schema note');
      expect(entries.single.voiceNotePath, isNull);

      final activities = await db.select(db.activities).get();
      expect(activities, hasLength(14));
      expect(
        activities.map((activity) => activity.uuid),
        contains('activity-1'),
      );
      expect(
        activities.map((activity) => activity.name),
        containsAll(['Work', 'Self esteem', 'Sleep', 'Food']),
      );

      final links = await db.select(db.moodEntryActivities).get();
      expect(links, hasLength(1));
      expect(links.single.moodEntryId, entries.single.id);
      expect(links.single.activityId, 1);

      final photos = await db.select(db.moodPhotos).get();
      expect(photos, hasLength(1));
      expect(photos.single.moodEntryId, entries.single.id);
      expect(photos.single.relativePath, 'mood_photos/old-photo.jpg');

      final moodEntryColumns = await db
          .customSelect('PRAGMA table_info(mood_entries)')
          .get();
      expect(
        moodEntryColumns.map((row) => row.data['name']),
        contains('voice_note_path'),
      );

      final tableRows = await db
          .customSelect(
            "SELECT name FROM sqlite_master WHERE type = 'table' "
            "AND name IN ('sub_emotions', 'mood_entry_sub_emotions')",
          )
          .get();
      expect(
        tableRows.map((row) => row.data['name']),
        containsAll(['sub_emotions', 'mood_entry_sub_emotions']),
      );

      final calmSubEmotion = await (db.select(
        db.subEmotions,
      )..where((subEmotion) => subEmotion.name.equals('Calm'))).getSingle();
      await db.customStatement(
        "INSERT INTO mood_entry_sub_emotions (mood_entry_id, sub_emotion_id) "
        "VALUES (${entries.single.id}, ${calmSubEmotion.id})",
      );

      final subEmotionLinks = await db
          .customSelect('SELECT COUNT(*) AS count FROM mood_entry_sub_emotions')
          .getSingle();
      expect(subEmotionLinks.data['count'], 1);

      final subEmotions = await db.select(db.subEmotions).get();
      expect(subEmotions, hasLength(15));
      expect(
        subEmotions.map((subEmotion) => subEmotion.name),
        containsAll(['Calm', 'Satisfied', 'Energized']),
      );
    } finally {
      await db.close();
      await tempDir.delete(recursive: true);
    }
  });
}

void _createVersion1Database(File file) {
  final rawDb = sqlite3.sqlite3.open(file.path);
  final now = DateTime(2026, 7, 9).millisecondsSinceEpoch;

  try {
    rawDb.execute('PRAGMA foreign_keys = ON');
    rawDb.execute('''
CREATE TABLE mood_entries (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  uuid TEXT NOT NULL UNIQUE,
  mood_score INTEGER NOT NULL CHECK (mood_score BETWEEN 1 AND 5),
  note TEXT,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  is_deleted INTEGER NOT NULL DEFAULT 0 CHECK ("is_deleted" IN (0, 1))
);
''');
    rawDb.execute('''
CREATE TABLE activities (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  uuid TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL CHECK (length(name) >= 1 AND length(name) <= 20),
  category TEXT NOT NULL,
  is_custom INTEGER NOT NULL DEFAULT 0 CHECK ("is_custom" IN (0, 1)),
  is_archived INTEGER NOT NULL DEFAULT 0 CHECK ("is_archived" IN (0, 1)),
  created_at INTEGER NOT NULL,
  UNIQUE (name)
);
''');
    rawDb.execute('''
CREATE TABLE mood_entry_activities (
  mood_entry_id INTEGER NOT NULL REFERENCES mood_entries (id) ON DELETE CASCADE,
  activity_id INTEGER NOT NULL REFERENCES activities (id) ON DELETE RESTRICT,
  PRIMARY KEY (mood_entry_id, activity_id)
);
''');
    rawDb.execute('''
CREATE TABLE mood_photos (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  mood_entry_id INTEGER NOT NULL UNIQUE REFERENCES mood_entries (id) ON DELETE CASCADE,
  relative_path TEXT NOT NULL,
  created_at INTEGER NOT NULL
);
''');
    rawDb.execute('''
INSERT INTO mood_entries
  (id, uuid, mood_score, note, created_at, updated_at, is_deleted)
VALUES
  (1, 'mood-entry-1', 4, 'Old schema note', $now, $now, 0);
''');
    rawDb.execute('''
INSERT INTO activities
  (id, uuid, name, category, is_custom, is_archived, created_at)
VALUES
  (1, 'activity-1', 'Work', 'Life', 0, 0, $now);
''');
    rawDb.execute('''
INSERT INTO mood_entry_activities (mood_entry_id, activity_id)
VALUES (1, 1);
''');
    rawDb.execute('''
INSERT INTO mood_photos (id, mood_entry_id, relative_path, created_at)
VALUES (1, 1, 'mood_photos/old-photo.jpg', $now);
''');
    rawDb.execute('PRAGMA user_version = 1');
  } finally {
    rawDb.dispose();
  }
}
