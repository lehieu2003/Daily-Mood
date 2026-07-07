import 'package:equatable/equatable.dart';

enum PinSetupStep { enter, confirm }

class PinSetupState extends Equatable {
  final PinSetupStep step;
  final int enteredDigits;
  final String? errorMessage;
  final bool isSaving;

  const PinSetupState({
    this.step = PinSetupStep.enter,
    this.enteredDigits = 0,
    this.errorMessage,
    this.isSaving = false,
  });

  PinSetupState copyWith({
    PinSetupStep? step,
    int? enteredDigits,
    String? errorMessage,
    bool clearError = false,
    bool? isSaving,
  }) {
    return PinSetupState(
      step: step ?? this.step,
      enteredDigits: enteredDigits ?? this.enteredDigits,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isSaving: isSaving ?? this.isSaving,
    );
  }

  @override
  List<Object?> get props => [step, enteredDigits, errorMessage, isSaving];
}
