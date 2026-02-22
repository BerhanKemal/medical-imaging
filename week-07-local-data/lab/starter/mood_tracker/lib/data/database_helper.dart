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

  // ===========================================================================
  // TODO 2: Implement _initDatabase() and _onCreate()
  //
  // _initDatabase() should:
  //   1. Get the database path using getDatabasesPath()
  //   2. Join it with 'mood_tracker.db' using the join() function from path
  //   3. Call openDatabase() with the path, version 1, and onCreate callback
  //   4. Return the database
  //
  // _onCreate() should execute a CREATE TABLE statement:
  //   CREATE TABLE mood_entries (
  //     id TEXT PRIMARY KEY,
  //     score INTEGER NOT NULL,
  //     note TEXT,
  //     created_at TEXT NOT NULL
  //   )
  //
  // Hint: Use db.execute() to run SQL statements.
  // ===========================================================================

  // TODO 2: Uncomment and complete:
  //
  // Future<Database> _initDatabase() async {
  //   final dbPath = await getDatabasesPath();
  //   final path = join(dbPath, 'mood_tracker.db');
  //   return await openDatabase(path, version: 1, onCreate: _onCreate);
  // }
  //
  // Future<void> _onCreate(Database db, int version) async {
  //   await db.execute('''
  //     -- Write your CREATE TABLE statement here
  //   ''');
  // }

  // Placeholder so the app compiles before TODO 2 is filled in
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'mood_tracker.db');
    return await openDatabase(path, version: 1);
  }

  // ===========================================================================
  // TODO 3: Implement insertMood()
  //
  // This method takes a Map<String, dynamic> (from MoodEntry.toMap()) and
  // inserts it into the mood_entries table.
  //
  //   Future<void> insertMood(Map<String, dynamic> mood) async {
  //     final db = await database;
  //     await db.insert(
  //       'mood_entries',
  //       mood,
  //       conflictAlgorithm: ConflictAlgorithm.replace,
  //     );
  //   }
  //
  // ConflictAlgorithm.replace means: if an entry with the same id already
  // exists, replace it instead of throwing an error.
  // ===========================================================================

  // TODO 3: Uncomment and complete:
  //
  // Future<void> insertMood(Map<String, dynamic> mood) async {
  //   // Insert the mood map into the mood_entries table
  // }

  // ===========================================================================
  // TODO 4: Implement getMoods(), deleteMood(), and updateMood()
  //
  // getMoods() should:
  //   - Query all rows from mood_entries, ordered by created_at DESC
  //   - Return List<Map<String, dynamic>>
  //
  // deleteMood(String id) should:
  //   - Delete the row where id matches
  //   - Use db.delete() with a where clause
  //
  // updateMood(String id, Map<String, dynamic> mood) should:
  //   - Update the row where id matches
  //   - Use db.update() with a where clause
  //
  // Hint for getMoods():
  //   return await db.query('mood_entries', orderBy: 'created_at DESC');
  //
  // Hint for deleteMood():
  //   await db.delete('mood_entries', where: 'id = ?', whereArgs: [id]);
  // ===========================================================================

  // TODO 4: Uncomment and complete:
  //
  // Future<List<Map<String, dynamic>>> getMoods() async {
  //   final db = await database;
  //   // Query all mood entries ordered by created_at DESC
  //   return [];
  // }
  //
  // Future<void> deleteMood(String id) async {
  //   final db = await database;
  //   // Delete the entry with the given id
  // }
  //
  // Future<void> updateMood(String id, Map<String, dynamic> mood) async {
  //   final db = await database;
  //   // Update the entry with the given id
  // }
}
