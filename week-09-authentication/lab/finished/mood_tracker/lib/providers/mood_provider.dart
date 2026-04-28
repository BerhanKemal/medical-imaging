import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mood_entry.dart';
import '../data/mood_repository.dart';

class MoodNotifier extends StateNotifier<List<MoodEntry>> {
  final MoodRepository _repository;

  MoodNotifier(this._repository) : super([]);

  Future<void> loadMoods() async {
    state = await _repository.getAllMoods();
  }

  Future<void> addMood(int score, String? note) async {
    final entry = await _repository.addMood(score, note);
    state = [entry, ...state];
  }

  Future<void> deleteMood(String id) async {
    await _repository.deleteMood(id);
    state = state.where((e) => e.id != id).toList();
  }

  Future<void> updateMood(String id, int score, String? note) async {
    final updated =
        state.firstWhere((e) => e.id == id).copyWith(score: score, note: note);
    await _repository.updateMood(updated);
    state = state.map((e) => e.id == id ? updated : e).toList();
  }
}

final moodProvider =
    StateNotifierProvider<MoodNotifier, List<MoodEntry>>((ref) {
  return MoodNotifier(MoodRepository());
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
