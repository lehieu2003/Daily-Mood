import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/theme/app_typography.dart';
import '../daily_challenge.dart';
import '../dashboard_palette.dart';
import 'dashboard_card_decoration.dart';

class DailyChallengeCard extends StatelessWidget {
  const DailyChallengeCard({
    required this.challenge,
    required this.completed,
    required this.onComplete,
    super.key,
  });

  final DailyChallenge challenge;
  final bool completed;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      key: const ValueKey('daily_challenge_card'),
      padding: const EdgeInsets.all(18),
      decoration: dashboardCardDecoration(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: completed
                  ? DashboardPalette.green.withValues(alpha: 0.18)
                  : DashboardPalette.lilacPanel,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              completed ? Icons.check_rounded : _iconFor(challenge.id),
              color: completed
                  ? DashboardPalette.green
                  : DashboardPalette.purple,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.dailyChallenge,
                  style: AppTypography.subText3Regular.copyWith(
                    color: DashboardPalette.mutedText,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.dailyChallengeTitle(challenge.id.name),
                  style: AppTypography.heading2.copyWith(
                    color: DashboardPalette.deepText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  completed
                      ? l10n.dailyChallengeCompleted
                      : l10n.dailyChallengeSubtitle,
                  style: AppTypography.subText2Regular.copyWith(
                    color: DashboardPalette.mutedText,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton.icon(
                    key: const ValueKey('daily_challenge_complete_button'),
                    onPressed: completed ? null : onComplete,
                    icon: Icon(
                      completed
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      size: 18,
                    ),
                    label: Text(
                      completed
                          ? l10n.dailyChallengeDone
                          : l10n.markChallengeDone,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(DailyChallengeId id) {
    return switch (id) {
      DailyChallengeId.goOutside => Icons.park_rounded,
      DailyChallengeId.gratitude => Icons.edit_note_rounded,
      DailyChallengeId.stretch => Icons.accessibility_new_rounded,
      DailyChallengeId.drinkWater => Icons.water_drop_outlined,
      DailyChallengeId.breathe => Icons.air_rounded,
      DailyChallengeId.shortWalk => Icons.directions_walk_rounded,
    };
  }
}
