import 'package:uuid/uuid.dart';

class MoodEntry {
  final String id;
  final int score;
  final String? note;
  final DateTime createdAt;

  MoodEntry({
    String? id,
    required this.score,
    this.note,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  MoodEntry copyWith({
    String? id,
    int? score,
    String? note,
    DateTime? createdAt,
  }) {
    return MoodEntry(
      id: id ?? this.id,
      score: score ?? this.score,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'MoodEntry(id: $id, score: $score, note: $note, createdAt: $createdAt)';
  }
}
