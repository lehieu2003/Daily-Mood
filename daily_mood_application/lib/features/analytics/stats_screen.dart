import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/localization/app_localizations.dart';
import '../../data/repositories/mood_analytics_repository.dart';
import '../../domain/models/activity_mood_correlation.dart';
import '../../domain/models/monthly_mood_day.dart';
import '../../domain/models/weekly_mood_point.dart';
import 'widgets/activity_correlation_chart.dart';
import 'widgets/monthly_mood_calendar.dart';
import 'widgets/weekly_trend_chart.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({
    super.key,
    this.weeklyTrend,
    this.monthlyHeatmap,
    this.activityCorrelations,
    this.focusedMonth,
  });

  final Stream<List<WeeklyMoodPoint>>? weeklyTrend;
  final Stream<List<MonthlyMoodDay>>? monthlyHeatmap;
  final Stream<List<ActivityMoodCorrelation>>? activityCorrelations;
  final DateTime? focusedMonth;

  @override
  Widget build(BuildContext context) {
    final repository =
        weeklyTrend == null ||
            monthlyHeatmap == null ||
            activityCorrelations == null
        ? context.read<MoodAnalyticsRepository>()
        : null;
    final stream =
        weeklyTrend ?? repository!.watchWeeklyMoodTrend(_currentWeekStart());
    final monthlyStream =
        monthlyHeatmap ??
        repository!.watchMonthlyMoodHeatmap(_focusedMonthStart());
    final activityStream =
        activityCorrelations ?? repository!.watchActivityMoodCorrelations();
    final calendarMonth = _focusedMonthStart();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: StreamBuilder<List<WeeklyMoodPoint>>(
          stream: stream,
          builder: (context, snapshot) {
            return StreamBuilder<List<MonthlyMoodDay>>(
              stream: monthlyStream,
              builder: (context, monthlySnapshot) {
                return StreamBuilder<List<ActivityMoodCorrelation>>(
                  stream: activityStream,
                  builder: (context, activitySnapshot) {
                    final isWeeklyLoading =
                        !snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.waiting;
                    final isMonthlyLoading =
                        !monthlySnapshot.hasData &&
                        monthlySnapshot.connectionState ==
                            ConnectionState.waiting;
                    final isActivityLoading =
                        !activitySnapshot.hasData &&
                        activitySnapshot.connectionState ==
                            ConnectionState.waiting;

                    if (snapshot.hasError ||
                        monthlySnapshot.hasError ||
                        activitySnapshot.hasError) {
                      return const _StatsErrorState();
                    }

                    if (isWeeklyLoading ||
                        isMonthlyLoading ||
                        isActivityLoading) {
                      return const _StatsLoadingState();
                    }

                    final points = snapshot.data ?? const <WeeklyMoodPoint>[];
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
                                      const _StatsHeader(),
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
        ),
      ),
    );
  }

  DateTime _currentWeekStart() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return today.subtract(Duration(days: today.weekday - DateTime.monday));
  }

  DateTime _currentMonthStart() {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  DateTime _focusedMonthStart() {
    final month = focusedMonth;
    if (month == null) return _currentMonthStart();

    return DateTime(month.year, month.month);
  }
}

class _StatsHeader extends StatelessWidget {
  const _StatsHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            context.l10n.stats,
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Icon(
          Icons.insights_rounded,
          color: theme.colorScheme.primary,
          size: 24,
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
