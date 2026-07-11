import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/app_router.dart';
import '../../data/repositories/mood_entry_repository.dart';
import '../../domain/models/mood_entry.dart';
import 'dashboard_formatters.dart';
import 'dashboard_palette.dart';
import 'widgets/dashboard_empty_state.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/mood_entry_card.dart';
import 'widgets/nature_tip_card.dart';
import 'widgets/today_check_in_section.dart';
import 'widgets/week_mood_selector.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, this.entries});

  final Stream<List<MoodEntryModel>>? entries;

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
                              const WeekMoodSelector(),
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
                                _DashboardContent(entries: recentEntries),
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
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 64),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Loading your mood entries'),
          ],
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.entries});

  final List<MoodEntryModel> entries;

  @override
  Widget build(BuildContext context) {
    final latestEntries = entries.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TodayCheckInSection(
          entries: entries.where(isToday).toList(growable: false),
          onLogMood: () => context.push(AppRoutes.quickLog),
        ),
        const SizedBox(height: 18),
        for (var index = 0; index < latestEntries.length; index++) ...[
          MoodEntryCard(entry: latestEntries[index]),
          const SizedBox(height: 14),
          if (index == 0) ...[
            const NatureTipCard(),
            const SizedBox(height: 14),
          ],
        ],
      ],
    );
  }
}
