import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/settings_preferences_repository.dart';
import 'settings_preferences_state.dart';

class SettingsPreferencesCubit extends Cubit<SettingsPreferencesState> {
  SettingsPreferencesCubit({required SettingsPreferencesRepository repository})
    : _repository = repository,
      super(const SettingsPreferencesState.loading()) {
    load();
  }

  final SettingsPreferencesRepository _repository;

  Future<void> load() async {
    final hapticsEnabled = await _repository.readHapticsEnabled();
    final languageCode = await _repository.readLanguageCode() ?? 'en';
    final themeModeName = await _repository.readThemeModeName();
    emit(
      SettingsPreferencesState.ready(
        hapticsEnabled: hapticsEnabled,
        languageCode: languageCode,
        themeModeName: themeModeName,
      ),
    );
  }

  Future<void> setHapticsEnabled(bool enabled) async {
    emit(
      SettingsPreferencesState.ready(
        hapticsEnabled: enabled,
        languageCode: state.languageCode,
        themeModeName: state.themeModeName,
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
      ),
    );
    await _repository.setThemeModeName(themeModeName);
  }
}
