import 'package:equatable/equatable.dart';

enum SettingsPreferenceStatus { loading, ready }

class SettingsPreferencesState extends Equatable {
  const SettingsPreferencesState({
    required this.status,
    required this.hapticsEnabled,
    required this.languageCode,
    required this.themeModeName,
  });

  const SettingsPreferencesState.loading()
    : this(
        status: SettingsPreferenceStatus.loading,
        hapticsEnabled: true,
        languageCode: 'en',
        themeModeName: 'system',
      );

  const SettingsPreferencesState.ready({
    required bool hapticsEnabled,
    required String languageCode,
    required String themeModeName,
  })
    : this(
        status: SettingsPreferenceStatus.ready,
        hapticsEnabled: hapticsEnabled,
        languageCode: languageCode,
        themeModeName: themeModeName,
      );

  final SettingsPreferenceStatus status;
  final bool hapticsEnabled;
  final String languageCode;
  final String themeModeName;

  bool get isLoading => status == SettingsPreferenceStatus.loading;

  @override
  List<Object?> get props => [
    status,
    hapticsEnabled,
    languageCode,
    themeModeName,
  ];
}
