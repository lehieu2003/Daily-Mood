import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../features/settings/data/settings_preferences_repository.dart';

typedef HapticAction = Future<void> Function();

class AppHaptics {
  AppHaptics({
    required SettingsPreferencesRepository settingsRepository,
    HapticAction? selectionClick,
    HapticAction? lightImpact,
  }) : _settingsRepository = settingsRepository,
       _selectionClick = selectionClick ?? HapticFeedback.selectionClick,
       _lightImpact = lightImpact ?? HapticFeedback.lightImpact;

  final SettingsPreferencesRepository _settingsRepository;
  final HapticAction _selectionClick;
  final HapticAction _lightImpact;

  Future<void> moodSelected() => _run(_selectionClick);

  Future<void> moodSaved() => _run(_lightImpact);

  Future<void> challengeCompleted() => _run(_lightImpact);

  Future<void> _run(HapticAction action) async {
    try {
      if (!await _settingsRepository.readHapticsEnabled()) return;
      await action();
    } catch (error) {
      debugPrint('[DailyMood][haptics] Haptic feedback unavailable: $error');
    }
  }
}
