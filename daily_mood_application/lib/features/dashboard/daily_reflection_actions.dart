import '../../domain/models/daily_reflection.dart';

typedef DailyReflectionStreamFactory =
    Stream<DailyReflectionModel?> Function(DateTime date);

typedef DailyReflectionSaveAction =
    Future<void> Function({
      required DateTime date,
      required String prompt,
      required String response,
    });
