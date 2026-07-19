import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../app/theme/app_typography.dart';
import '../../cubit/mood_form_cubit.dart';
import '../quick_log_options.dart';
import 'search_field.dart';
import 'sub_emotion_grid.dart';
import 'quick_log_theme.dart';

class EmotionStep extends StatelessWidget {
  const EmotionStep({
    required this.selectedMoodScore,
    required this.selectedIds,
    super.key,
  });

  final int? selectedMoodScore;
  final Set<int> selectedIds;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final recent = subEmotionOptions
        .where((emotion) => emotion.parentMoodScore == selectedMoodScore)
        .take(6)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        QuickLogSearchField(
          fieldKey: const ValueKey('quick_log_emotion_search_field'),
          hintText: l10n.searchEmotions,
        ),
        const SizedBox(height: 18),
        _SectionLabel(
          label: selectedIds.isEmpty
              ? l10n.selected
              : l10n.selectedCount(selectedIds.length),
          actionLabel: selectedIds.isEmpty ? null : l10n.clearAll,
          onAction: selectedIds.isEmpty
              ? null
              : context.read<MoodFormCubit>().clearSubEmotions,
        ),
        if (selectedIds.isNotEmpty) ...[
          const SizedBox(height: 10),
          SubEmotionGrid(
            selectedMoodScore: selectedMoodScore,
            selectedIds: selectedIds,
            onlySelected: true,
          ),
        ],
        const SizedBox(height: 18),
        _SectionLabel(label: l10n.recentlyUsed),
        const SizedBox(height: 10),
        SubEmotionGrid(
          selectedMoodScore: selectedMoodScore,
          selectedIds: selectedIds,
          optionsOverride: recent,
          compact: false,
        ),
        const SizedBox(height: 18),
        _SectionLabel(label: l10n.allEmotions),
        const SizedBox(height: 10),
        SubEmotionGrid(
          selectedMoodScore: selectedMoodScore,
          selectedIds: selectedIds,
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, this.actionLabel, this.onAction});

  final String label;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final quickLogTheme = QuickLogTheme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTypography.subText2Medium.copyWith(
              color: quickLogTheme.primaryText,
            ),
          ),
        ),
        if (actionLabel != null)
          TextButton(onPressed: onAction, child: Text(actionLabel!)),
      ],
    );
  }
}
