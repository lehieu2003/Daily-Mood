import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/theme/app_motion.dart';
import '../../../app/theme/app_typography.dart';
import '../dashboard_palette.dart';
import '../mood_garden.dart';
import 'dashboard_card_decoration.dart';

class MoodGardenCard extends StatefulWidget {
  const MoodGardenCard({required this.summary, this.onViewJourney, super.key});

  final MoodGardenSummary summary;
  final VoidCallback? onViewJourney;

  @override
  State<MoodGardenCard> createState() => _MoodGardenCardState();
}

class _MoodGardenCardState extends State<MoodGardenCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _growthController;
  late int _previousGrowthPoints;

  @override
  void initState() {
    super.initState();
    _previousGrowthPoints = widget.summary.growthPoints;
    _growthController = AnimationController(vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _growthController.duration = AppMotion.duration(
      context,
      AppMotion.gardenGrowth,
    );
  }

  @override
  void didUpdateWidget(covariant MoodGardenCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newGrowthPoints = widget.summary.growthPoints;
    if (newGrowthPoints > _previousGrowthPoints) {
      _growthController.forward(from: 0);
    }
    _previousGrowthPoints = newGrowthPoints;
  }

  @override
  void dispose() {
    _growthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final stageName = moodGardenStageName(widget.summary.stage);

    return Container(
      key: const ValueKey('mood_garden_card'),
      padding: const EdgeInsets.all(18),
      decoration: dashboardCardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 280;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _AnimatedGardenVisual(
                        stage: widget.summary.stage,
                        animation: _growthController,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _GardenHeading(
                          stageName: l10n.gardenStageLabel(stageName),
                          subtitle: l10n.moodGardenSubtitle,
                        ),
                      ),
                      if (widget.onViewJourney != null && !compact) ...[
                        const SizedBox(width: 8),
                        IconButton(
                          key: const ValueKey('mood_garden_progression_button'),
                          tooltip: l10n.viewGardenJourney,
                          onPressed: widget.onViewJourney,
                          icon: const Icon(Icons.route_rounded),
                        ),
                      ],
                    ],
                  ),
                  if (widget.onViewJourney != null && compact) ...[
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        key: const ValueKey('mood_garden_progression_button'),
                        onPressed: widget.onViewJourney,
                        icon: const Icon(Icons.route_rounded, size: 18),
                        label: Text(l10n.viewGardenJourney),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 9,
              value: widget.summary.progressToNextStage,
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
                  activeDays: widget.summary.activeDayCount,
                  reflections: widget.summary.reflectionCount,
                ),
              ),
              _GardenChip(
                text: l10n.gardenRecentSummary(widget.summary.recentActiveDays),
              ),
              _GardenChip(text: l10n.gardenNoReset),
            ],
          ),
        ],
      ),
    );
  }
}

class _AnimatedGardenVisual extends StatelessWidget {
  const _AnimatedGardenVisual({
    required this.stage,
    required this.animation,
    this.size = 72,
  });

  final MoodGardenStage stage;
  final Animation<double> animation;
  final double size;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = AppMotion.shouldReduceMotion(context);

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          final pulse = _pulseValue(animation.value);
          final scale = reduceMotion ? 1.0 : 1 + (pulse * 0.045);
          final waterOpacity = reduceMotion ? animation.value : pulse;
          final dropletOffset = reduceMotion ? 0.0 : 7 * (1 - pulse);

