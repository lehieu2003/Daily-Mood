import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class SettingsPreferencesStore {
  Future<String?> read({required String key});
  Future<void> write({required String key, required String value});
}

class SecureSettingsPreferencesStore implements SettingsPreferencesStore {
  SecureSettingsPreferencesStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read({required String key}) => _storage.read(key: key);

  @override
  Future<void> write({required String key, required String value}) {
    return _storage.write(key: key, value: value);
  }
}

class InMemorySettingsPreferencesStore implements SettingsPreferencesStore {
  final Map<String, String> _values = {};

  @override
  Future<String?> read({required String key}) async => _values[key];

  @override
  Future<void> write({required String key, required String value}) async {
    _values[key] = value;
  }
}

class SettingsPreferencesRepository {
  SettingsPreferencesRepository({SettingsPreferencesStore? store})
    : _store = store ?? SecureSettingsPreferencesStore();

  final SettingsPreferencesStore _store;

  static const _hapticsEnabledKey = 'settings_haptics_enabled_v1';
  static const _languageCodeKey = 'settings_language_code_v1';
  static const _themeModeKey = 'settings_theme_mode_v1';
  static const _dailyReminderEnabledKey = 'daily_reminder_enabled_v1';
  static const _dailyReminderHourKey = 'daily_reminder_hour_v1';
  static const _dailyReminderMinuteKey = 'daily_reminder_minute_v1';
  static const supportedLanguageCodes = {'en', 'vi'};
  static const supportedThemeModeNames = {'system', 'light', 'dark'};

  Future<bool> readHapticsEnabled() async {
    final value = await _store.read(key: _hapticsEnabledKey);
    if (value == null) return true;
    return value == 'true';
  }

  Future<void> setHapticsEnabled(bool enabled) {
    return _store.write(key: _hapticsEnabledKey, value: enabled.toString());
  }

  Future<String?> readLanguageCode() async {
    final value = await _store.read(key: _languageCodeKey);
    if (supportedLanguageCodes.contains(value)) return value;
    return null;
  }

  Future<void> setLanguageCode(String languageCode) {
    assert(supportedLanguageCodes.contains(languageCode));
    return _store.write(key: _languageCodeKey, value: languageCode);
  }

  Future<String> readThemeModeName() async {
    final value = await _store.read(key: _themeModeKey);
    if (supportedThemeModeNames.contains(value)) return value!;
    return 'system';
  }

  Future<void> setThemeModeName(String themeModeName) {
    assert(supportedThemeModeNames.contains(themeModeName));
    return _store.write(key: _themeModeKey, value: themeModeName);
  }

  Future<bool> readDailyReminderEnabled() async {
    final value = await _store.read(key: _dailyReminderEnabledKey);
    return value == 'true';
  }

  Future<void> setDailyReminderEnabled(bool enabled) {
    return _store.write(
      key: _dailyReminderEnabledKey,
      value: enabled.toString(),
    );
  }

  Future<DailyReminderTime> readDailyReminderTime() async {
    final hour = int.tryParse(
      await _store.read(key: _dailyReminderHourKey) ?? '',
    );
    final minute = int.tryParse(
      await _store.read(key: _dailyReminderMinuteKey) ?? '',
    );

    if (hour == null || minute == null) {
      return const DailyReminderTime(hour: 20, minute: 0);
    }
    return DailyReminderTime.normalized(hour: hour, minute: minute);
  }

  Future<void> setDailyReminderTime(DailyReminderTime time) async {
    await _store.write(key: _dailyReminderHourKey, value: '${time.hour}');
    await _store.write(key: _dailyReminderMinuteKey, value: '${time.minute}');
  }
}

class DailyReminderTime {
  const DailyReminderTime({required this.hour, required this.minute});

  factory DailyReminderTime.normalized({
    required int hour,
    required int minute,
  }) {
    final safeHour = hour.clamp(0, 23);
    final safeMinute = minute.clamp(0, 59);
    return DailyReminderTime(hour: safeHour, minute: safeMinute);
  }

  final int hour;
  final int minute;

  String get storageLabel {
    final hourText = hour.toString().padLeft(2, '0');
    final minuteText = minute.toString().padLeft(2, '0');
    return '$hourText:$minuteText';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is DailyReminderTime &&
            runtimeType == other.runtimeType &&
            hour == other.hour &&
            minute == other.minute;
  }

  @override
  int get hashCode => Object.hash(hour, minute);
}
