import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mood_entry.dart';

class MoodNotifier extends StateNotifier<List<MoodEntry>> {
  MoodNotifier()
      : super([
          MoodEntry(
            score: 8,
            note: 'Great day at the lab!',
            createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          MoodEntry(
            score: 5,
            note: 'Feeling okay',
            createdAt: DateTime.now().subtract(const Duration(hours: 5)),
          ),
          MoodEntry(
            score: 3,
            note: 'Stressful morning',
            createdAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
        ]);

  void addMood(int score, String? note) {
    final newEntry = MoodEntry(score: score, note: note);
    state = [newEntry, ...state];
  }

  void deleteMood(String id) {
    state = state.where((e) => e.id != id).toList();
  }

  void updateMood(String id, int score, String? note) {
    state = state
        .map((e) => e.id == id ? e.copyWith(score: score, note: note) : e)
        .toList();
  }
}

final moodProvider =
    StateNotifierProvider<MoodNotifier, List<MoodEntry>>((ref) {
  return MoodNotifier();
});

final moodStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final moods = ref.watch(moodProvider);
  if (moods.isEmpty) {
    return {
      'totalEntries': 0,
      'averageScore': 0.0,
      'highestScore': 0,
      'lowestScore': 0,
    };
  }
  final scores = moods.map((e) => e.score);
  return {
    'totalEntries': moods.length,
    'averageScore': scores.reduce((a, b) => a + b) / moods.length,
    'highestScore': scores.reduce((a, b) => a > b ? a : b),
    'lowestScore': scores.reduce((a, b) => a < b ? a : b),
  };
});
