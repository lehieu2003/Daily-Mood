import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/mood_entry_repository.dart';
import '../../domain/models/mood_entry.dart';
import 'dashboard_palette.dart';
import 'entry_detail_actions.dart';
import 'widgets/entry_detail_sheet.dart';
import 'widgets/history_empty_state.dart';
import 'widgets/history_entry_group.dart';

class HistoryScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final stream =
        entries ?? context.read<MoodEntryRepository>().watchRecentEntries();

    return Scaffold(
      backgroundColor: DashboardPalette.background,
      body: SafeArea(
        child: StreamBuilder<List<MoodEntryModel>>(
          stream: stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData &&
                snapshot.connectionState == ConnectionState.waiting) {
              return const _HistoryLoadingState();
            }

            if (snapshot.hasError) {
              return const _HistoryErrorState();
            }

            final historyEntries = snapshot.data ?? const <MoodEntryModel>[];

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
                              if (historyEntries.isEmpty)
                                const HistoryEmptyState()
                              else
                                ..._buildHistoryGroups(
                                  context,
                                  historyEntries,
                                ),
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

  Future<void> _openEntryDetail(
    BuildContext context,
    MoodEntryModel entry,
  ) {
    final updateEntry = onUpdateEntry;
    final deleteEntry = onDeleteEntry;
    final repository = updateEntry == null || deleteEntry == null
        ? context.read<MoodEntryRepository>()
        : null;

    return showEntryDetailSheet(
      context: context,
      entry: entry,
      onUpdateEntry: updateEntry ?? repository!.updateEntry,
      onDeleteEntry: deleteEntry ?? repository!.softDeleteEntry,
    );
  }
}

class _HistoryHeader extends StatelessWidget {
  const _HistoryHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Text(
            'History',
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

class _HistoryLoadingState extends StatelessWidget {
  const _HistoryLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 12),
          Text('Loading mood history'),
        ],
      ),
    );
  }
}

class _HistoryErrorState extends StatelessWidget {
  const _HistoryErrorState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Could not load mood history.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
