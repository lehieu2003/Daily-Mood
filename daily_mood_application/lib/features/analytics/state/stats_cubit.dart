import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/mood_analytics_repository.dart';
import '../../../domain/models/activity_mood_correlation.dart';
import '../../../domain/models/mood_distribution_item.dart';
import '../../../domain/models/monthly_mood_day.dart';
import '../../../domain/models/weekly_mood_point.dart';
import 'stats_state.dart';

final class StatsCubit extends Cubit<StatsState> {
  StatsCubit({
    required MoodAnalyticsRepository? repository,
    DateTime? anchorDate,
    Stream<List<WeeklyMoodPoint>>? weeklyTrend,
    Stream<List<MonthlyMoodDay>>? monthlyHeatmap,
    Stream<List<ActivityMoodCorrelation>>? activityCorrelations,
    Stream<List<MoodDistributionItem>>? moodDistribution,
  }) : _repository = repository,
       _injectedWeeklyTrend = weeklyTrend,
       _injectedMonthlyHeatmap = monthlyHeatmap,
       _injectedActivityCorrelations = activityCorrelations,
       _injectedMoodDistribution = moodDistribution,
       super(StatsState.initial(anchorDate ?? DateTime.now())) {
    _subscribe();
  }

  final MoodAnalyticsRepository? _repository;
  final Stream<List<WeeklyMoodPoint>>? _injectedWeeklyTrend;
  final Stream<List<MonthlyMoodDay>>? _injectedMonthlyHeatmap;
  final Stream<List<ActivityMoodCorrelation>>? _injectedActivityCorrelations;
  final Stream<List<MoodDistributionItem>>? _injectedMoodDistribution;

  StreamSubscription<List<WeeklyMoodPoint>>? _weeklySubscription;
  StreamSubscription<List<MonthlyMoodDay>>? _monthlySubscription;
  StreamSubscription<List<ActivityMoodCorrelation>>? _activitySubscription;
  StreamSubscription<List<MoodDistributionItem>>? _distributionSubscription;

  bool _hasWeekly = false;
  bool _hasMonthly = false;
  bool _hasActivity = false;
  bool _hasDistribution = false;

  void setPeriod(StatsPeriod period) {
    if (period == state.period) return;
    _load(period: period, anchorDate: state.anchorDate);
  }

  void goPrevious() {
    _load(anchorDate: _shiftAnchor(forward: false));
  }

  void goNext() {
    _load(anchorDate: _shiftAnchor(forward: true));
  }

  DateTime _shiftAnchor({required bool forward}) {
    final direction = forward ? 1 : -1;
    return switch (state.period) {
      StatsPeriod.week => state.anchorDate.add(Duration(days: 7 * direction)),
      StatsPeriod.month => DateTime(
        state.anchorDate.year,
        state.anchorDate.month + direction,
        state.anchorDate.day,
      ),
      StatsPeriod.year => DateTime(
        state.anchorDate.year + direction,
        state.anchorDate.month,
        state.anchorDate.day,
      ),
    };
  }

  void _load({StatsPeriod? period, DateTime? anchorDate}) {
    final nextPeriod = period ?? state.period;
    final nextAnchor = anchorDate ?? state.anchorDate;
    final range = StatsRange.forPeriod(nextPeriod, nextAnchor);

    emit(
      state.copyWith(
        status: StatsLoadStatus.loading,
        period: nextPeriod,
        anchorDate: nextAnchor,
        range: range,
        calendarMonth: DateTime(nextAnchor.year, nextAnchor.month),
      ),
    );
    _subscribe();
  }

  void _subscribe() {
    _cancelSubscriptions();
    _hasWeekly = false;
    _hasMonthly = false;
    _hasActivity = false;
    _hasDistribution = false;

    final repository = _repository;
    final range = state.range;
    final weeklyStream =
        _injectedWeeklyTrend ??
        repository!.watchWeeklyMoodTrend(_weekStartFor(range.start));
    final monthlyStream =
        _injectedMonthlyHeatmap ??
        repository!.watchMonthlyMoodHeatmap(_monthStartFor(state.anchorDate));
    final activityStream =
        _injectedActivityCorrelations ??
        repository!.watchActivityMoodCorrelationsBetween(
          start: range.start,
          end: range.end,
        );
    final distributionStream =
        _injectedMoodDistribution ??
        (repository == null
            ? Stream<List<MoodDistributionItem>>.value(const [])
            : repository.watchMoodDistribution(range.start, range.end));

    _weeklySubscription = weeklyStream.listen((items) {
      _hasWeekly = true;
      emit(state.copyWith(weeklyTrend: items));
      _markReadyIfComplete();
    }, onError: (_, _) => _markFailure());
    _monthlySubscription = monthlyStream.listen((items) {
      _hasMonthly = true;
      emit(state.copyWith(monthlyHeatmap: items));
      _markReadyIfComplete();
    }, onError: (_, _) => _markFailure());
    _activitySubscription = activityStream.listen((items) {
      _hasActivity = true;
      emit(state.copyWith(activityCorrelations: items));
      _markReadyIfComplete();
    }, onError: (_, _) => _markFailure());
    _distributionSubscription = distributionStream.listen((items) {
      _hasDistribution = true;
      emit(state.copyWith(moodDistribution: items));
      _markReadyIfComplete();
    }, onError: (_, _) => _markFailure());
  }

  void _markReadyIfComplete() {
    if (_hasWeekly && _hasMonthly && _hasActivity && _hasDistribution) {
      emit(state.copyWith(status: StatsLoadStatus.ready));
    }
  }

  void _markFailure() {
    emit(state.copyWith(status: StatsLoadStatus.failure));
  }

  DateTime _weekStartFor(DateTime date) {
    final today = DateTime(date.year, date.month, date.day);
    return today.subtract(Duration(days: today.weekday - DateTime.monday));
  }

  DateTime _monthStartFor(DateTime date) {
    return DateTime(date.year, date.month);
  }

  void _cancelSubscriptions() {
    _weeklySubscription?.cancel();
    _monthlySubscription?.cancel();
    _activitySubscription?.cancel();
    _distributionSubscription?.cancel();
  }

  @override
  Future<void> close() {
    _cancelSubscriptions();
    return super.close();
  }
}
