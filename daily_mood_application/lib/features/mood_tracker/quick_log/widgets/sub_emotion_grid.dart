import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../cubit/mood_form_cubit.dart';
import '../quick_log_options.dart';
import 'emotion_asset.dart';
import 'quick_log_theme.dart';

class SubEmotionGrid extends StatelessWidget {
  const SubEmotionGrid({
    required this.selectedMoodScore,
    required this.selectedIds,
    this.optionsOverride,
    this.onlySelected = false,
    this.compact = true,
    super.key,
  });

  final int? selectedMoodScore;
  final Set<int> selectedIds;
  final List<SubEmotionOption>? optionsOverride;
  final bool onlySelected;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final quickLogTheme = QuickLogTheme.of(context);
    final sourceOptions =
        optionsOverride ??
        subEmotionOptions
            .where((emotion) => emotion.parentMoodScore == selectedMoodScore)
            .toList();
    final options = sourceOptions
        .where((emotion) => !onlySelected || selectedIds.contains(emotion.id))
        .toList();

    if (options.isEmpty) {
      return Text(
        l10n.pickMoodFirst,
        style: AppTypography.subText2Regular.copyWith(
          color: quickLogTheme.tertiaryText,
        ),
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((emotion) {
        final selected = selectedIds.contains(emotion.id);
        final label = l10n.subEmotionLabel(emotion.id, emotion.label);
        return FilterChip(
          key: ValueKey('sub_emotion_${emotion.id}'),
          avatar: EmotionAsset(path: emotion.assetPath, semanticLabel: label),
          label: Text(label),
          selected: selected,
          onSelected: (_) {
            context.read<MoodFormCubit>().toggleSubEmotion(emotion.id);
            if (!selected) HapticFeedback.lightImpact();
          },
          selectedColor: compact
              ? AppColors.lavender
              : quickLogTheme.cardColor,
          backgroundColor: compact
              ? quickLogTheme.cardColor
              : quickLogTheme.cardColor.withValues(alpha: 0.5),
          checkmarkColor: AppColors.primaryPurple,
          labelStyle: AppTypography.subText2Medium.copyWith(
            color: selected
                ? AppColors.primaryPurple
                : quickLogTheme.primaryText,
          ),
          side: BorderSide(
            color: selected
                ? AppColors.primaryPurple
                : quickLogTheme.outline,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        );
      }).toList(),
    );
  }
}
