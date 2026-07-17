import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/local_reminder_scheduler.dart';
import '../data/settings_preferences_repository.dart';
import 'settings_preferences_state.dart';

class SettingsPreferencesCubit extends Cubit<SettingsPreferencesState> {
  SettingsPreferencesCubit({
    required SettingsPreferencesRepository repository,
    LocalReminderScheduler reminderScheduler = const NoopLocalReminderScheduler(),
  })
    : _repository = repository,
      _reminderScheduler = reminderScheduler,
      super(const SettingsPreferencesState.loading()) {
    load();
  }

  final SettingsPreferencesRepository _repository;
  final LocalReminderScheduler _reminderScheduler;

  Future<void> load() async {
    final hapticsEnabled = await _repository.readHapticsEnabled();
    final languageCode = await _repository.readLanguageCode() ?? 'en';
    final themeModeName = await _repository.readThemeModeName();
    final dailyReminderEnabled = await _repository.readDailyReminderEnabled();
    final dailyReminderTime = await _repository.readDailyReminderTime();
    emit(
      SettingsPreferencesState.ready(
        hapticsEnabled: hapticsEnabled,
        languageCode: languageCode,
        themeModeName: themeModeName,
        dailyReminderEnabled: dailyReminderEnabled,
        dailyReminderHour: dailyReminderTime.hour,
        dailyReminderMinute: dailyReminderTime.minute,
      ),
    );
  }

  Future<void> setHapticsEnabled(bool enabled) async {
    emit(
      SettingsPreferencesState.ready(
        hapticsEnabled: enabled,
        languageCode: state.languageCode,
        themeModeName: state.themeModeName,
        dailyReminderEnabled: state.dailyReminderEnabled,
        dailyReminderHour: state.dailyReminderHour,
        dailyReminderMinute: state.dailyReminderMinute,
      ),
    );
    await _repository.setHapticsEnabled(enabled);
  }

  Future<void> setLanguageCode(String languageCode) async {
    emit(
      SettingsPreferencesState.ready(
        hapticsEnabled: state.hapticsEnabled,
        languageCode: languageCode,
        themeModeName: state.themeModeName,
        dailyReminderEnabled: state.dailyReminderEnabled,
        dailyReminderHour: state.dailyReminderHour,
        dailyReminderMinute: state.dailyReminderMinute,
      ),
    );
    await _repository.setLanguageCode(languageCode);
  }

  Future<void> setThemeModeName(String themeModeName) async {
    emit(
      SettingsPreferencesState.ready(
        hapticsEnabled: state.hapticsEnabled,
        languageCode: state.languageCode,
        themeModeName: themeModeName,
        dailyReminderEnabled: state.dailyReminderEnabled,
        dailyReminderHour: state.dailyReminderHour,
        dailyReminderMinute: state.dailyReminderMinute,
      ),
    );
    await _repository.setThemeModeName(themeModeName);
  }

  Future<void> setDailyReminderEnabled(bool enabled) async {
    final reminderTime = DailyReminderTime(
      hour: state.dailyReminderHour,
      minute: state.dailyReminderMinute,
    );
    emit(
      SettingsPreferencesState.ready(
        hapticsEnabled: state.hapticsEnabled,
        languageCode: state.languageCode,
        themeModeName: state.themeModeName,
        dailyReminderEnabled: enabled,
        dailyReminderHour: reminderTime.hour,
        dailyReminderMinute: reminderTime.minute,
      ),
    );
    await _repository.setDailyReminderEnabled(enabled);
    if (enabled) {
      await _reminderScheduler.scheduleDaily(reminderTime);
    } else {
      await _reminderScheduler.cancelDaily();
    }
  }

  Future<void> setDailyReminderTime(DailyReminderTime time) async {
    emit(
      SettingsPreferencesState.ready(
        hapticsEnabled: state.hapticsEnabled,
        languageCode: state.languageCode,
        themeModeName: state.themeModeName,
        dailyReminderEnabled: state.dailyReminderEnabled,
        dailyReminderHour: time.hour,
        dailyReminderMinute: time.minute,
      ),
    );
    await _repository.setDailyReminderTime(time);
    if (state.dailyReminderEnabled) {
      await _reminderScheduler.scheduleDaily(time);
    }
  }
}
