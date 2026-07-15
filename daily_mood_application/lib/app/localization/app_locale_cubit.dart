import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/settings/data/settings_preferences_repository.dart';

class AppLocaleCubit extends Cubit<Locale> {
  AppLocaleCubit({required SettingsPreferencesRepository repository})
    : _repository = repository,
      super(const Locale('en')) {
    load();
  }

  final SettingsPreferencesRepository _repository;

  Future<void> load() async {
    final languageCode = await _repository.readLanguageCode() ?? 'en';
    emit(Locale(languageCode));
  }

  Future<void> setLanguageCode(String languageCode) async {
    await _repository.setLanguageCode(languageCode);
    emit(Locale(languageCode));
  }
}
