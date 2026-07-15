import 'package:equatable/equatable.dart';

enum SettingsPreferenceStatus { loading, ready }

class SettingsPreferencesState extends Equatable {
  const SettingsPreferencesState({
    required this.status,
    required this.hapticsEnabled,
    required this.languageCode,
  });

  const SettingsPreferencesState.loading()
    : this(
        status: SettingsPreferenceStatus.loading,
        hapticsEnabled: true,
        languageCode: 'en',
      );

  const SettingsPreferencesState.ready({
    required bool hapticsEnabled,
    required String languageCode,
  })
    : this(
        status: SettingsPreferenceStatus.ready,
        hapticsEnabled: hapticsEnabled,
        languageCode: languageCode,
      );

  final SettingsPreferenceStatus status;
  final bool hapticsEnabled;
  final String languageCode;

  bool get isLoading => status == SettingsPreferenceStatus.loading;

  @override
  List<Object?> get props => [status, hapticsEnabled, languageCode];
}
