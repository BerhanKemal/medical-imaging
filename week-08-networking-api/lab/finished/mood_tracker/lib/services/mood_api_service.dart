import '../models/mood_entry.dart';
import 'api_client.dart';

class MoodApiService {
  final ApiClient _apiClient;

  MoodApiService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<List<MoodEntry>> getMoods() async {
    final data = await _apiClient.get('/moods');
    final entries = data['entries'] as List;
    return entries
        .map((e) => MoodEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<MoodEntry> createMood(int score, String? note) async {
    final data = await _apiClient.post('/moods', {
      'score': score,
      'note': note,
    });
    return MoodEntry.fromJson(data as Map<String, dynamic>);
  }

  Future<void> deleteMood(String id) async {
    await _apiClient.delete('/moods/$id');
  }

  Future<MoodEntry> updateMood(String id, int score, String? note) async {
    final data = await _apiClient.put('/moods/$id', {
      'score': score,
      'note': note,
    });
    return MoodEntry.fromJson(data as Map<String, dynamic>);
  }
}
