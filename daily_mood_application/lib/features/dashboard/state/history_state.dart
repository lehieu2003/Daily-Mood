import '../../../domain/models/mood_entry.dart';

enum HistoryLoadStatus { loading, ready, failure }

enum HistoryDateFilter {
  all,
  today,
  sevenDays,
  thirtyDays;

  bool includes(DateTime date, {DateTime? now}) {
    if (this == HistoryDateFilter.all) return true;

    final current = now ?? DateTime.now();
    final today = DateTime(current.year, current.month, current.day);
    final local = date.toLocal();
    final day = DateTime(local.year, local.month, local.day);

    return switch (this) {
      HistoryDateFilter.today => day == today,
      HistoryDateFilter.sevenDays => !day.isBefore(
        today.subtract(const Duration(days: 6)),
      ),
      HistoryDateFilter.thirtyDays => !day.isBefore(
        today.subtract(const Duration(days: 29)),
      ),
      HistoryDateFilter.all => true,
    };
  }
}

final class HistoryDayGroup {
  const HistoryDayGroup({required this.date, required this.entries});

  final DateTime date;
  final List<MoodEntryModel> entries;
}

final class HistoryState {
  const HistoryState({
    required this.status,
    required this.query,
    required this.selectedMoodScore,
    required this.dateFilter,
    required this.groups,
  });

  const HistoryState.loading()
    : this(
        status: HistoryLoadStatus.loading,
        query: '',
        selectedMoodScore: null,
        dateFilter: HistoryDateFilter.all,
        groups: const [],
      );

  final HistoryLoadStatus status;
  final String query;
  final int? selectedMoodScore;
  final HistoryDateFilter dateFilter;
  final List<HistoryDayGroup> groups;

  bool get isLoading => status == HistoryLoadStatus.loading;
  bool get hasError => status == HistoryLoadStatus.failure;
  bool get hasActiveFilters =>
      query.isNotEmpty ||
      selectedMoodScore != null ||
      dateFilter != HistoryDateFilter.all;
  bool get isEmpty => groups.isEmpty;

  HistoryState copyWith({
    HistoryLoadStatus? status,
    String? query,
    int? selectedMoodScore,
    bool clearMoodScore = false,
    HistoryDateFilter? dateFilter,
    List<HistoryDayGroup>? groups,
  }) {
    return HistoryState(
      status: status ?? this.status,
      query: query ?? this.query,
      selectedMoodScore: clearMoodScore
          ? null
          : selectedMoodScore ?? this.selectedMoodScore,
      dateFilter: dateFilter ?? this.dateFilter,
      groups: groups ?? this.groups,
    );
  }
}
