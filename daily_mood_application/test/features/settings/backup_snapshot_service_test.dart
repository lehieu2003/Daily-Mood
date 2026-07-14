import 'dart:convert';
import 'dart:io';

import 'package:daily_mood_application/core/database/app_database.dart';
import 'package:daily_mood_application/features/settings/data/backup_snapshot_service.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('creates pre-import snapshot and keeps latest three files', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final tempDirectory = await Directory.systemTemp.createTemp(
      'daily_mood_backup_snapshots_test',
    );
    var now = DateTime.utc(2026, 7, 13);

    try {
      for (var index = 0; index < 4; index++) {
        final service = LocalBackupSnapshotService(
          database: db,
          snapshotsDirectory: tempDirectory,
          clock: () => now.add(Duration(minutes: index)),
        );
        await service.createPreImportSnapshot();
      }

      final files =
          tempDirectory
              .listSync()
              .whereType<File>()
              .where((file) => file.path.endsWith('.json'))
              .toList()
            ..sort((a, b) => a.path.compareTo(b.path));

      expect(files, hasLength(3));
      expect(files.first.path, contains('20260713_000100'));

      final snapshotJson =
          jsonDecode(files.last.readAsStringSync()) as Map<String, Object?>;
      expect(snapshotJson['exportVersion'], 1);
      expect(snapshotJson['moodEntries'], isA<List<Object?>>());
    } finally {
      await db.close();
      if (tempDirectory.existsSync()) {
        tempDirectory.deleteSync(recursive: true);
      }
    }
  });
}
