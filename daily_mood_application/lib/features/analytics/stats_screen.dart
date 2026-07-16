import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/localization/app_localizations.dart';
import '../../data/repositories/mood_analytics_repository.dart';
import '../../domain/models/activity_mood_correlation.dart';
import '../../domain/models/mood_distribution_item.dart';
import '../../domain/models/monthly_mood_day.dart';
import '../../domain/models/weekly_mood_point.dart';
import 'widgets/activity_correlation_chart.dart';
import 'widgets/mood_distribution_chart.dart';
import 'widgets/monthly_mood_calendar.dart';
import 'widgets/weekly_trend_chart.dart';

enum _StatsPeriod { week, month, year }

class StatsScreen extends StatefulWidget {
  const StatsScreen({
    super.key,
    this.weeklyTrend,
    this.monthlyHeatmap,
    this.activityCorrelations,
    this.moodDistribution,
    this.focusedMonth,
  });

  final Stream<List<WeeklyMoodPoint>>? weeklyTrend;
  final Stream<List<MonthlyMoodDay>>? monthlyHeatmap;
  final Stream<List<ActivityMoodCorrelation>>? activityCorrelations;
  final Stream<List<MoodDistributionItem>>? moodDistribution;
  final DateTime? focusedMonth;

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  _StatsPeriod _period = _StatsPeriod.week;
  late DateTime _anchorDate;

