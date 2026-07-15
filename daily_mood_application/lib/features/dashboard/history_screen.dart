import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/localization/app_localizations.dart';
import '../../data/repositories/activity_repository.dart';
import '../../data/repositories/mood_entry_repository.dart';
import '../../domain/models/mood_entry.dart';
import 'dashboard_formatters.dart';
import 'dashboard_palette.dart';
import 'entry_detail_actions.dart';
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
  var _query = '';
  int? _selectedMoodScore;
  _HistoryDateFilter _dateFilter = _HistoryDateFilter.all;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _historyStream ??= _resolveHistoryStream();
  }

  @override
  void didUpdateWidget(covariant HistoryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.entries != widget.entries) {
      _historyStream = _resolveHistoryStream();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DashboardPalette.background,
      body: SafeArea(
        child: StreamBuilder<List<MoodEntryModel>>(
          stream: _historyStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData &&
                snapshot.connectionState == ConnectionState.waiting) {
              return const _HistoryLoadingState();
            }

            if (snapshot.hasError) {
              return const _HistoryErrorState();
            }

            final historyEntries = _filteredEntries(
              snapshot.data ?? const <MoodEntryModel>[],
            );
            final hasActiveFilters =
                _query.isNotEmpty ||
                _selectedMoodScore != null ||
                _dateFilter != _HistoryDateFilter.all;

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
                                selectedMoodScore: _selectedMoodScore,
                                dateFilter: _dateFilter,
                                onSearchChanged: (value) => setState(
                                  () => _query = value.trim().toLowerCase(),
                                ),
                                onMoodChanged: (score) =>
                                    setState(() => _selectedMoodScore = score),
                                onDateFilterChanged: (filter) =>
                                    setState(() => _dateFilter = filter),
                                onClear: () {
                                  _searchController.clear();
                                  setState(() {
                                    _query = '';
                                    _selectedMoodScore = null;
                                    _dateFilter = _HistoryDateFilter.all;
                                  });
                                },
                              ),
                              const SizedBox(height: 18),
                              if (historyEntries.isEmpty)
                                hasActiveFilters
                                    ? const _HistoryNoMatchesState()
                                    : const HistoryEmptyState()
                              else
                                ..._buildHistoryGroups(context, historyEntries),
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
    );
  }

  Stream<List<MoodEntryModel>> _resolveHistoryStream() {
    return widget.entries ??
        context.read<MoodEntryRepository>().watchHistoryEntries();
  }

  List<Widget> _buildHistoryGroups(
    BuildContext context,
    List<MoodEntryModel> entries,
  ) {
    final groupedEntries = <DateTime, List<MoodEntryModel>>{};

    for (final entry in entries) {
      final created = entry.createdAt.toLocal();
      final day = DateTime(created.year, created.month, created.day);
      groupedEntries.putIfAbsent(day, () => []).add(entry);
    }

    return [
      for (final group in groupedEntries.entries) ...[
        HistoryEntryGroup(
          date: group.key,
          entries: group.value,
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

  List<MoodEntryModel> _filteredEntries(List<MoodEntryModel> entries) {
    return entries
        .where((entry) {
          if (_selectedMoodScore != null &&
              entry.moodScore != _selectedMoodScore) {
            return false;
          }

          if (!_dateFilter.includes(entry.createdAt)) {
            return false;
          }

          if (_query.isEmpty) return true;

          final l10n = context.l10n;
          final haystack = [
            moodLabel(entry.moodScore),
            localizedMoodLabel(entry.moodScore, l10n),
            entry.note ?? '',
            ...entry.activityNames,
            ...entry.activityNames.map(l10n.activityLabel),
            ...entry.subEmotionNames,
          ].join(' ').toLowerCase();

          return haystack.contains(_query);
        })
        .toList(growable: false);
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
            style: const TextStyle(
              color: DashboardPalette.deepText,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const Icon(
          Icons.calendar_month_outlined,
          color: DashboardPalette.purple,
          size: 22,
        ),
      ],
    );
  }
}

enum _HistoryDateFilter {
  all,
  today,
  sevenDays,
  thirtyDays;

  bool includes(DateTime date) {
    if (this == _HistoryDateFilter.all) return true;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final local = date.toLocal();
    final day = DateTime(local.year, local.month, local.day);

    return switch (this) {
      _HistoryDateFilter.today => day == today,
      _HistoryDateFilter.sevenDays => !day.isBefore(
        today.subtract(const Duration(days: 6)),
      ),
      _HistoryDateFilter.thirtyDays => !day.isBefore(
        today.subtract(const Duration(days: 29)),
      ),
      _HistoryDateFilter.all => true,
    };
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
  final _HistoryDateFilter dateFilter;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<int?> onMoodChanged;
  final ValueChanged<_HistoryDateFilter> onDateFilterChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hasActiveFilters =
        searchController.text.trim().isNotEmpty ||
        selectedMoodScore != null ||
        dateFilter != _HistoryDateFilter.all;

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
                selected: selectedMoodScore == score,
                color: moodColor(score),
                onSelected: () => onMoodChanged(score),
              ),
          ],
        ),
        const SizedBox(height: 10),
        _FilterChipRow(
          children: [
            for (final filter in _HistoryDateFilter.values)
              _ChoicePill(
                key: ValueKey('history_date_filter_${filter.name}'),
                label: _dateFilterLabel(filter, l10n),
                selected: dateFilter == filter,
                onSelected: () => onDateFilterChanged(filter),
              ),
          ],
        ),
      ],
    );
  }
}

String _dateFilterLabel(_HistoryDateFilter filter, AppLocalizations l10n) {
  return switch (filter) {
    _HistoryDateFilter.all => l10n.all,
    _HistoryDateFilter.today => l10n.today,
    _HistoryDateFilter.sevenDays => l10n.sevenDays,
    _HistoryDateFilter.thirtyDays => l10n.thirtyDays,
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
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final selectedColor = color ?? DashboardPalette.purple;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
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
          const Icon(
            Icons.manage_search_rounded,
            color: DashboardPalette.purple,
            size: 34,
          ),
          const SizedBox(height: 10),
          Text(
            context.l10n.noMatchingEntries,
            style: const TextStyle(
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
