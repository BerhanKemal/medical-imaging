import '../models/mood_entry.dart';
import '../services/mood_api_service.dart';
import 'database_helper.dart';

class MoodRepository {
  final DatabaseHelper _dbHelper;
  final MoodApiService _apiService;

  MoodRepository({
    DatabaseHelper? dbHelper,
    MoodApiService? apiService,
  })  : _dbHelper = dbHelper ?? DatabaseHelper.instance,
        _apiService = apiService ?? MoodApiService();

  Future<List<MoodEntry>> getAllMoods() async {
    try {
      final moods = await _apiService.getMoods();
      return moods;
    } catch (e) {
      // API failed — fall back to local database
      final maps = await _dbHelper.getMoods();
      return maps.map((m) => MoodEntry.fromMap(m)).toList();
    }
  }

  Future<MoodEntry> addMood(int score, String? note) async {
    try {
      final entry = await _apiService.createMood(score, note);
      await _dbHelper.insertMood(entry.toMap());
      return entry;
    } catch (e) {
      // API failed — save locally only
      final entry = MoodEntry(score: score, note: note);
      await _dbHelper.insertMood(entry.toMap());
      return entry;
    }
  }

  Future<void> deleteMood(String id) async {
    try {
      await _apiService.deleteMood(id);
    } catch (e) {
      // API failed — continue with local delete
    }
    await _dbHelper.deleteMood(id);
  }

  Future<void> updateMood(MoodEntry entry) async {
    try {
      await _apiService.updateMood(entry.id, entry.score, entry.note);
    } catch (e) {
      // API failed — continue with local update
    }
    await _dbHelper.updateMood(entry.id, entry.toMap());
  }
}
