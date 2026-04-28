/// Week 3 Individual Assignment -- CLI Mood Logger (TEMPLATE)
///
/// Build a command-line mood tracking application.
/// Implement all the TODO sections below.
///
/// Run with: dart run mood_logger_template.dart
///
/// Requirements:
///   - MoodEntry class to represent a single mood log
///   - MoodLogger class to manage a collection of entries
///   - Interactive CLI with a menu loop
///
/// Do NOT use AI tools. Write all code yourself.

import 'dart:io';

// ============================================================================
// MoodEntry Class
// ============================================================================

/// Represents a single mood log entry.
///
/// Fields:
///   - DateTime timestamp  -- when the entry was created
///   - int score           -- mood score from 1 (very bad) to 10 (excellent)
///   - String note         -- a short description of the mood
class MoodEntry {
  final DateTime timestamp;
  final int score;
  final String note;

  MoodEntry(this.score, this.note) : timestamp = DateTime.now();

  @override
  String toString() {
    String y = timestamp.year.toString();
    String m = timestamp.month.toString().padLeft(2, '0');
    String d = timestamp.day.toString().padLeft(2, '0');
    String h = timestamp.hour.toString().padLeft(2, '0');
    String min = timestamp.minute.toString().padLeft(2, '0');

    return "[$y-$m-$d $h:$min] Score: $score/10 - $note";
  }
}

// ============================================================================
// MoodLogger Class
// ============================================================================

/// Manages a collection of MoodEntry objects.
class MoodLogger {
  final List<MoodEntry> _entries = [];

  void addEntry(int score, String note) {
    if (score >= 1 && score <= 10) {
      _entries.add(MoodEntry(score, note));
      print('Entry added!');
    } else {
      print('Error: Score must be between 1 and 10.');
    }
  }

  List<MoodEntry> getAllEntries() {
    return List.from(_entries);
  }

  double getAverageScore() {
    if (_entries.isEmpty) return 0.0;
    // fold() ile tüm skorları topluyoruz
    int totalScore = _entries.fold(0, (sum, entry) => sum + entry.score);
    return totalScore / _entries.length;
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

  print('= Mood Logger =');
  print('Track your daily mood on a scale of 1-10.\n');

  bool running = true;
  while (running) {
    print('1. Add mood entry');
    print('2. View all entries');
    print('3. View average mood');
    print('4. Filter by minimum score');
    print('5. Exit');
    stdout.write('\nChoose an option: ');

    String? input = stdin.readLineSync();
    int? choice = int.tryParse(input ?? '');

    switch (choice) {
      case 1:
        stdout.write('Enter mood score 1-10: ');
        int? score = int.tryParse(stdin.readLineSync() ?? '');
        stdout.write('Enter note: ');
        String note = stdin.readLineSync() ?? '';
        
        if (score != null) {
          logger.addEntry(score, note);
        } else {
          print('Wrong score format.');
        }
        break;
      case 2:
        var entries = logger.getAllEntries();
        if (entries.isEmpty) {
          print('No entries yet.');
        } else {
          entries.forEach(print);
        }
        break;
      case 3:
        if (logger.entryCount == 0) {
          print('Error. No entries.');
        } else {
          print('Average mood score: ${logger.getAverageScore().toStringAsFixed(1)}');
        }
        break;
      case 4:
        stdout.write('Enter threshold number 1-10: ');
        int? threshold = int.tryParse(stdin.readLineSync() ?? '');
        if (threshold != null) {
          var filtered = logger.getEntriesAbove(threshold);
          if (filtered.isEmpty) {
            print('No entries found above $threshold.');
          } else {
            filtered.forEach(print);
          }
        }
        break;
      case 5:
        running = false;
        print('See you!');
        break;
      default:
        print('Error. Please choose 1-5.');
    }
    print('');
  }
}