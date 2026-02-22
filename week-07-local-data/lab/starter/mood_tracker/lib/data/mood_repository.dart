import '../models/mood_entry.dart';
import 'database_helper.dart';

class MoodRepository {
  final DatabaseHelper _dbHelper;

  MoodRepository({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  // ===========================================================================
  // TODO 5: Implement repository methods
  //
  // The repository sits between the provider and the database. It converts
  // between MoodEntry objects and database maps.
  //
  // getAllMoods() should:
  //   1. Call _dbHelper.getMoods() to get raw maps
  //   2. Convert each map to a MoodEntry using MoodEntry.fromMap()
  //   3. Return the list
  //
  // addMood(MoodEntry entry) should:
  //   1. Call _dbHelper.insertMood(entry.toMap())
  //
  // deleteMood(String id) should:
  //   1. Call _dbHelper.deleteMood(id)
  //
  // updateMood(MoodEntry entry) should:
  //   1. Call _dbHelper.updateMood(entry.id, entry.toMap())
  //
  // Hint: getAllMoods() returns Future<List<MoodEntry>>. Use .map() to
  // convert the list: maps.map((m) => MoodEntry.fromMap(m)).toList()
  // ===========================================================================

  // TODO 5: Uncomment and complete:
  //
  // Future<List<MoodEntry>> getAllMoods() async {
  //   final maps = await _dbHelper.getMoods();
  //   // Convert maps to MoodEntry objects
  //   return [];
  // }
  //
  // Future<void> addMood(MoodEntry entry) async {
  //   // Insert the entry into the database
  // }
  //
  // Future<void> deleteMood(String id) async {
  //   // Delete the entry from the database
  // }
  //
  // Future<void> updateMood(MoodEntry entry) async {
  //   // Update the entry in the database
  // }
}
