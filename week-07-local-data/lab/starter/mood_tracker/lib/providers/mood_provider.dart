import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mood_entry.dart';
import '../data/mood_repository.dart';

class MoodNotifier extends StateNotifier<List<MoodEntry>> {
  final MoodRepository _repository;

  MoodNotifier(this._repository) : super([]);

  // ===========================================================================
  // TODO 6: Update methods to use the repository and add loadMoods()
  //
  // loadMoods() is a new async method that loads all moods from the database:
  //   Future<void> loadMoods() async {
  //     state = await _repository.getAllMoods();
  //   }
  //
  // Update addMood() to also save to the repository:
  //   Future<void> addMood(int score, String? note) async {
  //     final newEntry = MoodEntry(score: score, note: note);
  //     await _repository.addMood(newEntry);
  //     state = [newEntry, ...state];
  //   }
  //
  // Update deleteMood() to also delete from the repository:
  //   Future<void> deleteMood(String id) async {
  //     await _repository.deleteMood(id);
  //     state = state.where((e) => e.id != id).toList();
  //   }
  //
  // Update updateMood() to also update in the repository:
  //   Future<void> updateMood(String id, int score, String? note) async {
  //     final updated = state.firstWhere((e) => e.id == id).copyWith(score: score, note: note);
  //     await _repository.updateMood(updated);
  //     state = state.map((e) => e.id == id ? updated : e).toList();
  //   }
  //
  // Note: Methods are now async (Future<void>) because database operations
  // are asynchronous. The UI state is still updated immediately after the
  // database call completes.
  // ===========================================================================

  // TODO 6: Replace these methods with async versions that use _repository

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
