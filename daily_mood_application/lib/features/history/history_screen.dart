import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/localization/app_localizations.dart';
import '../../data/repositories/activity_repository.dart';
import '../../data/repositories/mood_entry_repository.dart';
import '../../domain/models/mood_entry.dart';
import '../dashboard/dashboard_formatters.dart';
import '../dashboard/dashboard_palette.dart';
import '../dashboard/entry_detail_actions.dart';
import '../dashboard/widgets/entry_detail_sheet.dart';
import '../dashboard/widgets/history_empty_state.dart';
import '../dashboard/widgets/history_entry_group.dart';
import 'state/history_cubit.dart';
import 'state/history_state.dart';
import 'widgets/history_filter_bar.dart';
import 'widgets/history_header.dart';
import 'widgets/history_status_states.dart';

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
                return const HistoryLoadingState();
              }

              if (state.hasError) {
                return const HistoryErrorState();
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
                                const HistoryHeader(),
                                const SizedBox(height: 18),
                                HistoryFilterBar(
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
                                      ? const HistoryNoMatchesState()
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
