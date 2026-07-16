import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../dashboard/dashboard_palette.dart';

class HistoryHeader extends StatelessWidget {
  const HistoryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            context.l10n.history,
            style: TextStyle(
              color: DashboardPalette.deepText,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Icon(
          Icons.calendar_month_outlined,
          color: DashboardPalette.purple,
          size: 22,
        ),
      ],
    );
  }
}
