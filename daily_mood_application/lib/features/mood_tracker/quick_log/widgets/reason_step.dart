import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/database/app_database.dart';
import '../../cubit/mood_form_cubit.dart';
import 'search_field.dart';

class ReasonStep extends StatelessWidget {
  const ReasonStep({
    required this.activities,
    required this.selectedIds,
    super.key,
  });

  final Stream<List<Activity>> activities;
  final Set<int> selectedIds;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Activity>>(
      stream: activities,
      builder: (context, snapshot) {
        final allReasons = snapshot.data ?? const <Activity>[];
        final recent = allReasons.take(4).toList();
        debugPrint(
          '[DailyMood][reasons] ReasonStep snapshot '
          'state=${snapshot.connectionState.name} '
          'hasData=${snapshot.hasData} '
          'hasError=${snapshot.hasError} '
          'count=${allReasons.length} '
          'selected=${selectedIds.toList()}; '
          'names=${allReasons.map((reason) => reason.name).join(', ')}',
        );
        if (snapshot.hasError) {
          debugPrint(
            '[DailyMood][reasons] ReasonStep stream error: '
            '${snapshot.error}',
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const QuickLogSearchField(hintText: 'Search & add reasons'),
            const SizedBox(height: 18),
            _ReasonSectionHeader(
              label: selectedIds.isEmpty
                  ? 'Selected'
                  : 'Selected (${selectedIds.length})',
              actionLabel: selectedIds.isEmpty ? null : 'Clear all',
              onAction: selectedIds.isEmpty
                  ? null
                  : context.read<MoodFormCubit>().clearActivities,
            ),
            if (selectedIds.isNotEmpty) ...[
              const SizedBox(height: 10),
              _ReasonChipWrap(
                reasons: allReasons
                    .where((reason) => selectedIds.contains(reason.id))
                    .toList(),
                selectedIds: selectedIds,
              ),
            ],
            const SizedBox(height: 18),
            const _ReasonSectionHeader(label: 'Recently used'),
            const SizedBox(height: 10),
            _ReasonChipWrap(reasons: recent, selectedIds: selectedIds),
            const SizedBox(height: 18),
            const _ReasonSectionHeader(label: 'All reasons'),
            const SizedBox(height: 10),
            _ReasonChipWrap(reasons: allReasons, selectedIds: selectedIds),
          ],
        );
      },
    );
  }
}

class _ReasonChipWrap extends StatelessWidget {
  const _ReasonChipWrap({required this.reasons, required this.selectedIds});

  final List<Activity> reasons;
  final Set<int> selectedIds;

  @override
  Widget build(BuildContext context) {
    if (reasons.isEmpty) {
      return Text(
        'No reasons yet',
        style: AppTypography.subText2Regular.copyWith(
          color: AppColors.textTertiary,
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 10,
      children: [
        ...reasons.map((reason) {
          final selected = selectedIds.contains(reason.id);
          return FilterChip(
            key: ValueKey('reason_${reason.id}'),
            label: Text(reason.name),
            selected: selected,
            onSelected: (_) =>
                context.read<MoodFormCubit>().toggleActivity(reason.id),
            selectedColor: Colors.white,
            backgroundColor: Colors.transparent,
            showCheckmark: false,
            labelStyle: AppTypography.subText2Medium.copyWith(
              color: AppColors.textPrimary,
            ),
            side: BorderSide(
              color: selected ? AppColors.primaryPurple : AppColors.textPrimary,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
          );
        }),
        ActionChip(
          avatar: const Icon(Icons.add, size: 16),
          label: const Text('More'),
          onPressed: null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
      ],
    );
  }
}

class _ReasonSectionHeader extends StatelessWidget {
  const _ReasonSectionHeader({
    required this.label,
    this.actionLabel,
    this.onAction,
  });

  final String label;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTypography.subText2Medium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
        if (actionLabel != null)
          TextButton(onPressed: onAction, child: Text(actionLabel!)),
      ],
    );
  }
}
