import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';
import 'package:sqlite3/open.dart';
import 'package:uuid/uuid.dart';

import '../security/db_key_manager.dart';
import 'tables/tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    MoodEntries,
    Activities,
    MoodEntryActivities,
    SubEmotions,
    MoodEntrySubEmotions,
    MoodPhotos,
    DailyReflections,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : this._(_openEncryptedConnection());

  AppDatabase.forTesting(QueryExecutor executor) : this._(executor);

  AppDatabase._(super.executor);

  // Bump this every time a table/column changes and add a matching
  // migration step below. Never use a destructive migration once the
  // app has shipped — that drops user data.
  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      await _seedDefaultActivities();
      await _seedDefaultSubEmotions();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.addColumn(moodEntries, moodEntries.voiceNotePath);
        await m.createTable(subEmotions);
        await m.createTable(moodEntrySubEmotions);
      }
      if (from < 3) {
        await m.createTable(dailyReflections);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      await _seedDefaultActivities();
      await _seedDefaultSubEmotions();
    },
  );

  Future<void> _seedDefaultActivities() async {
    const uuid = Uuid();
    final now = DateTime.now();

    final defaults = <(String, String)>[
      ('Work', 'Life'),
      ('Exercise', 'Health'),
      ('Social', 'Life'),
      ('Sleep', 'Health'),
      ('Nutrition', 'Health'),
      ('Family', 'Life'),
      ('Hobbies', 'Life'),
      ('Self esteem', 'Life'),
      ('Breakup', 'Life'),
      ('Weather', 'Other'),
      ('Wife', 'Life'),
      ('Party', 'Life'),
      ('Love', 'Life'),
      ('Food', 'Health'),
    ];

    for (final entry in defaults) {
      await into(activities).insert(
        ActivitiesCompanion.insert(
          uuid: uuid.v4(),
          name: entry.$1,
          category: entry.$2,
          isCustom: const Value(false),
          createdAt: now,
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }

    final seededActivities = await select(activities).get();
    debugPrint(
      '[DailyMood][reasons] activities table count after seed: '
      '${seededActivities.length}; names: '
      '${seededActivities.map((activity) => activity.name).join(', ')}',
    );
  }

  Future<void> _seedDefaultSubEmotions() async {
    final defaults = <(int, String, String, int)>[
      (1, 'Angry', 'pouting-face', 1),
      (2, 'Overwhelmed', 'woozy-face', 1),
      (3, 'Sad', 'disappointed-face', 1),
      (4, 'Anxious', 'anxious-face-with-sweat', 2),
      (5, 'Tired', 'grinning-face-with-sweat', 2),
      (6, 'Down', 'nauseated-face', 2),
      (7, 'Neutral', 'neutral-face', 3),
      (8, 'Confused', 'confused-face', 3),
      (9, 'Routine', 'face-with-open-mouth', 3),
      (10, 'Calm', 'smiling-face-with-halo', 4),
      (11, 'Satisfied', 'smiling-face-with-hearts', 4),
      (12, 'Stable', 'hugging-face', 4),
      (13, 'Excited', 'winking-face-with-tongue', 5),
      (14, 'Proud', 'smiling-face-with-heart-eyes', 5),
      (15, 'Energized', 'star-struck', 5),
    ];

    for (final entry in defaults) {
      await into(subEmotions).insert(
        SubEmotionsCompanion.insert(
          id: Value(entry.$1),
          name: entry.$2,
          emoji: entry.$3,
          parentMoodScore: entry.$4,
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
  }

  Future<void> deleteAllLocalData() {
    return transaction(() async {
      await delete(moodPhotos).go();
      await delete(moodEntrySubEmotions).go();
      await delete(moodEntryActivities).go();
      await delete(dailyReflections).go();
      await delete(moodEntries).go();
      await delete(activities).go();
      await delete(subEmotions).go();
      await _seedDefaultActivities();
      await _seedDefaultSubEmotions();
    });
  }

  Future<void> rekey(String passphrase) {
    return customStatement("PRAGMA rekey = '$passphrase';");
  }
}

LazyDatabase _openEncryptedConnection() {
  return LazyDatabase(() async {
    // Ensures the correct SQLCipher-enabled sqlite3 binaries are loaded
    // on both Android and iOS before opening any connection.
    await applyWorkaroundToOpenSqlCipherOnOldAndroidVersions();
    _setupSqlCipherForCurrentIsolate();

    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'daily_mood.db'));

    final passphrase = await DbKeyManager.getOrCreateKey();

    return NativeDatabase.createInBackground(
      file,
      isolateSetup: _setupSqlCipherForCurrentIsolate,
      setup: (rawDb) {
        rawDb.execute("PRAGMA key = '$passphrase';");
        // Sanity check: this throws if the key is wrong / db is corrupt,
        // instead of silently returning an unreadable, empty-looking db.
        rawDb.execute('SELECT count(*) FROM sqlite_master;');
      },
    );
  });
}

void _setupSqlCipherForCurrentIsolate() {
  open.overrideFor(OperatingSystem.android, openCipherOnAndroid);
}
