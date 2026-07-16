import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/settings/data/settings_preferences_repository.dart';

class AppThemeModeCubit extends Cubit<ThemeMode> {
  AppThemeModeCubit({required SettingsPreferencesRepository repository})
    : _repository = repository,
      super(ThemeMode.system) {
    load();
  }

  final SettingsPreferencesRepository _repository;

  Future<void> load() async {
    emit(_themeModeFromName(await _repository.readThemeModeName()));
  }

  Future<void> setThemeModeName(String themeModeName) async {
    final themeMode = _themeModeFromName(themeModeName);
    emit(themeMode);
    await _repository.setThemeModeName(themeModeName);
  }
}

ThemeMode _themeModeFromName(String themeModeName) {
  return switch (themeModeName) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };
}
