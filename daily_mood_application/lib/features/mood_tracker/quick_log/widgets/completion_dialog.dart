import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../quick_log_options.dart';
import 'emotion_asset.dart';

class QuickLogCompletionDialog extends StatelessWidget {
  const QuickLogCompletionDialog({
    required this.moodScore,
    required this.onDismissed,
    super.key,
  });

  final int moodScore;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    final option = moodOptions.where((mood) => mood.score == moodScore).first;

    return Dialog(
      insetPadding: const EdgeInsets.all(26),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 36, 24, 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    option.background.withValues(alpha: 0.92),
                    option.background.withValues(alpha: 0.16),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(34),
                child: EmotionAsset(
                  path: option.assetPath,
                  semanticLabel: option.label,
                  size: 76,
                ),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              "You're on a good way!",
              textAlign: TextAlign.center,
              style: AppTypography.heading1,
            ),
            const SizedBox(height: 4),
            Text(
              'Your day is going\namazing',
              textAlign: TextAlign.center,
              style: AppTypography.heading1.copyWith(
                color: AppColors.primaryPurple,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Keep tracking your mood to know how to improve your mental health.',
              textAlign: TextAlign.center,
              style: AppTypography.subText2Regular,
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: onDismissed,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(54),
                backgroundColor: AppColors.primaryPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              child: const Text('Got it'),
            ),
          ],
        ),
      ),
    );
  }
}
