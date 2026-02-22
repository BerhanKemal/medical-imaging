import 'package:flutter/material.dart';
// TODO 4: Import flutter_riverpod and mood_provider
//
// 1. Add: import 'package:flutter_riverpod/flutter_riverpod.dart';
// 2. Add: import '../providers/mood_provider.dart';
// 3. Change StatelessWidget to ConsumerWidget
// 4. Add WidgetRef ref parameter to build method
// 5. Replace _hardcodedMoods with: final moods = ref.watch(moodProvider);
import '../models/mood_entry.dart';
import '../widgets/mood_card.dart';
import 'add_mood_screen.dart';
import 'mood_detail_screen.dart';
import 'stats_screen.dart';

// TODO 4: Change this to ConsumerWidget and use ref.watch(moodProvider)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  // TODO 4: Add WidgetRef ref parameter: Widget build(BuildContext context, WidgetRef ref)
  Widget build(BuildContext context) {
    // TODO 4: Replace this hardcoded list with:
    //   final moods = ref.watch(moodProvider);
    final moods = _hardcodedMoods;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Tracker'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StatsScreen()),
              );
            },
          ),
        ],
      ),
      body: moods.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sentiment_neutral, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No mood entries yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap + to add your first entry',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: moods.length,
              itemBuilder: (context, index) {
                final entry = moods[index];
                return MoodCard(
                  entry: entry,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MoodDetailScreen(entry: entry),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMoodScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Hardcoded sample data — will be removed once Riverpod is wired up
final _hardcodedMoods = [
  MoodEntry(score: 8, note: 'Great day at the lab!', createdAt: DateTime.now().subtract(const Duration(hours: 2))),
  MoodEntry(score: 5, note: 'Feeling okay', createdAt: DateTime.now().subtract(const Duration(hours: 5))),
  MoodEntry(score: 3, note: 'Stressful morning', createdAt: DateTime.now().subtract(const Duration(days: 1))),
];
