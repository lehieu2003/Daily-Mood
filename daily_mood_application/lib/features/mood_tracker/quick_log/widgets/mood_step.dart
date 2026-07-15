import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../cubit/mood_form_cubit.dart';
import '../quick_log_options.dart';
import 'emotion_asset.dart';

class MoodStep extends StatelessWidget {
  const MoodStep({required this.selectedMoodScore, super.key});

  final int? selectedMoodScore;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
                        Colors.white.withValues(alpha: 0.48),
                  ),
                ),
              ),
              Positioned(
                bottom: 72,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: moodOptions.map((option) {
                    final selected = option.score == selectedMoodScore;
                    return _MoodBubble(
                      option: option,
                      selected: selected,
                      semanticLabel: l10n.moodLabel(option.score),
                    );
                  }).toList(),
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
            color: AppColors.textPrimary,
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
  });

  final MoodOption option;
  final bool selected;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final size = selected ? 72.0 : 44.0;

    return GestureDetector(
      key: ValueKey('mood_option_${option.score}'),
      onTap: () {
        context.read<MoodFormCubit>().setMoodScore(option.score);
        HapticFeedback.selectionClick();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: size,
        height: size,
        padding: EdgeInsets.all(selected ? 10 : 7),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected
              ? option.background
              : Colors.white.withValues(alpha: 0.58),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: option.background.withValues(alpha: 0.72),
                    blurRadius: 28,
                    spreadRadius: 8,
                  ),
                ]
              : null,
        ),
        child: EmotionAsset(
          path: option.assetPath,
          semanticLabel: semanticLabel,
          size: selected ? 52 : 30,
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
