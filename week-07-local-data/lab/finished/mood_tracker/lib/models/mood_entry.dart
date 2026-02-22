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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'score': score,
      'note': note,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory MoodEntry.fromMap(Map<String, dynamic> map) {
    return MoodEntry(
      id: map['id'] as String,
      score: map['score'] as int,
      note: map['note'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  @override
  String toString() {
    return 'MoodEntry(id: $id, score: $score, note: $note, createdAt: $createdAt)';
  }
}
