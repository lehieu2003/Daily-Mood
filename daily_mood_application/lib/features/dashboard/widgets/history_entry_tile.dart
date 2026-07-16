import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../domain/models/mood_entry.dart';
import '../dashboard_formatters.dart';
import '../dashboard_palette.dart';

class HistoryEntryTile extends StatelessWidget {
  const HistoryEntryTile({required this.entry, super.key, this.onOpenDetail});

  final MoodEntryModel entry;
  final VoidCallback? onOpenDetail;

  @override
  Widget build(BuildContext context) {
    final note = entry.note?.trim();
    final l10n = context.l10n;

    return InkWell(
      key: ValueKey('history_entry_tile_${entry.id}'),
      onTap: onOpenDetail,
      child: Padding(
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
                          localizedMoodLabel(entry.moodScore, l10n),
                          style: TextStyle(
                            color: DashboardPalette.deepText,
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Text(
                        formatLocalizedEntryDate(entry.createdAt, l10n),
                        style: TextStyle(
                          color: DashboardPalette.mutedText,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    note == null || note.isEmpty ? l10n.noNoteAdded : note,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: DashboardPalette.mutedText,
                      fontSize: 12,
                      height: 1.3,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (entry.activityNames.isNotEmpty ||
                      entry.subEmotionNames.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final name in entry.activityNames.take(3))
                          _MetadataChip(label: l10n.activityLabel(name)),
                        for (final name in entry.subEmotionNames.take(3))
                          _MetadataChip(label: name),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetadataChip extends StatelessWidget {
  const _MetadataChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: DashboardPalette.lilacPanel,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: DashboardPalette.deepText,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
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
