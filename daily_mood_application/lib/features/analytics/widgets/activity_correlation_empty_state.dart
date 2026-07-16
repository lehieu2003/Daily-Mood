import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';

class ActivityCorrelationEmptyState extends StatelessWidget {
  const ActivityCorrelationEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      key: const ValueKey('activity_correlation_empty_state'),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.secondary.withValues(alpha: 0.24),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.hub_rounded, color: colorScheme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              context.l10n.activityCorrelationEmpty,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 13,
                height: 1.3,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
