import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../app/localization/app_localizations.dart';
import '../../app/routes/app_router.dart';
import '../../data/repositories/daily_reflection_repository.dart';
import '../../data/repositories/activity_repository.dart';
import '../../data/repositories/mood_entry_repository.dart';
import '../../domain/models/daily_reflection.dart';
import '../../domain/models/mood_entry.dart';
import 'daily_reflection_actions.dart';
import 'daily_challenge.dart';
import 'dashboard_formatters.dart';
import 'mood_garden.dart';
import 'dashboard_palette.dart';
import 'entry_detail_actions.dart';
import '../settings/data/settings_preferences_repository.dart';
import 'weekly_reflection_report.dart';
import 'widgets/dashboard_empty_state.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/daily_challenge_card.dart';
import 'widgets/daily_reflection_card.dart';
import 'widgets/entry_detail_sheet.dart';
import 'widgets/mood_entry_card.dart';
import 'widgets/mood_garden_card.dart';
import 'widgets/nature_tip_card.dart';
import 'widgets/on_this_day_card.dart';
import 'widgets/reflection_streak_card.dart';
import 'widgets/today_check_in_section.dart';
import 'widgets/weekly_reflection_report_card.dart';
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
    this.dailyReflectionForDate,
    this.dailyReflections,
    this.onSaveReflection,
    this.onThisDayEntries,
    this.dailyChallengeRepository,
  });

  final Stream<List<MoodEntryModel>>? entries;
  final DateTime? today;
  final VoidCallback? onOpenTrend;
  final EntryUpdateAction? onUpdateEntry;
  final EntryDeleteAction? onDeleteEntry;
  final DailyReflectionStreamFactory? dailyReflectionForDate;
  final Stream<List<DailyReflectionModel>>? dailyReflections;
  final DailyReflectionSaveAction? onSaveReflection;
  final Stream<List<MoodEntryModel>>? onThisDayEntries;
  final DailyChallengeRepository? dailyChallengeRepository;

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
                                  dailyReflectionForDate:
                                      widget.dailyReflectionForDate,
                                  dailyReflections: widget.dailyReflections,
                                  onSaveReflection: widget.onSaveReflection,
                                  onThisDayEntries: widget.onThisDayEntries,
                                  dailyChallengeRepository:
                                      widget.dailyChallengeRepository,
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
    this.dailyReflectionForDate,
    this.dailyReflections,
    this.onSaveReflection,
    this.onThisDayEntries,
    this.dailyChallengeRepository,
  });

  final List<MoodEntryModel> entries;
  final DateTime selectedDate;
  final DateTime today;
  final VoidCallback? onOpenTrend;
  final EntryUpdateAction? onUpdateEntry;
  final EntryDeleteAction? onDeleteEntry;
  final DailyReflectionStreamFactory? dailyReflectionForDate;
  final Stream<List<DailyReflectionModel>>? dailyReflections;
  final DailyReflectionSaveAction? onSaveReflection;
  final Stream<List<MoodEntryModel>>? onThisDayEntries;
  final DailyChallengeRepository? dailyChallengeRepository;

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
        if (selectedEntries.isNotEmpty) ...[
          _DailyReflectionSection(
            entries: selectedEntries,
            selectedDate: selectedDate,
            dailyReflectionForDate: dailyReflectionForDate,
            onSaveReflection: onSaveReflection,
          ),
          const SizedBox(height: 14),
        ],
        ReflectionStreakCard(entries: entries, today: today),
        const SizedBox(height: 14),
        _DailyChallengeSection(
          today: today,
          repository: dailyChallengeRepository,
        ),
        const SizedBox(height: 14),
        _RetentionSummarySections(
          entries: entries,
          selectedDate: selectedDate,
          today: today,
          dailyReflections: dailyReflections,
        ),
        const SizedBox(height: 14),
        _OnThisDaySection(
          entries: entries,
          today: today,
          onThisDayEntries: onThisDayEntries,
        ),
        const SizedBox(height: 14),
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

class _DailyChallengeSection extends StatefulWidget {
  const _DailyChallengeSection({required this.today, this.repository});

  final DateTime today;
  final DailyChallengeRepository? repository;

  @override
  State<_DailyChallengeSection> createState() => _DailyChallengeSectionState();
}

