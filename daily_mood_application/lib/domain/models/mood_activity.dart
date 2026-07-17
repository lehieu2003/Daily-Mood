import 'package:equatable/equatable.dart';

final class MoodActivity extends Equatable {
  const MoodActivity({
    required this.id,
    required this.name,
    required this.category,
    required this.isCustom,
    this.isArchived = false,
  });

  final int id;
  final String name;
  final String category;
  final bool isCustom;
  final bool isArchived;

  @override
  List<Object?> get props => [id, name, category, isCustom, isArchived];
}
