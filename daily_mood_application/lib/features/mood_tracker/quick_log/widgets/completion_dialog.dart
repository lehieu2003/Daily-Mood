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
    final copy = _copyForMood(moodScore);

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
              copy.title,
              textAlign: TextAlign.center,
              style: AppTypography.heading1,
            ),
            const SizedBox(height: 4),
            Text(
              copy.highlight,
              textAlign: TextAlign.center,
              style: AppTypography.heading1.copyWith(
                color: copy.highlightColor,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              copy.body,
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

  _CompletionCopy _copyForMood(int moodScore) {
    return switch (moodScore) {
      1 => const _CompletionCopy(
        title: 'That sounds really hard.',
        highlight: 'Thank you for\nchecking in',
        body:
            'Give yourself a little care. Tracking this moment can help you spot what supports you next.',
        highlightColor: Color(0xFFEF4444),
      ),
      2 => const _CompletionCopy(
        title: 'You made space for it.',
        highlight: 'A tough mood\nis still valid',
        body:
            'Noticing what is going on is a useful step. Keep tracking gently, one entry at a time.',
        highlightColor: Color(0xFFF97316),
      ),
      3 => const _CompletionCopy(
        title: 'You checked in.',
        highlight: 'A neutral day\nstill matters',
        body:
            'Small notes like this help you understand your patterns over time.',
        highlightColor: Color(0xFFCA8A04),
      ),
      4 => const _CompletionCopy(
        title: "You're on a good way!",
        highlight: 'Your day is going\nwell',
        body:
            'Keep tracking your mood to understand what helps you feel steady.',
        highlightColor: AppColors.primaryPurple,
      ),
      _ => const _CompletionCopy(
        title: 'That is great to see!',
        highlight: 'Your day is going\namazing',
        body: 'Capture what helped today so you can return to it later.',
        highlightColor: AppColors.primaryPurple,
      ),
    };
  }
}

class _CompletionCopy {
  const _CompletionCopy({
    required this.title,
    required this.highlight,
    required this.body,
    required this.highlightColor,
  });

  final String title;
  final String highlight;
  final String body;
  final Color highlightColor;
}
