import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/mood_entry.dart';
import '../dashboard_formatters.dart';
import 'history_state.dart';

typedef HistoryMoodLabelResolver = String Function(int moodScore);
typedef HistoryActivityLabelResolver = String Function(String activityName);

final class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit({
    required Stream<List<MoodEntryModel>> entries,
    DateTime Function()? clock,
    HistoryMoodLabelResolver? localizedMoodLabel,
    HistoryActivityLabelResolver? localizedActivityLabel,
  }) : _clock = clock ?? DateTime.now,
       _localizedMoodLabel = localizedMoodLabel,
       _localizedActivityLabel = localizedActivityLabel,
       super(const HistoryState.loading()) {
    _subscription = entries.listen(
      (entries) {
        _entries = entries;
        _emitReady();
      },
      onError: (_, _) =>
          emit(state.copyWith(status: HistoryLoadStatus.failure)),
    );
  }

  final DateTime Function() _clock;
  StreamSubscription<List<MoodEntryModel>>? _subscription;
  HistoryMoodLabelResolver? _localizedMoodLabel;
  HistoryActivityLabelResolver? _localizedActivityLabel;
  List<MoodEntryModel> _entries = const [];

  void updateLocalization({
    required HistoryMoodLabelResolver localizedMoodLabel,
    required HistoryActivityLabelResolver localizedActivityLabel,
  }) {
    _localizedMoodLabel = localizedMoodLabel;
    _localizedActivityLabel = localizedActivityLabel;
    if (!state.isLoading && !state.hasError) {
      _emitReady();
    }
  }

  void setQuery(String value) {
    emit(state.copyWith(query: value.trim().toLowerCase()));
    _emitReady();
  }

  void setMoodScore(int? score) {
    emit(
      score == null
          ? state.copyWith(clearMoodScore: true)
          : state.copyWith(selectedMoodScore: score),
    );
    _emitReady();
  }

  void setDateFilter(HistoryDateFilter filter) {
    emit(state.copyWith(dateFilter: filter));
    _emitReady();
  }

  void clearFilters() {
    emit(
      state.copyWith(
        query: '',
        clearMoodScore: true,
        dateFilter: HistoryDateFilter.all,
      ),
    );
    _emitReady();
  }

  void _emitReady() {
    emit(
      state.copyWith(
        status: HistoryLoadStatus.ready,
        groups: _groupEntries(_filteredEntries()),
      ),
    );
  }

  List<MoodEntryModel> _filteredEntries() {
    return _entries
        .where((entry) {
          final selectedMoodScore = state.selectedMoodScore;
          if (selectedMoodScore != null &&
              entry.moodScore != selectedMoodScore) {
            return false;
          }

          if (!state.dateFilter.includes(entry.createdAt, now: _clock())) {
            return false;
          }

          if (state.query.isEmpty) return true;
          return _searchTextFor(entry).contains(state.query);
        })
        .toList(growable: false);
  }

  String _searchTextFor(MoodEntryModel entry) {
    final localizedMoodLabel = _localizedMoodLabel;
    final localizedActivityLabel = _localizedActivityLabel;
    return [
      moodLabel(entry.moodScore),
      if (localizedMoodLabel != null) localizedMoodLabel(entry.moodScore),
      entry.note ?? '',
      ...entry.activityNames,
      if (localizedActivityLabel != null)
        ...entry.activityNames.map(localizedActivityLabel),
      ...entry.subEmotionNames,
    ].join(' ').toLowerCase();
  }

  List<HistoryDayGroup> _groupEntries(List<MoodEntryModel> entries) {
    final groupedEntries = <DateTime, List<MoodEntryModel>>{};

    for (final entry in entries) {
      final created = entry.createdAt.toLocal();
      final day = DateTime(created.year, created.month, created.day);
      groupedEntries.putIfAbsent(day, () => []).add(entry);
    }

    return [
      for (final group in groupedEntries.entries)
        HistoryDayGroup(
          date: group.key,
          entries: List.unmodifiable(group.value),
        ),
    ];
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
