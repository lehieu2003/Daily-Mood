final class DailyReflectionModel {
  const DailyReflectionModel({
    required this.id,
    required this.uuid,
    required this.date,
    required this.prompt,
    required this.response,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String uuid;
  final DateTime date;
  final String prompt;
  final String response;
  final DateTime createdAt;
  final DateTime updatedAt;
}
