import 'package:flutter/material.dart';

import '../dashboard_palette.dart';

BoxDecoration dashboardCardDecoration(BuildContext context) {
  return BoxDecoration(
    color: Theme.of(context).colorScheme.surface,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: DashboardPalette.divider),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.08),
        blurRadius: 18,
        offset: const Offset(0, 10),
      ),
    ],
  );
}
