import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/localization/app_localizations.dart';
import '../../data/repositories/activity_repository.dart';
import '../../data/repositories/mood_entry_repository.dart';
import '../../domain/models/mood_entry.dart';
import 'dashboard_formatters.dart';
import 'dashboard_palette.dart';
import 'entry_detail_actions.dart';
import 'state/history_cubit.dart';
import 'state/history_state.dart';
import 'widgets/entry_detail_sheet.dart';
import 'widgets/history_empty_state.dart';
import 'widgets/history_entry_group.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({
    super.key,
    this.entries,
    this.onUpdateEntry,
    this.onDeleteEntry,
  });

  final Stream<List<MoodEntryModel>>? entries;
  final EntryUpdateAction? onUpdateEntry;
  final EntryDeleteAction? onDeleteEntry;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _searchController = TextEditingController();
  Stream<List<MoodEntryModel>>? _historyStream;
  HistoryCubit? _historyCubit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _historyStream ??= _resolveHistoryStream();
    _historyCubit ??= HistoryCubit(entries: _historyStream!);
    _updateCubitLocalization();
  }

  @override
  void didUpdateWidget(covariant HistoryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.entries != widget.entries) {
      _historyStream = _resolveHistoryStream();
      _historyCubit?.close();
      _historyCubit = HistoryCubit(entries: _historyStream!);
      _updateCubitLocalization();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _historyCubit?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final historyCubit = _historyCubit!;
    return BlocProvider.value(
      value: historyCubit,
      child: Scaffold(
        backgroundColor: DashboardPalette.background,
        body: SafeArea(
          child: BlocBuilder<HistoryCubit, HistoryState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const _HistoryLoadingState();
              }

              if (state.hasError) {
                return const _HistoryErrorState();
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 720;

                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isWide ? 840 : double.infinity,
                      ),
                      child: CustomScrollView(
                        slivers: [
                          SliverPadding(
                            padding: EdgeInsets.fromLTRB(
                              isWide ? 32 : 22,
                              26,
                              isWide ? 32 : 22,
                              120,
                            ),
                            sliver: SliverList(
                              delegate: SliverChildListDelegate([
                                const _HistoryHeader(),
                                const SizedBox(height: 18),
                                _HistoryFilterBar(
                                  searchController: _searchController,
                                  selectedMoodScore: state.selectedMoodScore,
                                  dateFilter: state.dateFilter,
                                  onSearchChanged: context
                                      .read<HistoryCubit>()
                                      .setQuery,
                                  onMoodChanged: context
                                      .read<HistoryCubit>()
                                      .setMoodScore,
                                  onDateFilterChanged: context
                                      .read<HistoryCubit>()
                                      .setDateFilter,
                                  onClear: () {
                                    _searchController.clear();
                                    context.read<HistoryCubit>().clearFilters();
                                  },
                                ),
                                const SizedBox(height: 18),
                                if (state.isEmpty)
                                  state.hasActiveFilters
                                      ? const _HistoryNoMatchesState()
                                      : const HistoryEmptyState()
                                else
                                  ..._buildHistoryGroups(context, state.groups),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Stream<List<MoodEntryModel>> _resolveHistoryStream() {
    return widget.entries ??
        context.read<MoodEntryRepository>().watchHistoryEntries();
  }

  void _updateCubitLocalization() {
    final l10n = context.l10n;
    _historyCubit?.updateLocalization(
      localizedMoodLabel: (score) => localizedMoodLabel(score, l10n),
      localizedActivityLabel: l10n.activityLabel,
    );
  }

  List<Widget> _buildHistoryGroups(
    BuildContext context,
    List<HistoryDayGroup> groups,
  ) {
    return [
      for (final group in groups) ...[
        HistoryEntryGroup(
          date: group.date,
          entries: group.entries,
          onOpenEntry: (entry) => _openEntryDetail(context, entry),
        ),
        const SizedBox(height: 18),
      ],
    ];
  }

  Future<void> _openEntryDetail(BuildContext context, MoodEntryModel entry) {
    final updateEntry = widget.onUpdateEntry;
    final deleteEntry = widget.onDeleteEntry;
    final repository = updateEntry == null || deleteEntry == null
        ? context.read<MoodEntryRepository>()
        : null;
    final activityOptions = updateEntry == null || deleteEntry == null
        ? context.read<ActivityRepository>().watchActiveActivities()
        : null;

    return showEntryDetailSheet(
      context: context,
      entry: entry,
      onUpdateEntry: updateEntry ?? repository!.updateEntry,
      onDeleteEntry: deleteEntry ?? repository!.softDeleteEntry,
      activityOptions: activityOptions,
    );
  }
}

class _HistoryHeader extends StatelessWidget {
  const _HistoryHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            context.l10n.history,
            style: TextStyle(
              color: DashboardPalette.deepText,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Icon(
          Icons.calendar_month_outlined,
          color: DashboardPalette.purple,
          size: 22,
        ),
      ],
    );
  }
}

class _HistoryFilterBar extends StatelessWidget {
  const _HistoryFilterBar({
    required this.searchController,
    required this.selectedMoodScore,
    required this.dateFilter,
    required this.onSearchChanged,
    required this.onMoodChanged,
    required this.onDateFilterChanged,
    required this.onClear,
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
                useRichLabel: true,
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
                useRichLabel: true,
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
    this.useRichLabel = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;
  final Color? color;
  final bool useRichLabel;

  @override
  Widget build(BuildContext context) {
    final selectedColor = color ?? DashboardPalette.purple;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: useRichLabel ? _SemanticSplitLabel(label) : Text(label),
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

class _HistoryNoMatchesState extends StatelessWidget {
  const _HistoryNoMatchesState();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('history_no_matches_state'),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: DashboardPalette.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(
            Icons.manage_search_rounded,
            color: DashboardPalette.purple,
            size: 34,
          ),
          const SizedBox(height: 10),
          Text(
            context.l10n.noMatchingEntries,
            style: TextStyle(
              color: DashboardPalette.deepText,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            context.l10n.noMatchingEntriesBody,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: DashboardPalette.mutedText,
              fontSize: 12,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryLoadingState extends StatelessWidget {
  const _HistoryLoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 12),
          Text(context.l10n.loadingMoodHistory),
        ],
      ),
    );
  }
}

class _HistoryErrorState extends StatelessWidget {
  const _HistoryErrorState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          context.l10n.couldNotLoadMoodHistory,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
