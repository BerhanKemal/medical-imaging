import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mood_entry.dart';

// =============================================================================
// TODO 1: Implement the MoodNotifier class
//
// Create a class that extends StateNotifier<List<MoodEntry>>.
//
// The constructor should initialize with sample data so you can see entries
// in the UI right away. Create 2-3 sample MoodEntry objects.
//
// Then implement three methods:
//   - addMood(int score, String? note) — creates a new MoodEntry and adds
//     it to the beginning of the list using immutable state update:
//       state = [newEntry, ...state];
//
//   - deleteMood(String id) — removes the entry with the given id:
//       state = state.where((e) => e.id != id).toList();
//
//   - updateMood(String id, int score, String? note) — finds the entry by id
//     and replaces it using copyWith:
//       state = state.map((e) => e.id == id ? e.copyWith(...) : e).toList();
//
// Hint: Remember that StateNotifier requires IMMUTABLE state updates.
// You must reassign `state`, not mutate the existing list.
// =============================================================================

// TODO 1: Uncomment and complete the MoodNotifier class below:
//
// class MoodNotifier extends StateNotifier<List<MoodEntry>> {
//   MoodNotifier() : super([]) {
//     // Initialize with sample data
//   }
//
//   void addMood(int score, String? note) {
//     // Add a new mood entry to the beginning of the list
//   }
//
//   void deleteMood(String id) {
//     // Remove the entry with the given id
//   }
//
//   void updateMood(String id, int score, String? note) {
//     // Update the entry with the given id using copyWith
//   }
// }

// =============================================================================
// TODO 2: Define the providers
//
// Create two providers:
//
// 1. moodProvider — a StateNotifierProvider that exposes MoodNotifier:
//      final moodProvider = StateNotifierProvider<MoodNotifier, List<MoodEntry>>((ref) {
//        return MoodNotifier();
//      });
//
// 2. moodStatsProvider — a computed Provider that derives statistics from
//    the mood list. It should return a Map<String, dynamic> with keys:
//      - 'totalEntries': number of entries
//      - 'averageScore': average score (double), or 0.0 if empty
//      - 'highestScore': maximum score, or 0 if empty
//      - 'lowestScore': minimum score, or 0 if empty
//
//    Use ref.watch(moodProvider) to get the current mood list.
//
// Hint: This is "derived state" — it automatically recalculates whenever
// the mood list changes. No manual syncing needed!
// =============================================================================

// TODO 2: Uncomment and complete the provider definitions below:
//
// final moodProvider = StateNotifierProvider<MoodNotifier, List<MoodEntry>>((ref) {
//   return MoodNotifier();
// });
//
// final moodStatsProvider = Provider<Map<String, dynamic>>((ref) {
//   final moods = ref.watch(moodProvider);
//   // Calculate and return stats map
//   return {};
// });
