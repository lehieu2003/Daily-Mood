import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../dashboard/dashboard_formatters.dart';
import '../../dashboard/dashboard_palette.dart';
import '../state/history_state.dart';

class HistoryFilterBar extends StatelessWidget {
  const HistoryFilterBar({
    required this.searchController,
    required this.selectedMoodScore,
    required this.dateFilter,
    required this.onSearchChanged,
    required this.onMoodChanged,
    required this.onDateFilterChanged,
    required this.onClear,
    super.key,
  });

  final TextEditingController searchController;
  final int? selectedMoodScore;
  final HistoryDateFilter dateFilter;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<int?> onMoodChanged;
  final ValueChanged<HistoryDateFilter> onDateFilterChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hasActiveFilters =
        searchController.text.trim().isNotEmpty ||
        selectedMoodScore != null ||
        dateFilter != HistoryDateFilter.all;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          key: const ValueKey('history_search_field'),
          controller: searchController,
          onChanged: onSearchChanged,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: l10n.searchNotesTagsEmotions,
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: hasActiveFilters
                ? IconButton(
                    key: const ValueKey('history_clear_filters_button'),
                    tooltip: l10n.clearFilters,
                    onPressed: onClear,
                    icon: const Icon(Icons.close_rounded),
                  )
                : null,
            filled: true,
            fillColor: DashboardPalette.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 12),
        _FilterChipRow(
          children: [
            _ChoicePill(
              key: const ValueKey('history_mood_filter_all'),
              label: l10n.allMoods,
              selected: selectedMoodScore == null,
              onSelected: () => onMoodChanged(null),
            ),
            for (var score = 5; score >= 1; score--)
              _ChoicePill(
                key: ValueKey('history_mood_filter_$score'),
                label: localizedMoodLabel(score, l10n),
                useSplitLabel: true,
                selected: selectedMoodScore == score,
                color: moodColor(score),
                onSelected: () => onMoodChanged(score),
              ),
          ],
        ),
        const SizedBox(height: 10),
        _FilterChipRow(
          children: [
            for (final filter in HistoryDateFilter.values)
              _ChoicePill(
                key: ValueKey('history_date_filter_${filter.name}'),
                label: _dateFilterLabel(filter, l10n),
                useSplitLabel: true,
                selected: dateFilter == filter,
                onSelected: () => onDateFilterChanged(filter),
              ),
          ],
        ),
      ],
    );
  }
}

String _dateFilterLabel(HistoryDateFilter filter, AppLocalizations l10n) {
  return switch (filter) {
    HistoryDateFilter.all => l10n.all,
    HistoryDateFilter.today => l10n.today,
    HistoryDateFilter.sevenDays => l10n.sevenDays,
    HistoryDateFilter.thirtyDays => l10n.thirtyDays,
  };
}

class _FilterChipRow extends StatelessWidget {
  const _FilterChipRow({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: children),
    );
  }
}

class _ChoicePill extends StatelessWidget {
  const _ChoicePill({
    required this.label,
    required this.selected,
    required this.onSelected,
    super.key,
    this.color,
    this.useSplitLabel = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;
  final Color? color;
  final bool useSplitLabel;

  @override
  Widget build(BuildContext context) {
    final selectedColor = color ?? DashboardPalette.purple;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: useSplitLabel ? _SemanticSplitLabel(label) : Text(label),
        selected: selected,
        onSelected: (_) => onSelected(),
        selectedColor: selectedColor,
        backgroundColor: DashboardPalette.surface,
        labelStyle: TextStyle(
          color: selected ? Colors.white : DashboardPalette.deepText,
          fontWeight: FontWeight.w800,
        ),
        side: BorderSide(
          color: selected ? selectedColor : DashboardPalette.divider,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

class _SemanticSplitLabel extends StatelessWidget {
  const _SemanticSplitLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final codeUnit in label.codeUnits)
              Text(String.fromCharCode(codeUnit)),
          ],
        ),
      ),
    );
  }
}
