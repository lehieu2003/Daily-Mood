import 'package:flutter/material.dart';

import '../../../domain/models/mood_entry.dart';
import '../dashboard_formatters.dart';
import '../dashboard_palette.dart';

class MoodEntryCard extends StatelessWidget {
  const MoodEntryCard({required this.entry, super.key, this.onOpenDetail});

  final MoodEntryModel entry;
  final VoidCallback? onOpenDetail;

  @override
  Widget build(BuildContext context) {
    final note = entry.note?.trim();
    final title = moodLabel(entry.moodScore);

    return Material(
      color: DashboardPalette.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        key: ValueKey('dashboard_entry_card_${entry.id}'),
        onTap: onOpenDetail,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _MoodFace(score: entry.moodScore),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: DashboardPalette.deepText,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          formatEntryDate(entry.createdAt),
                          style: const TextStyle(
                            color: DashboardPalette.mutedText,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: onOpenDetail,
                    style: TextButton.styleFrom(
                      minimumSize: const Size(44, 36),
                      padding: EdgeInsets.zero,
                      foregroundColor: DashboardPalette.purple,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text.rich(
                TextSpan(
                  style: const TextStyle(
                    color: DashboardPalette.deepText,
                    fontSize: 13,
                    height: 1.3,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    const TextSpan(text: 'You felt '),
                    TextSpan(
                      text: entry.moodScore <= 2
                          ? 'Disappointed, Confused'
                          : 'Calm, Energized',
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const TextSpan(text: '\nBecause of '),
                    TextSpan(
                      text: entry.moodScore <= 2 ? 'Relationships' : 'Work',
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
              if (note != null && note.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      color: DashboardPalette.deepText,
                      fontSize: 12,
                      height: 1.25,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Note: ',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                      TextSpan(text: note),
                    ],
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                const Text(
                  '+ Read more',
                  style: TextStyle(
                    color: DashboardPalette.purple,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MoodFace extends StatelessWidget {
  const _MoodFace({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    final color = moodColor(score);
    final face = switch (score) {
      1 => '😡',
      2 => '😞',
      3 => '😊',
      4 => '😇',
      _ => '😍',
    };

    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Text(face, style: const TextStyle(fontSize: 23)),
    );
  }
}
