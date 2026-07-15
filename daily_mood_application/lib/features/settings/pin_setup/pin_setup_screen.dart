import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/localization/app_localizations.dart';
import 'pin_setup_cubit.dart';
import 'pin_setup_state.dart';

/// First-run screen: user picks a PIN, then confirms it.
/// No account, no email — matches the "No Mandatory Onboarding"
/// anti-pattern rule from the design spec; this is the *only* required
/// step before reaching the dashboard, and it exists purely for local
/// data protection, not identity.
class PinSetupScreen extends StatelessWidget {
  const PinSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 48),
              const SizedBox(height: 8),
              Text(
                l10n.protectYourDiary,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 32),
              BlocBuilder<PinSetupCubit, PinSetupState>(
                buildWhen: (prev, curr) => prev.step != curr.step,
                builder: (context, state) {
                  return Text(
                    state.step == PinSetupStep.enter
                        ? l10n.chooseFourDigitPin
                        : l10n.confirmPinTitle,
                    style: Theme.of(context).textTheme.bodyLarge,
                  );
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<PinSetupCubit, PinSetupState>(
                buildWhen: (prev, curr) =>
                    prev.enteredDigits != curr.enteredDigits,
                builder: (context, state) {
                  return _PinDots(filledCount: state.enteredDigits, total: 4);
                },
              ),
              const SizedBox(height: 8),
              BlocBuilder<PinSetupCubit, PinSetupState>(
                buildWhen: (prev, curr) =>
                    prev.errorMessage != curr.errorMessage,
                builder: (context, state) {
                  if (state.errorMessage == null) {
                    return const SizedBox(height: 20);
                  }
                  return Text(
                    l10n.pinErrorMessage(state.errorMessage!),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              BlocBuilder<PinSetupCubit, PinSetupState>(
                buildWhen: (prev, curr) => prev.isSaving != curr.isSaving,
                builder: (context, state) {
                  if (state.isSaving) {
                    return const CircularProgressIndicator();
                  }
                  return _NumPad(
                    onDigit: (d) => context.read<PinSetupCubit>().onDigit(d),
                    onDelete: () => context.read<PinSetupCubit>().onDelete(),
                  );
                },
              ),
            ],
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

  const _NumPad({required this.onDigit, required this.onDelete});

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
            const SizedBox(width: 80), // keeps '0' visually centered
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
