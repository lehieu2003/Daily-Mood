import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/theme/app_motion.dart';
import '../../../app/theme/app_typography.dart';
import '../daily_challenge.dart';
import '../dashboard_palette.dart';
import 'dashboard_card_decoration.dart';

class DailyChallengeCard extends StatefulWidget {
  const DailyChallengeCard({
    required this.challenge,
    required this.completed,
    required this.onComplete,
    this.onCompletedHaptic,
    super.key,
  });

  final DailyChallenge challenge;
  final bool completed;
  final VoidCallback onComplete;
  final Future<void> Function()? onCompletedHaptic;

  @override
  State<DailyChallengeCard> createState() => _DailyChallengeCardState();
}

class _DailyChallengeCardState extends State<DailyChallengeCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _completionController;
  late bool _hasPlayedCompletion;

  @override
  void initState() {
    super.initState();
    _completionController = AnimationController(vsync: this);
    _hasPlayedCompletion = widget.completed;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _completionController.duration = AppMotion.duration(
      context,
      AppMotion.saveConfirmation,
    );
  }

  @override
  void didUpdateWidget(covariant DailyChallengeCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.challenge.id != oldWidget.challenge.id) {
      _completionController.reset();
      _hasPlayedCompletion = widget.completed;
      return;
    }

    if (widget.completed && !oldWidget.completed && !_hasPlayedCompletion) {
      _hasPlayedCompletion = true;
      unawaited(widget.onCompletedHaptic?.call());
      _completionController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _completionController.dispose();
    super.dispose();
  }

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
          _ChallengeCompletionMark(
            completed: widget.completed,
            animation: _completionController,
            icon: _iconFor(widget.challenge.id),
            semanticLabel: widget.completed
                ? l10n.dailyChallengeCompleted
                : l10n.dailyChallenge,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: AnimatedContainer(
              duration: AppMotion.duration(context, AppMotion.standardFeedback),
              curve: AppMotion.curve(context, AppMotion.standardCurve),
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
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
                    l10n.dailyChallengeTitle(widget.challenge.id.name),
                    style: AppTypography.heading2.copyWith(
                      color: DashboardPalette.deepText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.completed
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
                      onPressed: widget.completed ? null : widget.onComplete,
                      icon: Icon(
                        widget.completed
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        size: 18,
                      ),
                      label: Text(
                        widget.completed
                            ? l10n.dailyChallengeDone
                            : l10n.markChallengeDone,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
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

class _ChallengeCompletionMark extends StatelessWidget {
  const _ChallengeCompletionMark({
    required this.completed,
    required this.animation,
    required this.icon,
    required this.semanticLabel,
  });

  final bool completed;
  final Animation<double> animation;
  final IconData icon;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final duration = AppMotion.duration(context, AppMotion.standardFeedback);
    final curve = AppMotion.curve(context, AppMotion.standardCurve);
    final reduceMotion = AppMotion.shouldReduceMotion(context);

    return Semantics(
      label: semanticLabel,
      child: SizedBox.square(
        dimension: 56,
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            final pulse = _pulseValue(animation.value);
            final feedbackOpacity = reduceMotion ? animation.value : pulse;
            final feedbackScale = reduceMotion ? 1.0 : 0.72 + (0.28 * pulse);

            return Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Transform.scale(
                  scale: feedbackScale,
                  child: Opacity(
                    key: const ValueKey('daily_challenge_completion_feedback'),
                    opacity: feedbackOpacity.clamp(0.0, 1.0).toDouble(),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: DashboardPalette.green.withValues(alpha: 0.52),
                          width: 2,
                        ),
                      ),
                      child: const SizedBox.square(dimension: 54),
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: duration,
                  curve: curve,
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: completed
                        ? DashboardPalette.green.withValues(alpha: 0.18)
                        : DashboardPalette.lilacPanel,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ExcludeSemantics(
                    child: AnimatedSwitcher(
                      duration: duration,
                      switchInCurve: curve,
                      switchOutCurve: Curves.easeIn,
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: Tween<double>(begin: 0.25, end: 1).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOutCubic,
                              ),
                            ),
                            child: child,
                          ),
                        );
                      },
                      child: Icon(
                        completed ? Icons.check_rounded : icon,
                        key: ValueKey(
                          completed
                              ? 'daily_challenge_completed_icon'
                              : 'daily_challenge_pending_icon',
                        ),
                        color: completed
                            ? DashboardPalette.green
                            : DashboardPalette.purple,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  double _pulseValue(double value) {
    if (value <= 0 || value >= 1) return 0;
    if (value <= 0.5) {
      return Curves.easeOutCubic.transform(value / 0.5);
    }
    return 1 - Curves.easeIn.transform((value - 0.5) / 0.5);
  }
}
