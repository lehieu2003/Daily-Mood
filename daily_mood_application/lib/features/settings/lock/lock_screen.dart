import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../core/security/app_lock_cubit.dart';

/// Screen A from the design spec: the passcode / biometric guard.
///
/// Auto-triggers biometric exactly once per appearance (via
/// [didChangeDependencies]'s one-shot guard) so the user isn't forced
/// to type a PIN unless biometrics fail or aren't available.
class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final _enteredPin = StringBuffer();
  bool _hasTriedBiometricThisAppearance = false;

  static const _pinLength = 4;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasTriedBiometricThisAppearance) {
      _hasTriedBiometricThisAppearance = true;
      _attemptBiometric();
    }
  }

  Future<void> _attemptBiometric() async {
    final cubit = context.read<AppLockCubit>();
    final available = await cubit.canUseBiometrics();
    if (available && mounted) {
      await cubit.tryBiometricUnlock();
    }
  }

  void _onDigitPressed(String digit) {
    if (_enteredPin.length >= _pinLength) return;

    setState(() => _enteredPin.write(digit));

    if (_enteredPin.length == _pinLength) {
      _submitPin();
    }
  }

  void _onDeletePressed() {
    if (_enteredPin.isEmpty) return;
    final current = _enteredPin.toString();
    setState(() {
      _enteredPin.clear();
      _enteredPin.write(current.substring(0, current.length - 1));
    });
  }

  Future<void> _submitPin() async {
    final pin = _enteredPin.toString();
    final cubit = context.read<AppLockCubit>();
    final success = await cubit.tryPinUnlock(pin);

    if (!success && mounted) {
      setState(() => _enteredPin.clear());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: BlocListener<AppLockCubit, AppLockState>(
        listener: (context, state) {
          if (!state.isLocked) {
            // Router redirect (see app_router.dart) handles navigating
            // away once the cubit reports unlocked — nothing to do here.
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.spa_outlined, size: 48),
                const SizedBox(height: 8),
                Text(
                  l10n.lockTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 32),
                Text(
                  l10n.enterPasscodePin,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                _PinDots(filledCount: _enteredPin.length, total: _pinLength),
                const SizedBox(height: 8),
                BlocBuilder<AppLockCubit, AppLockState>(
                  buildWhen: (prev, curr) =>
                      prev.errorMessage != curr.errorMessage,
                  builder: (context, state) {
                    if (state.errorMessage == null) {
                      return const SizedBox(height: 20);
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        state.errorMessage!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                _NumPad(
                  onDigit: _onDigitPressed,
                  onDelete: _onDeletePressed,
                  onBiometric: _attemptBiometric,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PinDots extends StatelessWidget {
  final int filledCount;
  final int total;

  const _PinDots({required this.filledCount, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        final isFilled = index < filledCount;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isFilled
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              border: Border.all(color: Theme.of(context).colorScheme.outline),
            ),
          ),
        );
      }),
    );
  }
}

class _NumPad extends StatelessWidget {
  final ValueChanged<String> onDigit;
  final VoidCallback onDelete;
  final VoidCallback onBiometric;

  const _NumPad({
    required this.onDigit,
    required this.onDelete,
    required this.onBiometric,
  });

  @override
  Widget build(BuildContext context) {
    const rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
    ];

    return Column(
      children: [
        for (final row in rows)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final digit in row)
                _NumKey(label: digit, onTap: () => onDigit(digit)),
            ],
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _NumKey(icon: Icons.fingerprint, onTap: onBiometric),
            _NumKey(label: '0', onTap: () => onDigit('0')),
            _NumKey(icon: Icons.backspace_outlined, onTap: onDelete),
          ],
        ),
      ],
    );
  }
}

class _NumKey extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback onTap;

  const _NumKey({this.label, this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        width: 64,
        height: 64,
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: Center(
              child: label != null
                  ? Text(
                      label!,
                      style: Theme.of(context).textTheme.headlineSmall,
                    )
                  : Icon(icon, size: 24),
            ),
          ),
        ),
      ),
    );
  }
}
