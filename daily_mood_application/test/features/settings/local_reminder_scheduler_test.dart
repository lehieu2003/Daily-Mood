import 'package:daily_mood_application/features/settings/data/local_reminder_scheduler.dart';
import 'package:daily_mood_application/features/settings/data/settings_preferences_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

void main() {
  setUpAll(tz_data.initializeTimeZones);

  test('nextDailyReminderDate uses today when the time is still ahead', () {
    final location = tz.getLocation('Asia/Ho_Chi_Minh');
    final now = tz.TZDateTime(location, 2026, 7, 19, 8, 15);

    final scheduled = nextDailyReminderDate(
      const DailyReminderTime(hour: 20, minute: 0),
      location: location,
      now: now,
    );

    expect(scheduled, tz.TZDateTime(location, 2026, 7, 19, 20));
  });

  test('nextDailyReminderDate rolls to tomorrow after the time has passed', () {
    final location = tz.getLocation('Asia/Ho_Chi_Minh');
    final now = tz.TZDateTime(location, 2026, 7, 19, 20);

    final scheduled = nextDailyReminderDate(
      const DailyReminderTime(hour: 20, minute: 0),
      location: location,
      now: now,
    );

    expect(scheduled, tz.TZDateTime(location, 2026, 7, 20, 20));
  });

  test('daily reminder notification copy supports English and Vietnamese', () {
    expect(
      DailyReminderNotificationCopy.forLanguage('en').body,
      'Time to check in with your mood today.',
    );
    expect(
      DailyReminderNotificationCopy.forLanguage('vi').body,
      'Den gio ghi lai tam trang hom nay.',
    );
  });
}
