import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/theme/app_colors.dart';
import '../../data/repositories/mood_analytics_repository.dart';
import '../../domain/models/weekly_mood_point.dart';
import 'widgets/weekly_trend_chart.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key, this.weeklyTrend});

  final Stream<List<WeeklyMoodPoint>>? weeklyTrend;

  @override
  Widget build(BuildContext context) {
    final stream =
        weeklyTrend ??
        context.read<MoodAnalyticsRepository>().watchWeeklyMoodTrend(
          _currentWeekStart(),
        );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F1F3),
      body: SafeArea(
        child: StreamBuilder<List<WeeklyMoodPoint>>(
          stream: stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData &&
                snapshot.connectionState == ConnectionState.waiting) {
              return const _StatsLoadingState();
            }

            if (snapshot.hasError) {
              return const _StatsErrorState();
            }

            final points = snapshot.data ?? const <WeeklyMoodPoint>[];

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

  DateTime _currentWeekStart() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return today.subtract(Duration(days: today.weekday - DateTime.monday));
  }
}

class _StatsHeader extends StatelessWidget {
  const _StatsHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Stats',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const Icon(
          Icons.insights_rounded,
          color: AppColors.primaryPurple,
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
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 12),
          Text('Loading mood insights'),
        ],
      ),
    );
  }
}

class _StatsErrorState extends StatelessWidget {
  const _StatsErrorState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Could not load mood insights.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
