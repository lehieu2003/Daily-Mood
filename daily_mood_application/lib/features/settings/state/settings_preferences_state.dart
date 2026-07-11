import 'package:equatable/equatable.dart';

enum SettingsPreferenceStatus { loading, ready }

class SettingsPreferencesState extends Equatable {
  const SettingsPreferencesState({
    required this.status,
    required this.hapticsEnabled,
  });

  const SettingsPreferencesState.loading()
    : this(status: SettingsPreferenceStatus.loading, hapticsEnabled: true);

  const SettingsPreferencesState.ready({required bool hapticsEnabled})
    : this(
        status: SettingsPreferenceStatus.ready,
        hapticsEnabled: hapticsEnabled,
      );

  final SettingsPreferenceStatus status;
  final bool hapticsEnabled;

  bool get isLoading => status == SettingsPreferenceStatus.loading;

  @override
  List<Object?> get props => [status, hapticsEnabled];
}
