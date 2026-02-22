import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/mood_entry.dart';
import 'mood_score_indicator.dart';

class MoodCard extends StatelessWidget {
  final MoodEntry entry;
  final VoidCallback? onTap;

  const MoodCard({
    super.key,
    required this.entry,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: MoodScoreIndicator(score: entry.score),
        title: Text(
          entry.note ?? 'No note',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: entry.note == null
                ? Theme.of(context).colorScheme.onSurfaceVariant
                : null,
            fontStyle: entry.note == null ? FontStyle.italic : null,
          ),
        ),
        subtitle: Text(
          DateFormat('MMM d, yyyy – HH:mm').format(entry.createdAt),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
