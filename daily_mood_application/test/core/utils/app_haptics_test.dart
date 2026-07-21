import 'package:daily_mood_application/core/utils/app_haptics.dart';
import 'package:daily_mood_application/features/settings/data/settings_preferences_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('runs haptic action when enabled', () async {
    final repository = SettingsPreferencesRepository(
      store: InMemorySettingsPreferencesStore(),
    );
    var calls = 0;
    final haptics = AppHaptics(
      settingsRepository: repository,
      selectionClick: () async => calls++,
    );

    await haptics.moodSelected();

    expect(calls, 1);
  });

  test('skips haptic action when disabled', () async {
    final repository = SettingsPreferencesRepository(
      store: InMemorySettingsPreferencesStore(),
    );
    await repository.setHapticsEnabled(false);
    var calls = 0;
    final haptics = AppHaptics(
      settingsRepository: repository,
      lightImpact: () async => calls++,
    );

    await haptics.moodSaved();
    await haptics.challengeCompleted();

    expect(calls, 0);
  });

  test('swallows unavailable platform haptic failures', () async {
    final repository = SettingsPreferencesRepository(
      store: InMemorySettingsPreferencesStore(),
    );
    final haptics = AppHaptics(
      settingsRepository: repository,
      selectionClick: () async => throw Exception('no haptics'),
    );

    await expectLater(haptics.moodSelected(), completes);
  });

  test('swallows haptic preference read failures', () async {
    final repository = SettingsPreferencesRepository(
      store: _ThrowingSettingsPreferencesStore(),
    );
    final haptics = AppHaptics(settingsRepository: repository);

    await expectLater(haptics.challengeCompleted(), completes);
  });
}

class _ThrowingSettingsPreferencesStore implements SettingsPreferencesStore {
  @override
  Future<String?> read({required String key}) async {
    throw Exception('preferences unavailable');
  }

  @override
  Future<void> write({required String key, required String value}) async {}
}