class _DailyChallengeSectionState extends State<_DailyChallengeSection> {
  DailyChallengeRepository? _repository;
  DateTime? _date;
  Future<bool>? _completedFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _configure();
  }

  @override
  void didUpdateWidget(covariant _DailyChallengeSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _configure();
  }

  @override
  Widget build(BuildContext context) {
    final repository = _repository;
    final date = _date;
    final completedFuture = _completedFuture;
    if (repository == null || date == null || completedFuture == null) {
      return const SizedBox.shrink();
    }

    final challenge = repository.challengeForDate(date);

    return FutureBuilder<bool>(
      future: completedFuture,
      builder: (context, snapshot) {
        return DailyChallengeCard(
          challenge: challenge,
          completed: snapshot.data ?? false,
          onComplete: () => _markCompleted(repository, date),
        );
      },
    );
  }

  void _configure() {
    final repository = widget.repository ?? _repositoryFromContext(context);
    final date = _dateOnly(widget.today);
    if (repository == null) {
      _repository = null;
      _date = null;
      _completedFuture = null;
      return;
    }

    if (!identical(repository, _repository) || date != _date) {
      _repository = repository;
      _date = date;
      _completedFuture = repository.isCompleted(date);
    }
  }

  DailyChallengeRepository? _repositoryFromContext(BuildContext context) {
    try {
      return DailyChallengeRepository(
        repository: context.read<SettingsPreferencesRepository>(),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> _markCompleted(
    DailyChallengeRepository repository,
    DateTime date,
  ) async {
    await repository.markCompleted(date);
    if (!mounted) return;
    setState(() {
      _completedFuture = Future.value(true);
    });
  }
}

class _OnThisDaySection extends StatelessWidget {
  const _OnThisDaySection({
    required this.entries,
    required this.today,
    this.onThisDayEntries,
  });

  final List<MoodEntryModel> entries;
  final DateTime today;
  final Stream<List<MoodEntryModel>>? onThisDayEntries;

  @override
  Widget build(BuildContext context) {
    final stream = onThisDayEntries ?? _streamFrom(context);
    if (stream == null) {
      return OnThisDayCard(memories: _filterOnThisDay(entries, today));
    }

    return StreamBuilder<List<MoodEntryModel>>(
      stream: stream,
      builder: (context, snapshot) {
        return OnThisDayCard(memories: snapshot.data ?? const []);
      },
    );
  }

  Stream<List<MoodEntryModel>>? _streamFrom(BuildContext context) {
    try {
      return context.read<MoodEntryRepository>().watchOnThisDayEntries(
        day: today,
      );
    } catch (_) {
      return null;
    }
  }
}

class _RetentionSummarySections extends StatelessWidget {
  const _RetentionSummarySections({
    required this.entries,
    required this.selectedDate,
    required this.today,
    this.dailyReflections,
  });

  final List<MoodEntryModel> entries;
  final DateTime selectedDate;
  final DateTime today;
  final Stream<List<DailyReflectionModel>>? dailyReflections;

  @override
  Widget build(BuildContext context) {
    final stream = dailyReflections ?? _streamFrom(context);
    if (stream == null) {
      return _RetentionSummaryCards(
        entries: entries,
        reflections: const [],
        selectedDate: selectedDate,
        today: today,
      );
    }

    return StreamBuilder<List<DailyReflectionModel>>(
      stream: stream,
      builder: (context, snapshot) {
        return _RetentionSummaryCards(
          entries: entries,
          reflections: snapshot.data ?? const [],
          selectedDate: selectedDate,
          today: today,
        );
      },
    );
  }

  Stream<List<DailyReflectionModel>>? _streamFrom(BuildContext context) {
    try {
      return context.read<DailyReflectionRepository>().watchAllReflections();
    } catch (_) {
      return null;
    }
  }
}

class _RetentionSummaryCards extends StatelessWidget {
  const _RetentionSummaryCards({
    required this.entries,
    required this.reflections,
    required this.selectedDate,
    required this.today,
  });

  final List<MoodEntryModel> entries;
  final List<DailyReflectionModel> reflections;
  final DateTime selectedDate;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MoodGardenCard(
          summary: buildMoodGardenSummary(
            entries: entries,
            reflections: reflections,
            today: today,
          ),
          onViewJourney: () => showMoodGardenProgressionSheet(
            context: context,
            summary: buildMoodGardenSummary(
              entries: entries,
              reflections: reflections,
              today: today,
            ),
          ),
        ),
        const SizedBox(height: 14),
        WeeklyReflectionReportCard(
          report: buildWeeklyReflectionReport(
            entries: entries,
            reflections: reflections,
            selectedDate: selectedDate,
          ),
        ),
      ],
    );
  }
}

class _DailyReflectionSection extends StatelessWidget {
  const _DailyReflectionSection({
    required this.entries,
    required this.selectedDate,
    this.dailyReflectionForDate,
    this.onSaveReflection,
  });

  final List<MoodEntryModel> entries;
  final DateTime selectedDate;
  final DailyReflectionStreamFactory? dailyReflectionForDate;
  final DailyReflectionSaveAction? onSaveReflection;

  @override
  Widget build(BuildContext context) {
    final streamFactory = dailyReflectionForDate ?? _streamFactoryFrom(context);
    final saveReflection = onSaveReflection ?? _saveActionFrom(context);

    if (streamFactory == null || saveReflection == null) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<DailyReflectionModel?>(
      stream: streamFactory(selectedDate),
      builder: (context, snapshot) {
        return DailyReflectionCard(
          entries: entries,
          selectedDate: selectedDate,
          reflection: snapshot.data,
          onSave: saveReflection,
        );
      },
    );
  }

  DailyReflectionStreamFactory? _streamFactoryFrom(BuildContext context) {
    try {
      final repository = context.read<DailyReflectionRepository>();
      return repository.watchReflectionForDate;
    } catch (_) {
      return null;
    }
  }

  DailyReflectionSaveAction? _saveActionFrom(BuildContext context) {
    try {
      final repository = context.read<DailyReflectionRepository>();
      return repository.saveReflection;
    } catch (_) {
      return null;
    }
  }
}

DateTime _dateOnly(DateTime date) {
  final local = date.toLocal();
  return DateTime(local.year, local.month, local.day);
}

List<MoodEntryModel> _filterOnThisDay(
  List<MoodEntryModel> entries,
  DateTime day,
) {
  final localDay = day.toLocal();
  final matches = entries.where((entry) {
    final createdAt = entry.createdAt.toLocal();
    return createdAt.month == localDay.month &&
        createdAt.day == localDay.day &&
        createdAt.year < localDay.year;
  }).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  return matches.take(3).toList(growable: false);
}
