import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'mood_tracker.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE mood_entries (
        id TEXT PRIMARY KEY,
        score INTEGER NOT NULL,
        note TEXT,
        created_at TEXT NOT NULL
      )
    ''');
  }

  Future<void> insertMood(Map<String, dynamic> mood) async {
    final db = await database;
    await db.insert(
      'mood_entries',
      mood,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getMoods() async {
    final db = await database;
    return await db.query('mood_entries', orderBy: 'created_at DESC');
  }

  Future<void> deleteMood(String id) async {
    final db = await database;
    await db.delete('mood_entries', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateMood(String id, Map<String, dynamic> mood) async {
    final db = await database;
    await db.update(
      'mood_entries',
      mood,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
