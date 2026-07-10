import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

BoxDecoration dashboardCardDecoration(BuildContext context) {
  return BoxDecoration(
    color: Theme.of(context).colorScheme.surface,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.06)),
    boxShadow: [
      BoxShadow(
        color: AppColors.textPrimary.withValues(alpha: 0.05),
        blurRadius: 18,
        offset: const Offset(0, 10),
      ),
    ],
  );
}
