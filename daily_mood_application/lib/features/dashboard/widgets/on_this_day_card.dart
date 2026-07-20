import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/theme/app_typography.dart';
import '../../../domain/models/mood_entry.dart';
import '../dashboard_formatters.dart';
import '../dashboard_palette.dart';
import 'dashboard_card_decoration.dart';

class OnThisDayCard extends StatelessWidget {
  const OnThisDayCard({required this.memories, super.key});

  final List<MoodEntryModel> memories;

  @override
  Widget build(BuildContext context) {
    final visibleMemories = memories.take(3).toList(growable: false);
    if (visibleMemories.isEmpty) return const SizedBox.shrink();

    final l10n = context.l10n;

    return Container(
      key: const ValueKey('on_this_day_card'),
      padding: const EdgeInsets.all(18),
      decoration: dashboardCardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: DashboardPalette.pinkPanel,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.history_rounded,
                  color: DashboardPalette.hotPink,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.onThisDay, style: AppTypography.subText3Regular),
                    const SizedBox(height: 6),
                    Text(
                      l10n.onThisDayTitle,
                      style: AppTypography.heading2.copyWith(
                        color: DashboardPalette.deepText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.onThisDaySubtitle,
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
          for (var index = 0; index < visibleMemories.length; index++) ...[
            _MemoryRow(memory: visibleMemories[index]),
            if (index < visibleMemories.length - 1) ...[
              const SizedBox(height: 12),
              Divider(color: DashboardPalette.divider, height: 1),
              const SizedBox(height: 12),
            ],
          ],
        ],
      ),
    );
  }
}

class _MemoryRow extends StatelessWidget {
  const _MemoryRow({required this.memory});

  final MoodEntryModel memory;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final note = memory.note?.trim();
    final hasPhoto = memory.photoRelativePath?.trim().isNotEmpty == true;
    final hasVoice = memory.voiceNotePath?.trim().isNotEmpty == true;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: moodColor(memory.moodScore).withValues(alpha: 0.18),
            shape: BoxShape.circle,
          ),
          child: Text(
            _moodFace(memory.moodScore),
            style: const TextStyle(fontSize: 20),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    localizedMoodLabel(memory.moodScore, l10n),
                    style: AppTypography.subText2Medium.copyWith(
                      color: DashboardPalette.deepText,
                    ),
                  ),
                  Text(
                    l10n.onThisDayDate(memory.createdAt),
                    style: AppTypography.subText3Regular.copyWith(
                      color: DashboardPalette.mutedText,
                    ),
                  ),
                ],
              ),
              if (note != null && note.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  note,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.subText2Regular.copyWith(
                    color: DashboardPalette.deepText,
                    height: 1.25,
                  ),
                ),
              ],
              if (hasPhoto || hasVoice) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (hasPhoto)
                      _MediaChip(
                        icon: Icons.photo_outlined,
                        label: l10n.photoAttached,
                      ),
                    if (hasVoice)
                      _MediaChip(
                        icon: Icons.mic_none_rounded,
                        label: l10n.voiceAttached,
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _MediaChip extends StatelessWidget {
  const _MediaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: DashboardPalette.lilacPanel,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: DashboardPalette.purple),
            const SizedBox(width: 5),
            Text(
              label,
              style: AppTypography.subText3Regular.copyWith(
                color: DashboardPalette.deepText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _moodFace(int score) {
  return switch (score) {
    1 => '😡',
    2 => '😞',
    3 => '😊',
    4 => '😇',
    _ => '😍',
  };
}