  @override
  void initState() {
    super.initState();
    _anchorDate = widget.focusedMonth ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final hasInjectedCoreStreams =
        widget.weeklyTrend != null &&
        widget.monthlyHeatmap != null &&
        widget.activityCorrelations != null;
    final repository = hasInjectedCoreStreams
        ? null
        : context.read<MoodAnalyticsRepository>();
    final range = _StatsRange.forPeriod(_period, _anchorDate);
    final stream =
        widget.weeklyTrend ??
        repository!.watchWeeklyMoodTrend(_weekStartFor(range.start));
    final monthlyStream =
        widget.monthlyHeatmap ??
        repository!.watchMonthlyMoodHeatmap(_monthStartFor(_anchorDate));
    final activityStream =
        widget.activityCorrelations ??
        repository!.watchActivityMoodCorrelationsBetween(
          start: range.start,
          end: range.end,
        );
    final distributionStream =
        widget.moodDistribution ??
        (repository == null
            ? Stream<List<MoodDistributionItem>>.value(const [])
            : repository.watchMoodDistribution(range.start, range.end));
    final calendarMonth = _monthStartFor(_anchorDate);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: StreamBuilder<List<WeeklyMoodPoint>>(
          stream: stream,
          builder: (context, weeklySnapshot) {
            return StreamBuilder<List<MoodDistributionItem>>(
              stream: distributionStream,
              builder: (context, distributionSnapshot) {
                return StreamBuilder<List<MonthlyMoodDay>>(
                  stream: monthlyStream,
                  builder: (context, monthlySnapshot) {
                    return StreamBuilder<List<ActivityMoodCorrelation>>(
                      stream: activityStream,
                      builder: (context, activitySnapshot) {
                        final isWeeklyLoading =
                            !weeklySnapshot.hasData &&
                            weeklySnapshot.connectionState ==
                                ConnectionState.waiting;
                        final isDistributionLoading =
                            !distributionSnapshot.hasData &&
                            distributionSnapshot.connectionState ==
                                ConnectionState.waiting;
                        final isMonthlyLoading =
                            !monthlySnapshot.hasData &&
                            monthlySnapshot.connectionState ==
                                ConnectionState.waiting;
                        final isActivityLoading =
                            !activitySnapshot.hasData &&
                            activitySnapshot.connectionState ==
                                ConnectionState.waiting;

                        if (weeklySnapshot.hasError ||
                            distributionSnapshot.hasError ||
                            monthlySnapshot.hasError ||
                            activitySnapshot.hasError) {
                          return const _StatsErrorState();
                        }

                        if (isWeeklyLoading ||
                            isDistributionLoading ||
                            isMonthlyLoading ||
                            isActivityLoading) {
                          return const _StatsLoadingState();
                        }

                        final points =
                            weeklySnapshot.data ?? const <WeeklyMoodPoint>[];
                        final distributionItems =
                            distributionSnapshot.data ??
                            const <MoodDistributionItem>[];
                        final monthDays =
                            monthlySnapshot.data ?? const <MonthlyMoodDay>[];
                        final correlations =
                            activitySnapshot.data ??
                            const <ActivityMoodCorrelation>[];

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
                                          _StatsHeader(
                                            rangeLabel: _rangeLabel(
                                              context,
                                              range,
                                            ),
                                            onPrevious: _goPrevious,
                                            onNext: _goNext,
                                          ),
                                          const SizedBox(height: 18),
                                          _StatsPeriodSelector(
                                            value: _period,
                                            onChanged: (period) {
                                              setState(() => _period = period);
                                            },
                                          ),
                                          const SizedBox(height: 18),
                                          const _StatsFilterChips(),
                                          const SizedBox(height: 18),
                                          MoodDistributionChart(
                                            items: distributionItems,
                                          ),
                                          const SizedBox(height: 18),
                                          WeeklyTrendChart(points: points),
                                          const SizedBox(height: 18),
                                          MonthlyMoodCalendar(
                                            days: monthDays,
                                            focusedMonth: calendarMonth,
                                          ),
                                          const SizedBox(height: 18),
                                          ActivityCorrelationChart(
                                            correlations: correlations,
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
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _goPrevious() {
    setState(() {
      _anchorDate = switch (_period) {
        _StatsPeriod.week => _anchorDate.subtract(const Duration(days: 7)),
        _StatsPeriod.month => DateTime(
          _anchorDate.year,
          _anchorDate.month - 1,
          _anchorDate.day,
        ),
        _StatsPeriod.year => DateTime(
          _anchorDate.year - 1,
          _anchorDate.month,
          _anchorDate.day,
        ),
      };
    });
  }

  void _goNext() {
    setState(() {
      _anchorDate = switch (_period) {
        _StatsPeriod.week => _anchorDate.add(const Duration(days: 7)),
        _StatsPeriod.month => DateTime(
          _anchorDate.year,
          _anchorDate.month + 1,
          _anchorDate.day,
        ),
        _StatsPeriod.year => DateTime(
          _anchorDate.year + 1,
          _anchorDate.month,
          _anchorDate.day,
        ),
      };
    });
  }

  DateTime _weekStartFor(DateTime date) {
    final today = DateTime(date.year, date.month, date.day);
    return today.subtract(Duration(days: today.weekday - DateTime.monday));
  }

  DateTime _monthStartFor(DateTime date) {
    return DateTime(date.year, date.month);
  }

  String _rangeLabel(BuildContext context, _StatsRange range) {
    final l10n = context.l10n;
    return switch (_period) {
      _StatsPeriod.week =>
        '${l10n.shortMonth(range.start.month)} ${range.start.day} - '
            '${l10n.shortMonth(range.end.subtract(const Duration(days: 1)).month)} '
            '${range.end.subtract(const Duration(days: 1)).day}',
      _StatsPeriod.month =>
        '${l10n.monthName(range.start.month)} ${range.start.year}',
      _StatsPeriod.year => range.start.year.toString(),
    };
  }
}

final class _StatsRange {
  const _StatsRange({required this.start, required this.end});

  final DateTime start;
  final DateTime end;

  factory _StatsRange.forPeriod(_StatsPeriod period, DateTime anchorDate) {
    final local = anchorDate.toLocal();
    return switch (period) {
      _StatsPeriod.week => () {
        final day = DateTime(local.year, local.month, local.day);
        final start = day.subtract(Duration(days: day.weekday - 1));
        return _StatsRange(
          start: start,
          end: start.add(const Duration(days: 7)),
        );
      }(),
      _StatsPeriod.month => _StatsRange(
        start: DateTime(local.year, local.month),
        end: DateTime(local.year, local.month + 1),
      ),
      _StatsPeriod.year => _StatsRange(
        start: DateTime(local.year),
        end: DateTime(local.year + 1),
      ),
    };
  }
}

class _StatsPeriodSelector extends StatelessWidget {
  const _StatsPeriodSelector({required this.value, required this.onChanged});

  final _StatsPeriod value;
  final ValueChanged<_StatsPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<_StatsPeriod>(
        key: const ValueKey('stats_period_segmented_button'),
        showSelectedIcon: false,
        selected: {value},
        segments: [
          ButtonSegment(value: _StatsPeriod.week, label: Text(l10n.week)),
          ButtonSegment(value: _StatsPeriod.month, label: Text(l10n.month)),
          ButtonSegment(value: _StatsPeriod.year, label: Text(l10n.year)),
        ],
        onSelectionChanged: (selection) => onChanged(selection.single),
      ),
    );
  }
}

class _StatsFilterChips extends StatelessWidget {
  const _StatsFilterChips();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _FilterChip(label: l10n.allStats, selected: true),
        _FilterChip(label: l10n.moodStats),
        _FilterChip(label: l10n.topActivities),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: selected
            ? colorScheme.primary
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected
              ? colorScheme.onPrimary
              : colorScheme.onSurfaceVariant,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _StatsHeader extends StatelessWidget {
  const _StatsHeader({
    required this.rangeLabel,
    required this.onPrevious,
    required this.onNext,
  });

  final String rangeLabel;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final title = context.l10n.stats;

    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            title.isEmpty ? 'S' : title[0].toUpperCase(),
            style: TextStyle(
              color: theme.colorScheme.onPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            context.l10n.stats,
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        IconButton(
          tooltip: l10n.previousPeriod,
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        Flexible(
          child: Text(
            rangeLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        IconButton(
          tooltip: l10n.nextPeriod,
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right_rounded),
        ),
      ],
    );
  }
}

class _StatsLoadingState extends StatelessWidget {
  const _StatsLoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 12),
          Text(context.l10n.loadingMoodInsights),
        ],
      ),
    );
  }
}

class _StatsErrorState extends StatelessWidget {
  const _StatsErrorState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          context.l10n.couldNotLoadMoodInsights,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
