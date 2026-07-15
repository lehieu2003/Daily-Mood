import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../app/localization/app_localizations.dart';
import '../../app/routes/app_router.dart';
import '../../data/repositories/activity_repository.dart';
import '../../data/repositories/mood_entry_repository.dart';
import '../../domain/models/mood_entry.dart';
import 'dashboard_formatters.dart';
import 'dashboard_palette.dart';
import 'entry_detail_actions.dart';
import 'widgets/dashboard_empty_state.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/entry_detail_sheet.dart';
import 'widgets/mood_entry_card.dart';
import 'widgets/nature_tip_card.dart';
import 'widgets/today_check_in_section.dart';
import 'widgets/weekly_trend_entry_card.dart';
import 'widgets/week_mood_selector.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
    this.entries,
    this.today,
    this.onOpenTrend,
    this.onUpdateEntry,
    this.onDeleteEntry,
  });

  final Stream<List<MoodEntryModel>>? entries;
  final DateTime? today;
  final VoidCallback? onOpenTrend;
  final EntryUpdateAction? onUpdateEntry;
  final EntryDeleteAction? onDeleteEntry;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = _dateOnly(widget.today ?? DateTime.now());
  }

  @override
  void didUpdateWidget(covariant DashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.today != oldWidget.today && widget.today != null) {
      _selectedDate = _dateOnly(widget.today!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final stream =
        widget.entries ??
        context.read<MoodEntryRepository>().watchHistoryEntries(limit: 50);
    final today = _dateOnly(widget.today ?? DateTime.now());

    return Scaffold(
      backgroundColor: DashboardPalette.background,
      body: SafeArea(
        child: StreamBuilder<List<MoodEntryModel>>(
          stream: stream,
          builder: (context, snapshot) {
            final recentEntries = snapshot.data ?? const <MoodEntryModel>[];

            return LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 720;
                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isWide ? 960 : double.infinity,
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
                              DashboardHeader(
                                onLogMood: () =>
                                    context.push(AppRoutes.quickLog),
                              ),
                              const SizedBox(height: 22),
                              WeekMoodSelector(
                                entries: recentEntries,
                                today: today,
                                selectedDate: _selectedDate,
                                onDateSelected: (date) {
                                  setState(() => _selectedDate = date);
                                },
                              ),
                              const SizedBox(height: 18),
                              if (!snapshot.hasData &&
                                  snapshot.connectionState ==
                                      ConnectionState.waiting)
                                const _DashboardLoading()
                              else if (recentEntries.isEmpty)
                                DashboardEmptyState(
                                  onLogMood: () =>
                                      context.push(AppRoutes.quickLog),
                                )
                              else
                                _DashboardContent(
                                  entries: recentEntries,
                                  selectedDate: _selectedDate,
                                  today: today,
                                  onOpenTrend: widget.onOpenTrend,
                                  onUpdateEntry: widget.onUpdateEntry,
                                  onDeleteEntry: widget.onDeleteEntry,
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
}

class _DashboardLoading extends StatelessWidget {
  const _DashboardLoading();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            const SizedBox(height: 12),
            Text(context.l10n.loadingMoodEntries),
          ],
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({
    required this.entries,
    required this.selectedDate,
    required this.today,
    this.onOpenTrend,
    this.onUpdateEntry,
    this.onDeleteEntry,
  });

  final List<MoodEntryModel> entries;
  final DateTime selectedDate;
  final DateTime today;
  final VoidCallback? onOpenTrend;
  final EntryUpdateAction? onUpdateEntry;
  final EntryDeleteAction? onDeleteEntry;

  @override
  Widget build(BuildContext context) {
    final selectedEntries = entries
        .where((entry) => isToday(entry, now: selectedDate))
        .toList(growable: false);
    final latestEntries = selectedEntries.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TodayCheckInSection(
          entries: selectedEntries,
          selectedDate: selectedDate,
          today: today,
          onLogMood: () => context.push(AppRoutes.quickLog),
        ),
        const SizedBox(height: 18),
        if (entries.length >= 3) ...[
          WeeklyTrendEntryCard(
            entries: entries,
            onOpenTrend: onOpenTrend ?? () {},
          ),
          const SizedBox(height: 14),
        ],
        for (var index = 0; index < latestEntries.length; index++) ...[
          MoodEntryCard(
            entry: latestEntries[index],
            onOpenDetail: () => _openEntryDetail(context, latestEntries[index]),
          ),
          const SizedBox(height: 14),
          if (index == 0) ...[
            const NatureTipCard(),
            const SizedBox(height: 14),
          ],
        ],
      ],
    );
  }

  Future<void> _openEntryDetail(BuildContext context, MoodEntryModel entry) {
    final updateEntry = onUpdateEntry;
    final deleteEntry = onDeleteEntry;
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

DateTime _dateOnly(DateTime date) {
  final local = date.toLocal();
  return DateTime(local.year, local.month, local.day);
}
