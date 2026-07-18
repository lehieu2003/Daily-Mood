import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/theme/app_typography.dart';
import '../dashboard_palette.dart';
import '../mood_garden.dart';
import 'dashboard_card_decoration.dart';

class MoodGardenCard extends StatelessWidget {
  const MoodGardenCard({required this.summary, super.key});

  final MoodGardenSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final stageName = _stageName(summary.stage);

    return Container(
      key: const ValueKey('mood_garden_card'),
      padding: const EdgeInsets.all(18),
      decoration: dashboardCardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _GardenVisual(stage: summary.stage),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.moodGarden, style: AppTypography.subText3Regular),
                    const SizedBox(height: 6),
                    Text(
                      l10n.gardenStageLabel(stageName),
                      style: AppTypography.heading2,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.moodGardenSubtitle,
                      style: AppTypography.subText2Regular.copyWith(
                        color: DashboardPalette.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 9,
              value: summary.progressToNextStage,
              backgroundColor: DashboardPalette.lilacPanel,
              valueColor: AlwaysStoppedAnimation<Color>(DashboardPalette.green),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _GardenChip(
                text: l10n.gardenGrowthSummary(
                  activeDays: summary.activeDayCount,
                  reflections: summary.reflectionCount,
                ),
              ),
              _GardenChip(
                text: l10n.gardenRecentSummary(summary.recentActiveDays),
              ),
              _GardenChip(text: l10n.gardenNoReset),
            ],
          ),
        ],
      ),
    );
  }

  String _stageName(MoodGardenStage stage) {
    return switch (stage) {
      MoodGardenStage.seed => 'Seed',
      MoodGardenStage.sprout => 'Sprout',
      MoodGardenStage.leafy => 'Leafy',
      MoodGardenStage.bloom => 'Bloom',
      MoodGardenStage.flourishing => 'Flourishing',
    };
  }
}

class _GardenVisual extends StatelessWidget {
  const _GardenVisual({required this.stage});

  final MoodGardenStage stage;

  @override
  Widget build(BuildContext context) {
    final color = switch (stage) {
      MoodGardenStage.seed => DashboardPalette.orange,
      MoodGardenStage.sprout => DashboardPalette.green,
      MoodGardenStage.leafy => DashboardPalette.green,
      MoodGardenStage.bloom => DashboardPalette.hotPink,
      MoodGardenStage.flourishing => DashboardPalette.purple,
    };

    return SizedBox(
      width: 72,
      height: 72,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: 13,
              child: Container(
                width: 42,
                height: 10,
                decoration: BoxDecoration(
                  color: DashboardPalette.orange.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            Positioned(bottom: 20, child: _Stem(height: _stemHeight(stage))),
            ..._leaves(stage, color),
            if (stage == MoodGardenStage.bloom ||
                stage == MoodGardenStage.flourishing)
              Positioned(
                top: 12,
                child: Icon(
                  Icons.local_florist_rounded,
                  color: DashboardPalette.hotPink,
                  size: stage == MoodGardenStage.flourishing ? 34 : 28,
                ),
              ),
          ],
        ),
      ),
    );
  }

  double _stemHeight(MoodGardenStage stage) {
    return switch (stage) {
      MoodGardenStage.seed => 8,
      MoodGardenStage.sprout => 22,
      MoodGardenStage.leafy => 32,
      MoodGardenStage.bloom => 38,
      MoodGardenStage.flourishing => 42,
    };
  }

  List<Widget> _leaves(MoodGardenStage stage, Color color) {
    final count = switch (stage) {
      MoodGardenStage.seed => 0,
      MoodGardenStage.sprout => 1,
      MoodGardenStage.leafy => 3,
      MoodGardenStage.bloom => 4,
      MoodGardenStage.flourishing => 5,
    };
    final leaves = <Widget>[];
    for (var index = 0; index < count; index++) {
      leaves.add(
        Positioned(
          top: 38 - (index * 5),
          left: index.isEven ? 24 : 36,
          child: Transform.rotate(
            angle: index.isEven ? -0.65 : 0.65,
            child: Icon(Icons.eco_rounded, color: color, size: 18),
          ),
        ),
      );
    }
    return leaves;
  }
}

class _Stem extends StatelessWidget {
  const _Stem({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: height,
      decoration: BoxDecoration(
        color: DashboardPalette.green,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _GardenChip extends StatelessWidget {
  const _GardenChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: DashboardPalette.lilacPanel,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Text(
          text,
          style: AppTypography.subText3Regular.copyWith(
            color: DashboardPalette.deepText,
          ),
        ),
      ),
    );
  }
}
