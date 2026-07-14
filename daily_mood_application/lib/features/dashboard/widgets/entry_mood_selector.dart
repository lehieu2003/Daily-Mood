import 'package:flutter/material.dart';

import '../dashboard_formatters.dart';
import '../dashboard_palette.dart';

class EntryMoodSelector extends StatelessWidget {
  const EntryMoodSelector({
    required this.selectedScore,
    required this.onSelected,
    super.key,
  });

  final int selectedScore;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var score = 1; score <= 5; score++) ...[
          Expanded(
            child: _MoodScoreButton(
              score: score,
              isSelected: score == selectedScore,
              onSelected: onSelected,
            ),
          ),
          if (score != 5) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _MoodScoreButton extends StatelessWidget {
  const _MoodScoreButton({
    required this.score,
    required this.isSelected,
    required this.onSelected,
  });

  final int score;
  final bool isSelected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final color = moodColor(score);

    return Semantics(
      selected: isSelected,
      button: true,
      label: '${moodLabel(score)} mood',
      child: InkWell(
        key: ValueKey('entry_mood_score_$score'),
        onTap: () => onSelected(score),
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.22) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? color : DashboardPalette.divider,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Text(_faceFor(score), style: const TextStyle(fontSize: 24)),
        ),
      ),
    );
  }

  String _faceFor(int score) {
    return switch (score) {
      1 => '😡',
      2 => '😞',
      3 => '😊',
      4 => '😇',
      _ => '😍',
    };
  }
}
