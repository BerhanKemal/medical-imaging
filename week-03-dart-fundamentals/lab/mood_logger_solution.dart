/// Week 3 Individual Assignment -- CLI Mood Logger (SOLUTION)
///
/// Complete, working solution for the mood logger assignment.
/// Do NOT distribute to students before the assignment deadline.
///
/// Run with: dart run mood_logger_solution.dart

import 'dart:io';

// ============================================================================
// MoodEntry Class
// ============================================================================

class MoodEntry {
  final DateTime timestamp;
  final int score;
  final String note;

  MoodEntry(this.score, this.note) : timestamp = DateTime.now();

  @override
  String toString() {
    String year = timestamp.year.toString();
    String month = timestamp.month.toString().padLeft(2, '0');
    String day = timestamp.day.toString().padLeft(2, '0');
    String hour = timestamp.hour.toString().padLeft(2, '0');
    String minute = timestamp.minute.toString().padLeft(2, '0');
    return '[$year-$month-$day $hour:$minute] Score: $score/10 - $note';
  }
}

// ============================================================================
// MoodLogger Class
// ============================================================================

class MoodLogger {
  final List<MoodEntry> _entries = [];

  void addEntry(int score, String note) {
    if (score < 1 || score > 10) {
      print('Error: Score must be between 1 and 10.');
      return;
    }
    _entries.add(MoodEntry(score, note));
    print('Entry added!');
  }

  List<MoodEntry> getAllEntries() {
    return List.from(_entries);
  }

  double getAverageScore() {
    if (_entries.isEmpty) return 0.0;
    int total = _entries.fold(0, (sum, entry) => sum + entry.score);
    return total / _entries.length;
  }

  List<MoodEntry> getEntriesAbove(int threshold) {
    return _entries.where((entry) => entry.score >= threshold).toList();
  }

  int get entryCount => _entries.length;
}

// ============================================================================
// Main -- Interactive CLI
// ============================================================================

void main() {
  final logger = MoodLogger();

  print('=== Mood Logger ===');
  print('Track your daily mood on a scale of 1-10.\n');

  bool running = true;
  while (running) {
    print('1. Add mood entry');
    print('2. View all entries');
    print('3. View average mood');
    print('4. Filter by minimum score');
    print('5. Quit');
    stdout.write('\nChoose an option: ');

    String? input = stdin.readLineSync();
    int? choice = int.tryParse(input ?? '');

    switch (choice) {
      case 1:
        stdout.write('Enter mood score (1-10): ');
        String? scoreInput = stdin.readLineSync();
        int? score = int.tryParse(scoreInput ?? '');

        if (score == null) {
          print('Invalid score. Please enter a number.');
          break;
        }

        stdout.write('Enter a note: ');
        String note = stdin.readLineSync() ?? '';

        logger.addEntry(score, note);
        break;

      case 2:
        var entries = logger.getAllEntries();
        if (entries.isEmpty) {
          print('No entries yet. Add your first mood entry!');
        } else {
          print('\n--- All Entries (${entries.length}) ---');
          for (var entry in entries) {
            print(entry);
          }
        }
        break;

      case 3:
        if (logger.entryCount == 0) {
          print('No entries yet. Add some entries first!');
        } else {
          double avg = logger.getAverageScore();
          print('Average mood score: ${avg.toStringAsFixed(1)} '
              '(based on ${logger.entryCount} entries)');
        }
        break;

      case 4:
        stdout.write('Enter minimum score threshold: ');
        String? thresholdInput = stdin.readLineSync();
        int? threshold = int.tryParse(thresholdInput ?? '');

        if (threshold == null) {
          print('Invalid threshold. Please enter a number.');
          break;
        }

        var filtered = logger.getEntriesAbove(threshold);
        if (filtered.isEmpty) {
          print('No entries with score >= $threshold.');
        } else {
          print('\n--- Entries with score >= $threshold (${filtered.length}) ---');
          for (var entry in filtered) {
            print(entry);
          }
        }
        break;

      case 5:
        running = false;
        print('Goodbye!');
        break;

      default:
        print('Invalid option. Please choose 1-5.');
    }
    print('');
  }
}
