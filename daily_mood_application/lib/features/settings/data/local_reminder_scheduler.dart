import 'settings_preferences_repository.dart';

abstract interface class LocalReminderScheduler {
  Future<void> scheduleDaily(DailyReminderTime time);
  Future<void> cancelDaily();
}

class NoopLocalReminderScheduler implements LocalReminderScheduler {
  const NoopLocalReminderScheduler();

  @override
  Future<void> scheduleDaily(DailyReminderTime time) async {}

  @override
  Future<void> cancelDaily() async {}
}
