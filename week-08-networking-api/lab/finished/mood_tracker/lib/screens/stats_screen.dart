import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/mood_provider.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(moodStatsProvider);

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
