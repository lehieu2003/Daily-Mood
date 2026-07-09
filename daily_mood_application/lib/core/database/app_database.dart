import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
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
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      await _seedDefaultActivities();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.addColumn(moodEntries, moodEntries.voiceNotePath);
        await m.createTable(subEmotions);
        await m.createTable(moodEntrySubEmotions);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
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
    ];

    await batch((b) {
      b.insertAll(
        activities,
        defaults
            .map(
              (entry) => ActivitiesCompanion.insert(
                uuid: uuid.v4(),
                name: entry.$1,
                category: entry.$2,
                isCustom: const Value(false),
                createdAt: now,
              ),
            )
            .toList(),
      );
    });
  }
}

LazyDatabase _openEncryptedConnection() {
  return LazyDatabase(() async {
    // Ensures the correct SQLCipher-enabled sqlite3 binaries are loaded
    // on both Android and iOS before opening any connection.
    await applyWorkaroundToOpenSqlCipherOnOldAndroidVersions();
    open.overrideFor(OperatingSystem.android, openCipherOnAndroid);

    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'daily_mood.db'));

    final passphrase = await DbKeyManager.getOrCreateKey();

    return NativeDatabase.createInBackground(
      file,
      setup: (rawDb) {
        rawDb.execute("PRAGMA key = '$passphrase';");
        // Sanity check: this throws if the key is wrong / db is corrupt,
        // instead of silently returning an unreadable, empty-looking db.
        rawDb.execute('SELECT count(*) FROM sqlite_master;');
      },
    );
  });
}
