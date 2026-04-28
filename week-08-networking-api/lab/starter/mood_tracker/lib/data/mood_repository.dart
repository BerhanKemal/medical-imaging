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

  // ===========================================================================
  // TODO 7: Update repository to use API with local DB as fallback
  //
  // getAllMoods() should try the API first, fall back to local DB:
  //   Future<List<MoodEntry>> getAllMoods() async {
  //     try {
  //       final moods = await _apiService.getMoods();
  //       return moods;
  //     } catch (e) {
  //       // API failed — fall back to local database
  //       final maps = await _dbHelper.getMoods();
  //       return maps.map((m) => MoodEntry.fromMap(m)).toList();
  //     }
  //   }
  //
  // addMood() should create via API and also save locally:
  //   Future<MoodEntry> addMood(int score, String? note) async {
  //     try {
  //       final entry = await _apiService.createMood(score, note);
  //       await _dbHelper.insertMood(entry.toMap());
  //       return entry;
  //     } catch (e) {
  //       // API failed — save locally only
  //       final entry = MoodEntry(score: score, note: note);
  //       await _dbHelper.insertMood(entry.toMap());
  //       return entry;
  //     }
  //   }
  //
  // deleteMood() should delete via API and also delete locally:
  //   Future<void> deleteMood(String id) async {
  //     try {
  //       await _apiService.deleteMood(id);
  //     } catch (e) {
  //       // API failed — continue with local delete
  //     }
  //     await _dbHelper.deleteMood(id);
  //   }
  //
  // updateMood() follows the same pattern.
  //
  // This "try API, catch fall back to local" pattern gives users a smooth
  // experience even when the network is unavailable.
  // ===========================================================================

  // TODO 7: Replace these local-only methods with API + fallback versions

  Future<List<MoodEntry>> getAllMoods() async {
    final maps = await _dbHelper.getMoods();
    return maps.map((m) => MoodEntry.fromMap(m)).toList();
  }

  Future<MoodEntry> addMood(int score, String? note) async {
    final entry = MoodEntry(score: score, note: note);
    await _dbHelper.insertMood(entry.toMap());
    return entry;
  }

  Future<void> deleteMood(String id) async {
    await _dbHelper.deleteMood(id);
  }

  Future<void> updateMood(MoodEntry entry) async {
    await _dbHelper.updateMood(entry.id, entry.toMap());
  }
}
