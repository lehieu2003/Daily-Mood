import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../dashboard_palette.dart';

class NatureTipCard extends StatelessWidget {
  const NatureTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DashboardPalette.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.connectWithNature,
                  style: TextStyle(
                    color: DashboardPalette.deepText,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Icon(
                Icons.lightbulb_outline,
                color: Color(0xFFFFB31A),
                size: 15,
              ),
              const SizedBox(width: 4),
              Text(
                l10n.tip,
                style: const TextStyle(
                  color: Color(0xFFFFB31A),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.natureTipBody,
            style: TextStyle(
              color: DashboardPalette.mutedText,
              fontSize: 13,
              height: 1.25,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
