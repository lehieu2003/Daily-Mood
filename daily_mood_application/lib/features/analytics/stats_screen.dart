import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/localization/app_localizations.dart';
import '../../data/repositories/mood_analytics_repository.dart';
import '../../domain/models/activity_mood_correlation.dart';
import '../../domain/models/mood_distribution_item.dart';
import '../../domain/models/monthly_mood_day.dart';
import '../../domain/models/weekly_mood_point.dart';
import 'guided_insights.dart';
import 'state/stats_cubit.dart';
import 'state/stats_state.dart';
import 'widgets/activity_correlation_chart.dart';
import 'widgets/guided_insights_card.dart';
import 'widgets/mood_distribution_chart.dart';
import 'widgets/monthly_mood_calendar.dart';
import 'widgets/weekly_trend_chart.dart';

class StatsScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final hasInjectedCoreStreams =
        weeklyTrend != null &&
        monthlyHeatmap != null &&
        activityCorrelations != null;
    final repository = hasInjectedCoreStreams
        ? null
        : context.read<MoodAnalyticsRepository>();

    return BlocProvider(
      create: (_) => StatsCubit(
        repository: repository,
        anchorDate: focusedMonth,
        weeklyTrend: weeklyTrend,
        monthlyHeatmap: monthlyHeatmap,
        activityCorrelations: activityCorrelations,
        moodDistribution: moodDistribution,
      ),
      child: const _StatsView(),
    );
  }
}

class _StatsView extends StatelessWidget {
  const _StatsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<StatsCubit, StatsState>(
          builder: (context, state) {
            if (state.hasError) {
              return const _StatsErrorState();
            }

            if (state.isLoading) {
              return const _StatsLoadingState();
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 720;

                return CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        isWide ? 32 : 22,
                        26,
                        isWide ? 32 : 22,
                        120,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: isWide ? 840 : double.infinity,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _StatsHeader(
                                  rangeLabel: _rangeLabel(context, state),
                                  onPrevious: context
                                      .read<StatsCubit>()
                                      .goPrevious,
                                  onNext: context.read<StatsCubit>().goNext,
                                ),
                                const SizedBox(height: 18),
                                _StatsPeriodSelector(
                                  value: state.period,
                                  onChanged: context
                                      .read<StatsCubit>()
                                      .setPeriod,
                                ),
                                const SizedBox(height: 18),
                                const _StatsFilterChips(),
                                const SizedBox(height: 18),
                                GuidedInsightsCard(
                                  insights: buildGuidedInsights(
                                    weeklyTrend: state.weeklyTrend,
                                    activityCorrelations:
                                        state.activityCorrelations,
                                    moodDistribution: state.moodDistribution,
                                  ),
                                ),
                                const SizedBox(height: 18),
                                MoodDistributionChart(
                                  items: state.moodDistribution,
                                ),
                                const SizedBox(height: 18),
                                WeeklyTrendChart(points: state.weeklyTrend),
                                const SizedBox(height: 18),
                                MonthlyMoodCalendar(
                                  days: state.monthlyHeatmap,
                                  focusedMonth: state.calendarMonth,
                                ),
                                const SizedBox(height: 18),
                                ActivityCorrelationChart(
                                  correlations: state.activityCorrelations,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _rangeLabel(BuildContext context, StatsState state) {
    final l10n = context.l10n;
    final range = state.range;
    return switch (state.period) {
      StatsPeriod.week =>
        '${l10n.shortMonth(range.start.month)} ${range.start.day} - '
            '${l10n.shortMonth(range.end.subtract(const Duration(days: 1)).month)} '
            '${range.end.subtract(const Duration(days: 1)).day}',
      StatsPeriod.month =>
        '${l10n.monthName(range.start.month)} ${range.start.year}',
      StatsPeriod.year => range.start.year.toString(),
    };
  }
}

class _StatsPeriodSelector extends StatelessWidget {
  const _StatsPeriodSelector({required this.value, required this.onChanged});

  final StatsPeriod value;
  final ValueChanged<StatsPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<StatsPeriod>(
        key: const ValueKey('stats_period_segmented_button'),
        showSelectedIcon: false,
        selected: {value},
        segments: [
          ButtonSegment(value: StatsPeriod.week, label: Text(l10n.week)),
          ButtonSegment(value: StatsPeriod.month, label: Text(l10n.month)),
          ButtonSegment(value: StatsPeriod.year, label: Text(l10n.year)),
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
