import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';

class QuickLogSearchField extends StatelessWidget {
  const QuickLogSearchField({
    required this.hintText,
    required this.fieldKey,
    this.controller,
    this.enabled = true,
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
    this.onConfirmPressed,
    super.key,
  });

  final String hintText;
  final Key fieldKey;
  final TextEditingController? controller;
  final bool enabled;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onConfirmPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(Icons.search, size: 18, color: AppColors.textTertiary),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                key: fieldKey,
                controller: controller,
                enabled: enabled,
                autofocus: autofocus,
                onChanged: onChanged,
                onSubmitted: onSubmitted,
                textInputAction: TextInputAction.done,
                maxLength: 20,
                decoration: InputDecoration.collapsed(
                  hintText: hintText,
                  hintStyle: AppTypography.subText3Regular.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ).copyWith(counterText: ''),
                style: AppTypography.subText3Regular.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (onConfirmPressed != null)
              IconButton(
                key: const ValueKey('quick_log_confirm_reason'),
                onPressed: enabled ? onConfirmPressed : null,
                tooltip: context.l10n.addAReason,
                icon: const Icon(Icons.check, size: 18),
                color: AppColors.textPrimary,
                visualDensity: VisualDensity.compact,
                constraints: const BoxConstraints.tightFor(
                  width: 32,
                  height: 32,
                ),
                padding: EdgeInsets.zero,
              ),
          ],
        ),
      ),
    );
  }
}
