import 'package:daily_mood_application/core/database/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('creates target schema and seeds default activities', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());

    try {
      final activities = await db.select(db.activities).get();
      expect(activities.length, 7);

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
    } finally {
      await db.close();
    }
  });
}
