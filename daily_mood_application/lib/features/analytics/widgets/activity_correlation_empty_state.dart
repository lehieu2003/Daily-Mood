import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

class ActivityCorrelationEmptyState extends StatelessWidget {
  const ActivityCorrelationEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('activity_correlation_empty_state'),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.lavender.withValues(alpha: 0.7),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.hub_rounded,
              color: AppColors.primaryPurple,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Add reasons to mood entries to reveal activity patterns.',
              style: TextStyle(
                color: AppColors.textSecondary,
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
