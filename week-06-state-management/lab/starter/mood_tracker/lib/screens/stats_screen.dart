import 'package:flutter/material.dart';
// TODO 7: Import flutter_riverpod and mood_provider
//
// 1. Add: import 'package:flutter_riverpod/flutter_riverpod.dart';
// 2. Add: import '../providers/mood_provider.dart';
// 3. Change StatelessWidget to ConsumerWidget
// 4. Add WidgetRef ref parameter to build method
// 5. Replace hardcoded stats with:
//      final stats = ref.watch(moodStatsProvider);
//    Then use stats['totalEntries'], stats['averageScore'], etc.

// TODO 7: Change to ConsumerWidget
class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  // TODO 7: Add WidgetRef ref parameter
  Widget build(BuildContext context) {
    // TODO 7: Replace these hardcoded values with ref.watch(moodStatsProvider)
    final stats = {
      'totalEntries': 3,
      'averageScore': 5.3,
      'highestScore': 8,
      'lowestScore': 3,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _StatCard(
              icon: Icons.format_list_numbered,
              label: 'Total Entries',
              value: '${stats['totalEntries']}',
            ),
            const SizedBox(height: 12),
            _StatCard(
              icon: Icons.trending_up,
              label: 'Average Score',
              value: (stats['averageScore'] as double).toStringAsFixed(1),
            ),
            const SizedBox(height: 12),
            _StatCard(
              icon: Icons.arrow_upward,
              label: 'Highest Score',
              value: '${stats['highestScore']}',
            ),
            const SizedBox(height: 12),
            _StatCard(
              icon: Icons.arrow_downward,
              label: 'Lowest Score',
              value: '${stats['lowestScore']}',
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.titleMedium),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
