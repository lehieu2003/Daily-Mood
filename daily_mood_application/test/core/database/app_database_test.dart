import 'package:daily_mood_application/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('seeds default activities on first create', () async {
    final db = AppDatabase();
    final activities = await db.select(db.activities).get();
    expect(activities.length, 7);
    await db.close();
  });
}
