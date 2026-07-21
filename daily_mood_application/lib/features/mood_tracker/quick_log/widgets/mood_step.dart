import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_motion.dart';
import '../../../../app/theme/app_typography.dart';
import '../../cubit/mood_form_cubit.dart';
import '../quick_log_options.dart';
import 'emotion_asset.dart';
import 'quick_log_theme.dart';

class MoodStep extends StatelessWidget {
  const MoodStep({required this.selectedMoodScore, super.key});

  final int? selectedMoodScore;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final quickLogTheme = QuickLogTheme.of(context);
    final selectedOption = selectedMoodScore == null
        ? null
        : moodOptions
              .where((option) => option.score == selectedMoodScore)
              .first;

    return Column(
      children: [
        SizedBox(
          height: 260,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Positioned.fill(
                bottom: 64,
                child: CustomPaint(
                  painter: _MoodCloudPainter(
                    color:
                        selectedOption?.background.withValues(alpha: 0.32) ??
                        quickLogTheme.cardColor.withValues(alpha: 0.48),
                  ),
                ),
              ),
              Positioned(
                bottom: 72,
                left: 0,
                right: 0,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final slotSize = (constraints.maxWidth / moodOptions.length)
                        .clamp(52.0, 72.0)
                        .toDouble();

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: moodOptions.map((option) {
                        final selected = option.score == selectedMoodScore;
                        return _MoodBubble(
                          option: option,
                          selected: selected,
                          semanticLabel: l10n.moodLabel(option.score),
                          slotSize: slotSize,
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 58,
                left: 0,
                right: 0,
                child: CustomPaint(
                  size: const Size.fromHeight(24),
                  painter: _MoodWavePainter(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          selectedOption == null
              ? l10n.selectMood
              : l10n.moodLabel(selectedOption.score),
          style: AppTypography.subText1Bold.copyWith(
            color: quickLogTheme.primaryText,
          ),
        ),
      ],
    );
  }
}

class _MoodBubble extends StatelessWidget {
  const _MoodBubble({
    required this.option,
    required this.selected,
    required this.semanticLabel,
    required this.slotSize,
  });

  final MoodOption option;
  final bool selected;
  final String semanticLabel;
  final double slotSize;

  @override
  Widget build(BuildContext context) {
    final quickLogTheme = QuickLogTheme.of(context);
    final duration = AppMotion.duration(context, AppMotion.fastFeedback);
    final curve = AppMotion.curve(context, AppMotion.standardCurve);
    final ringSize = slotSize - 4;
    final bubbleSize = slotSize - 8;
    final iconSize = bubbleSize - 20;

    return Semantics(
      key: ValueKey('mood_option_${option.score}'),
      button: true,
      selected: selected,
      label: semanticLabel,
      child: SizedBox.square(
        dimension: slotSize,
        child: Material(
          color: Colors.transparent,
          child: InkResponse(
            onTap: () {
              context.read<MoodFormCubit>().setMoodScore(option.score);
              HapticFeedback.selectionClick();
            },
            customBorder: const CircleBorder(),
            radius: slotSize / 2,
            child: ExcludeSemantics(
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  AnimatedScale(
                    key: ValueKey('mood_option_${option.score}_selection_ring'),
                    duration: duration,
                    curve: curve,
                    scale: selected ? 1 : 0.86,
                    child: AnimatedOpacity(
                      duration: duration,
                      curve: curve,
                      opacity: selected ? 1 : 0,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: option.foreground.withValues(alpha: 0.68),
                            width: 2,
                          ),
                        ),
                        child: SizedBox.square(dimension: ringSize),
                      ),
                    ),
                  ),
                  AnimatedScale(
                    duration: duration,
                    curve: curve,
                    scale: selected ? 1 : 0.70,
                    child: AnimatedContainer(
                      duration: duration,
                      curve: curve,
                      width: bubbleSize,
                      height: bubbleSize,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selected
                            ? option.background
                            : quickLogTheme.cardColor.withValues(alpha: 0.78),
                        border: Border.all(
                          color: selected
                              ? option.foreground.withValues(alpha: 0.18)
                              : quickLogTheme.outline,
                        ),
                        boxShadow: selected
                            ? [
                                BoxShadow(
                                  color: option.background.withValues(
                                    alpha: 0.56,
                                  ),
                                  blurRadius: 22,
                                  spreadRadius: 4,
                                ),
                              ]
                            : null,
                      ),
                      child: EmotionAsset(
                        path: option.assetPath,
                        semanticLabel: semanticLabel,
                        size: iconSize,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 2,
                    top: 4,
                    child: AnimatedScale(
                      duration: duration,
                      curve: curve,
                      scale: selected ? 1 : 0.25,
                      child: AnimatedOpacity(
                        duration: duration,
                        curve: curve,
                        opacity: selected ? 1 : 0,
                        child: DecoratedBox(
                          key: ValueKey(
                            'mood_option_${option.score}_selected_badge',
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: option.foreground,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(3),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MoodCloudPainter extends CustomPainter {
  const _MoodCloudPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, size.height * 0.82)
      ..cubicTo(
        size.width * 0.18,
        size.height * 0.86,
        size.width * 0.28,
        size.height * 0.52,
        size.width * 0.44,
        size.height * 0.78,
      )
      ..cubicTo(
        size.width * 0.58,
        size.height,
        size.width * 0.66,
        size.height * 0.52,
        size.width * 0.82,
        size.height * 0.76,
      )
      ..cubicTo(
        size.width * 0.91,
        size.height * 0.9,
        size.width,
        size.height * 0.76,
        size.width,
        size.height * 0.78,
      )
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MoodCloudPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _MoodWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryPurple.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final path = Path()..moveTo(0, size.height / 2);
    for (var x = 0.0; x <= size.width; x += size.width / 8) {
      path.quadraticBezierTo(
        x + size.width / 16,
        x ~/ (size.width / 8) % 2 == 0 ? 0 : size.height,
        x + size.width / 8,
        size.height / 2,
      );
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
