import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

import 'pin_repository.dart';

enum LockStatus {
  /// Still checking whether a PIN has ever been set — shown briefly
  /// on cold start while reading secure storage.
  checking,

  /// No PIN configured yet — user must go through PinSetupScreen.
  needsSetup,

  locked,
  unlocked,
}

class AppLockState {
  final LockStatus status;

  /// Surfaces biometric/PIN errors to the UI without leaking them into
  /// analytics or logs.
  final String? errorMessage;

  const AppLockState({required this.status, this.errorMessage});

  const AppLockState.checking() : this(status: LockStatus.checking);
  const AppLockState.needsSetup() : this(status: LockStatus.needsSetup);
  const AppLockState.locked([String? errorMessage])
    : this(status: LockStatus.locked, errorMessage: errorMessage);
  const AppLockState.unlocked() : this(status: LockStatus.unlocked);

  bool get isLocked => status == LockStatus.locked;
  bool get isChecking => status == LockStatus.checking;
  bool get needsSetup => status == LockStatus.needsSetup;
  bool get isUnlocked => status == LockStatus.unlocked;
}

/// Owns the app-lock state machine.
///
/// Design rules encoded here (see UI/UX spec, Screen A):
/// - Biometric prompt auto-fires once when the lock screen appears,
///   never repeatedly — the caller (LockScreen) is responsible for
///   only calling [tryBiometricUnlock] once per screen appearance.
/// - Re-locking only happens after the app has been backgrounded
///   longer than [relockAfter] — brief app-switcher glances don't
///   force the user to re-authenticate.
/// - On first ever launch (no PIN configured), the state machine
///   routes to [LockStatus.needsSetup] instead of [LockStatus.locked],
///   since there's nothing yet to unlock with.
class AppLockCubit extends Cubit<AppLockState> {
  AppLockCubit({
    required PinRepository pinRepository,
    LocalAuthentication? localAuth,
    this.relockAfter = const Duration(minutes: 1),
  }) : _pinRepository = pinRepository,
       _localAuth = localAuth ?? LocalAuthentication(),
       super(const AppLockState.checking()) {
    _initialize();
  }

  final PinRepository _pinRepository;
  final LocalAuthentication _localAuth;
  final Duration relockAfter;

  DateTime? _backgroundedAt;

  Future<void> _initialize() async {
    final hasPin = await _pinRepository.hasPinSet();
    emit(
      hasPin ? const AppLockState.locked() : const AppLockState.needsSetup(),
    );
  }

  /// Call from a WidgetsBindingObserver when the app goes to background.
  void appPaused() {
    _backgroundedAt = DateTime.now();
  }

  /// Call from a WidgetsBindingObserver when the app resumes.
  /// Only re-locks if it's been in the background longer than
  /// [relockAfter] — avoids re-prompting on quick app-switcher checks.
  void appResumed() {
    final backgroundedAt = _backgroundedAt;
    if (backgroundedAt == null) return;
    if (!state.isUnlocked) return;

    final awayDuration = DateTime.now().difference(backgroundedAt);
    if (awayDuration >= relockAfter) {
      emit(const AppLockState.locked());
    }
  }

  Future<bool> canUseBiometrics() async {
    try {
      final supported = await _localAuth.isDeviceSupported();
      final canCheck = await _localAuth.canCheckBiometrics;
      return supported && canCheck;
    } catch (_) {
      return false;
    }
  }

  /// Attempts biometric unlock. Does NOT retry internally — if it
  /// fails or is cancelled, the user falls back to the PIN pad and
  /// must explicitly tap the biometric icon to try again.
  Future<void> tryBiometricUnlock() async {
    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Unlock your mood diary',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        _unlock();
      }
      // If not authenticated (user cancelled), stay locked silently —
      // no error message needed, they can just use the PIN instead.
    } catch (_) {
      // Swallow platform exceptions (e.g. no biometrics enrolled) and
      // let the user fall back to PIN without a scary error dialog.
    }
  }

  Future<bool> tryPinUnlock(String pin) async {
    final isValid = await _pinRepository.verifyPin(pin);
    if (isValid) {
      _unlock();
      return true;
    }
    emit(const AppLockState.locked('Incorrect PIN. Please try again.'));
    return false;
  }

  /// Called by PinSetupCubit right after the PIN is saved for the
  /// first time — skips forcing the user to immediately re-enter the
  /// PIN they just set.
  void markPinConfiguredAndUnlock() {
    _unlock();
  }

  void _unlock() {
    emit(const AppLockState.unlocked());
  }

  /// For an explicit "Lock now" action in Settings.
  void lockManually() {
    emit(const AppLockState.locked());
  }
}
