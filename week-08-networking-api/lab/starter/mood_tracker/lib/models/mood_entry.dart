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

  // SQLite serialization (from Week 7)
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

  // ===========================================================================
  // TODO 1: Implement toJson() and fromJson() for API serialization
  //
  // The API uses DIFFERENT field names than SQLite:
  //   - API response (MoodResponse): { "id": 1, "score": 8, "note": "...", "created_at": "..." }
  //   - API request (MoodCreate): { "score": 8, "note": "..." }
  //   - Note: API uses int id, SQLite uses String id
  //
  // toJson() is for SENDING data to the API (MoodCreate schema):
  //   Map<String, dynamic> toJson() {
  //     return {
  //       'score': score,
  //       'note': note,
  //     };
  //   }
  //
  // fromJson() is for RECEIVING data from the API (MoodResponse schema):
  //   factory MoodEntry.fromJson(Map<String, dynamic> json) {
  //     return MoodEntry(
  //       id: json['id'].toString(),  // API returns int, we store as String
  //       score: json['score'] as int,
  //       note: json['note'] as String?,
  //       createdAt: DateTime.parse(json['created_at'] as String),
  //     );
  //   }
  //
  // Hint: toJson() only includes score and note because the API assigns
  // the id and created_at automatically on the server side.
  // ===========================================================================

  // TODO 1: Uncomment and complete:
  //
  // Map<String, dynamic> toJson() {
  //   return {};
  // }
  //
  // factory MoodEntry.fromJson(Map<String, dynamic> json) {
  //   return MoodEntry(score: 0); // Replace with actual implementation
  // }

  @override
  String toString() {
    return 'MoodEntry(id: $id, score: $score, note: $note, createdAt: $createdAt)';
  }
}
