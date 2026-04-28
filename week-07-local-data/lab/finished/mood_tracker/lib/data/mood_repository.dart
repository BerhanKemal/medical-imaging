import '../models/mood_entry.dart';
import 'database_helper.dart';

class MoodRepository {
  final DatabaseHelper _dbHelper;

  MoodRepository({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  Future<List<MoodEntry>> getAllMoods() async {
    final maps = await _dbHelper.getMoods();
    return maps.map((m) => MoodEntry.fromMap(m)).toList();
  }

  Future<void> addMood(MoodEntry entry) async {
    await _dbHelper.insertMood(entry.toMap());
  }

  Future<void> deleteMood(String id) async {
    await _dbHelper.deleteMood(id);
  }

  Future<void> updateMood(MoodEntry entry) async {
    await _dbHelper.updateMood(entry.id, entry.toMap());
  }
}
