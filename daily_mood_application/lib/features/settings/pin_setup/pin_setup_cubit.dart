import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/security/app_lock_cubit.dart';
import '../../../core/security/pin_repository.dart';
import 'pin_setup_state.dart';

/// Drives the "set your PIN" onboarding flow:
/// 1. User enters a 4-digit PIN.
/// 2. User re-enters it to confirm.
/// 3. On match, it's saved via [PinRepository] and the app is
///    unlocked immediately via [AppLockCubit.markPinConfiguredAndUnlock]
///    — no need to make a first-time user immediately re-prove a PIN
///    they just typed twice.
class PinSetupCubit extends Cubit<PinSetupState> {
  PinSetupCubit({
    required PinRepository pinRepository,
    required AppLockCubit appLockCubit,
  }) : _pinRepository = pinRepository,
       _appLockCubit = appLockCubit,
       super(const PinSetupState());

  final PinRepository _pinRepository;
  final AppLockCubit _appLockCubit;

  static const _pinLength = 4;

  String _firstPin = '';
  final StringBuffer _buffer = StringBuffer();

  Future<void> onDigit(String digit) async {
    if (state.isSaving) return;
    if (_buffer.length >= _pinLength) return;

    _buffer.write(digit);
    emit(state.copyWith(enteredDigits: _buffer.length, clearError: true));

    if (_buffer.length == _pinLength) {
      await _handleStepComplete();
    }
  }

  void onDelete() {
    if (state.isSaving) return;
    if (_buffer.isEmpty) return;

    final current = _buffer.toString();
    _buffer.clear();
    _buffer.write(current.substring(0, current.length - 1));
    emit(state.copyWith(enteredDigits: _buffer.length, clearError: true));
  }

  Future<void> _handleStepComplete() async {
    final pin = _buffer.toString();

    if (state.step == PinSetupStep.enter) {
      _firstPin = pin;
      _buffer.clear();
      emit(
        state.copyWith(
          step: PinSetupStep.confirm,
          enteredDigits: 0,
          clearError: true,
        ),
      );
      return;
    }

    // Confirm step
    if (pin != _firstPin) {
      _firstPin = '';
      _buffer.clear();
      emit(
        PinSetupState(
          step: PinSetupStep.enter,
          enteredDigits: 0,
          errorMessage: "PINs didn't match. Please start again.",
        ),
      );
      return;
    }

    emit(state.copyWith(isSaving: true, clearError: true));
    try {
      await _pinRepository.setPin(pin);
      _appLockCubit.markPinConfiguredAndUnlock();
    } catch (_) {
      _firstPin = '';
      _buffer.clear();
      emit(
        PinSetupState(
          step: PinSetupStep.enter,
          enteredDigits: 0,
          errorMessage: 'Could not save your PIN. Please try again.',
        ),
      );
    }
  }
}
