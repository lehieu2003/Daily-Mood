import 'package:equatable/equatable.dart';

final class MoodEntryModel extends Equatable {
  const MoodEntryModel({
    required this.id,
    required this.uuid,
    required this.moodScore,
    required this.createdAt,
    required this.updatedAt,
    this.note,
    this.voiceNotePath,
  });

  final int id;
  final String uuid;
  final int moodScore;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? note;
  final String? voiceNotePath;

  @override
  List<Object?> get props => [
    id,
    uuid,
    moodScore,
    createdAt,
    updatedAt,
    note,
    voiceNotePath,
  ];
}
