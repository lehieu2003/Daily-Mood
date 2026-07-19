import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import 'quick_log_theme.dart';

class QuickLogStepShell extends StatelessWidget {
  const QuickLogStepShell({
    required this.stepLabel,
    required this.title,
    required this.subtitle,
    required this.child,
    required this.primaryLabel,
    required this.onPrimaryPressed,
    required this.onClose,
    this.onBack,
    this.secondaryLabel,
    this.onSecondaryPressed,
    super.key,
  });

  final String stepLabel;
  final String title;
  final String subtitle;
  final Widget child;
  final String primaryLabel;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback onClose;
  final VoidCallback? onBack;
  final String? secondaryLabel;
  final VoidCallback? onSecondaryPressed;

  @override
  Widget build(BuildContext context) {
    final quickLogTheme = QuickLogTheme.of(context);
    return Scaffold(
      backgroundColor: quickLogTheme.outerBackground,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: quickLogTheme.panelGradient,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: _StepHeader(
                          stepLabel: stepLabel,
                          onBack: onBack,
                          onClose: onClose,
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                title,
                                textAlign: TextAlign.center,
                                style: AppTypography.heading1.copyWith(
                                  fontSize: 22,
                                  color: quickLogTheme.primaryText,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                subtitle,
                                textAlign: TextAlign.center,
                                style: AppTypography.subText3Regular.copyWith(
                                  color: quickLogTheme.secondaryText,
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 28),
                              child,
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _PrimaryFlowButton(
                              label: primaryLabel,
                              onPressed: onPrimaryPressed,
                            ),
                            if (secondaryLabel != null) ...[
                              const SizedBox(height: 12),
                              TextButton(
                                onPressed: onSecondaryPressed,
                                child: Text(secondaryLabel!),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({
    required this.stepLabel,
    required this.onClose,
    this.onBack,
  });

  final String stepLabel;
  final VoidCallback onClose;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final quickLogTheme = QuickLogTheme.of(context);
    return SizedBox(
      height: 36,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: onBack == null
                ? const _DatePill()
                : IconButton(
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back),
                    iconSize: 20,
                    tooltip: context.l10n.back,
                  ),
          ),
          Text(
            stepLabel,
            style: AppTypography.subText3Regular.copyWith(
              color: quickLogTheme.secondaryText,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton.filledTonal(
              onPressed: onClose,
              icon: const Icon(Icons.close),
              iconSize: 18,
              tooltip: context.l10n.close,
              style: IconButton.styleFrom(
                backgroundColor: quickLogTheme.subtleCardColor,
                foregroundColor: quickLogTheme.primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DatePill extends StatelessWidget {
  const _DatePill();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final l10n = context.l10n;
    final quickLogTheme = QuickLogTheme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: quickLogTheme.subtleCardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${l10n.weekdayShort(now.weekday)}, ${now.day} ${l10n.shortMonth(now.month)}',
              style: AppTypography.subText3Regular.copyWith(
                color: quickLogTheme.primaryText,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.calendar_month,
              size: 14,
              color: AppColors.primaryPurple,
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryFlowButton extends StatelessWidget {
  const _PrimaryFlowButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppColors.primaryPurple.withValues(
          alpha: 0.35,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        textStyle: AppTypography.subText1Bold,
      ),
      child: Text(label),
    );
  }
}
