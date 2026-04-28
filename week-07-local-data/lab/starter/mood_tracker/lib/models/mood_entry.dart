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

  // ===========================================================================
  // TODO 1: Implement toMap() and fromMap() for SQLite serialization
  //
  // toMap() should return a Map<String, dynamic> with keys matching the
  // database columns:
  //   {
  //     'id': id,
  //     'score': score,
  //     'note': note,
  //     'created_at': createdAt.toIso8601String(),
  //   }
  //
  // fromMap() is a factory constructor that creates a MoodEntry from a
  // database row (Map<String, dynamic>):
  //   factory MoodEntry.fromMap(Map<String, dynamic> map) {
  //     return MoodEntry(
  //       id: map['id'] as String,
  //       score: map['score'] as int,
  //       note: map['note'] as String?,
  //       createdAt: DateTime.parse(map['created_at'] as String),
  //     );
  //   }
  //
  // Hint: DateTime.toIso8601String() converts to "2026-02-22T14:30:00.000"
  // and DateTime.parse() converts it back.
  // ===========================================================================

  // TODO 1: Uncomment and complete:
  //
  // Map<String, dynamic> toMap() {
  //   return {};
  // }
  //
  // factory MoodEntry.fromMap(Map<String, dynamic> map) {
  //   return MoodEntry(score: 0); // Replace with actual implementation
  // }

  @override
  String toString() {
    return 'MoodEntry(id: $id, score: $score, note: $note, createdAt: $createdAt)';
  }
}
