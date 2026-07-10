import 'package:flutter/material.dart';

import '../dashboard_palette.dart';

class DashboardMoodChart extends StatelessWidget {
  const DashboardMoodChart({required this.scores, super.key});

  final List<int> scores;

  @override
  Widget build(BuildContext context) {
    final displayScores = scores.isEmpty
        ? const [5, 1, 3, 2, 1]
        : scores.take(5).toList();
    final labels = const ['10:08', '12:10', '14:40', '18:30', '20:10'];

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: BoxDecoration(
        color: DashboardPalette.lilacPanel,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mood chart',
            style: TextStyle(
              color: DashboardPalette.deepText,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 172,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var index = 0; index < 5; index++)
                  _MoodBar(
                    score: displayScores[index % displayScores.length],
                    label: labels[index],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MoodBar extends StatelessWidget {
  const _MoodBar({required this.score, required this.label});

  final int score;
  final String label;

  @override
  Widget build(BuildContext context) {
    final height = switch (score) {
      5 => 118.0,
      4 => 100.0,
      3 => 78.0,
      2 => 54.0,
      _ => 34.0,
    };
    final color = switch (score) {
      5 => DashboardPalette.green,
      4 => DashboardPalette.green,
      3 => DashboardPalette.blue,
      2 => DashboardPalette.orange,
      _ => const Color(0xFFFF7065),
    };
    final face = switch (score) {
      5 => '😍',
      4 => '😊',
      3 => '😊',
      2 => '😞',
      _ => '😡',
    };

    return SizedBox(
      width: 36,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: 18,
                height: 118,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Container(
                width: 18,
                height: height,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Positioned(
                top: 8 + (118 - height).clamp(0, 102).toDouble(),
                child: Text(face, style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              color: DashboardPalette.mutedText,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
