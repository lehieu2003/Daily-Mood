import 'package:flutter/material.dart';

import '../../../domain/models/mood_entry.dart';
import '../dashboard_formatters.dart';
import '../dashboard_palette.dart';

class HistoryEntryTile extends StatelessWidget {
  const HistoryEntryTile({required this.entry, super.key});

  final MoodEntryModel entry;

  @override
  Widget build(BuildContext context) {
    final note = entry.note?.trim();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HistoryMoodFace(score: entry.moodScore),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        moodLabel(entry.moodScore),
                        style: const TextStyle(
                          color: DashboardPalette.deepText,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Text(
                      formatEntryDate(entry.createdAt),
                      style: const TextStyle(
                        color: DashboardPalette.mutedText,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  note == null || note.isEmpty ? 'No note added' : note,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: DashboardPalette.mutedText,
                    fontSize: 12,
                    height: 1.3,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryMoodFace extends StatelessWidget {
  const _HistoryMoodFace({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    final face = switch (score) {
      1 => '😡',
      2 => '😞',
      3 => '😊',
      4 => '😇',
      _ => '😍',
    };

    return Container(
      width: 38,
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: moodColor(score),
        shape: BoxShape.circle,
      ),
      child: Text(face, style: const TextStyle(fontSize: 20)),
    );
  }
}