          return SizedBox.square(
            key: const ValueKey('mood_garden_growth_visual'),
            dimension: size,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Transform.scale(scale: scale, child: child),
                IgnorePointer(
                  child: Opacity(
                    key: const ValueKey('mood_garden_growth_moment'),
                    opacity: waterOpacity.clamp(0.0, 1.0).toDouble(),
                    child: Transform.translate(
                      offset: Offset(0, dropletOffset),
                      child: _GardenWateringOverlay(size: size),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        child: _GardenVisual(stage: stage, size: size),
      ),
    );
  }

  double _pulseValue(double value) {
    if (value <= 0) return 0;
    if (value >= 1) return 0;
    if (value <= 0.5) {
      return Curves.easeOutCubic.transform(value / 0.5);
    }
    return 1 - Curves.easeIn.transform((value - 0.5) / 0.5);
  }
}

class _GardenWateringOverlay extends StatelessWidget {
  const _GardenWateringOverlay({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: size,
        child: Stack(
          children: [
            Positioned(
              top: size * 0.02,
              right: size * 0.10,
              child: _WaterDrop(size: size * 0.13),
            ),
            Positioned(
              top: size * 0.22,
              left: size * 0.12,
              child: _WaterDrop(size: size * 0.10),
            ),
            Positioned(
              bottom: size * 0.14,
              right: size * 0.18,
              child: Icon(
                Icons.auto_awesome_rounded,
                color: DashboardPalette.green.withValues(alpha: 0.68),
                size: size * 0.18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WaterDrop extends StatelessWidget {
  const _WaterDrop({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.water_drop_rounded,
      color: DashboardPalette.green.withValues(alpha: 0.66),
      size: size,
    );
  }
}

class _GardenHeading extends StatelessWidget {
  const _GardenHeading({required this.stageName, required this.subtitle});

  final String stageName;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.moodGarden, style: AppTypography.subText3Regular),
        const SizedBox(height: 6),
        Text(stageName, style: AppTypography.heading2),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: AppTypography.subText2Regular.copyWith(
            color: DashboardPalette.mutedText,
          ),
        ),
      ],
    );
  }
}

Future<void> showMoodGardenProgressionSheet({
  required BuildContext context,
  required MoodGardenSummary summary,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (sheetContext) {
      return MoodGardenProgressionSheet(summary: summary);
    },
  );
}

class MoodGardenProgressionSheet extends StatelessWidget {
  const MoodGardenProgressionSheet({required this.summary, super.key});

  final MoodGardenSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          key: const ValueKey('mood_garden_progression_sheet'),
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.gardenJourney, style: AppTypography.heading2),
            const SizedBox(height: 6),
            Text(
              l10n.gardenJourneySubtitle,
              style: AppTypography.subText2Regular.copyWith(
                color: DashboardPalette.mutedText,
              ),
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.62,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: summary.stageProgression.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = summary.stageProgression[index];
                  return _GardenStageTile(item: item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GardenStageTile extends StatelessWidget {
  const _GardenStageTile({required this.item});

  final MoodGardenStageProgress item;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final stageName = moodGardenStageName(item.stage);
    final borderColor = item.isCurrent
        ? DashboardPalette.purple
        : DashboardPalette.divider;

    return Container(
      key: ValueKey('mood_garden_stage_${item.stage.name}'),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: item.isCurrent
            ? DashboardPalette.lilacPanel.withValues(alpha: 0.55)
            : DashboardPalette.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          _LockedGardenVisual(stage: item.stage, locked: !item.isUnlocked),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.gardenStageLabel(stageName),
                  style: AppTypography.subText2Regular.copyWith(
                    color: DashboardPalette.deepText,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.gardenRequiredPoints(item.requiredPoints),
                  style: AppTypography.subText3Regular.copyWith(
                    color: DashboardPalette.mutedText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _StageStatusBadge(item: item),
        ],
      ),
    );
  }
}

class _LockedGardenVisual extends StatelessWidget {
  const _LockedGardenVisual({required this.stage, required this.locked});

  final MoodGardenStage stage;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: locked ? 0.42 : 1,
          child: _GardenVisual(stage: stage, size: 58),
        ),
        if (locked)
          Container(
            key: ValueKey('mood_garden_stage_${stage.name}_lock'),
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.lock_rounded, color: Colors.white),
          ),
      ],
    );
  }
}

class _StageStatusBadge extends StatelessWidget {
  const _StageStatusBadge({required this.item});

  final MoodGardenStageProgress item;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final label = item.isCurrent
        ? l10n.currentStage
        : item.isUnlocked
        ? l10n.unlockedStage
        : l10n.lockedStage;
    final color = item.isCurrent
        ? DashboardPalette.purple
        : item.isUnlocked
        ? DashboardPalette.green
        : DashboardPalette.mutedText;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        child: Text(
          label,
          style: AppTypography.subText3Regular.copyWith(color: color),
        ),
      ),
    );
  }
}

class _GardenVisual extends StatelessWidget {
  const _GardenVisual({required this.stage, this.size = 72});

  final MoodGardenStage stage;
  final double size;

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
      width: size,
      height: size,
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
              bottom: size * 0.18,
              child: Container(
                width: size * 0.58,
                height: size * 0.14,
                decoration: BoxDecoration(
                  color: DashboardPalette.orange.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            Positioned(
              bottom: size * 0.28,
              child: _Stem(height: _stemHeight(stage, size)),
            ),
            ..._leaves(stage, color),
            if (stage == MoodGardenStage.bloom ||
                stage == MoodGardenStage.flourishing)
              Positioned(
                top: 12,
                child: Icon(
                  Icons.local_florist_rounded,
                  color: DashboardPalette.hotPink,
                  size: stage == MoodGardenStage.flourishing
                      ? size * 0.47
                      : size * 0.39,
                ),
              ),
          ],
        ),
      ),
    );
  }

  double _stemHeight(MoodGardenStage stage, double size) {
    final height = switch (stage) {
      MoodGardenStage.seed => 8,
      MoodGardenStage.sprout => 22,
      MoodGardenStage.leafy => 32,
      MoodGardenStage.bloom => 38,
      MoodGardenStage.flourishing => 42,
    };
    return height * (size / 72);
  }

  List<Widget> _leaves(MoodGardenStage stage, Color color) {
    final count = switch (stage) {
      MoodGardenStage.seed => 0,
      MoodGardenStage.sprout => 1,
      MoodGardenStage.leafy => 3,
      MoodGardenStage.bloom => 4,
      MoodGardenStage.flourishing => 5,
    };
    final scale = size / 72;
    final leaves = <Widget>[];
    for (var index = 0; index < count; index++) {
      leaves.add(
        Positioned(
          top: (38 - (index * 5)) * scale,
          left: (index.isEven ? 24 : 36) * scale,
          child: Transform.rotate(
            angle: index.isEven ? -0.65 : 0.65,
            child: Icon(Icons.eco_rounded, color: color, size: 18 * scale),
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
