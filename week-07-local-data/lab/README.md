# Week 7 Lab: Local Data with SQLite

> **Course:** Mobile Apps for Healthcare
> **Duration:** ~2 hours
> **Prerequisites:** Week 6 State Management (working Mood Tracker with Riverpod)

---

## Learning Objectives

By the end of this lab you will be able to:

1. Explain why local data persistence is essential for mobile health applications.
2. Implement `toMap()` and `fromMap()` methods to serialize Dart objects for SQLite storage.
3. Create and initialize a SQLite database using `sqflite`, including writing `CREATE TABLE` statements.
4. Implement CRUD operations (insert, select, update, delete) through the `sqflite` API.
5. Apply the repository pattern to abstract database access from business logic.
6. Integrate a persistence layer with an existing Riverpod state management setup.
7. Load persisted data asynchronously on app startup using `ConsumerStatefulWidget` and `initState`.

---

## Prerequisites

Before you begin, make sure you have the following ready:

- **Flutter SDK** installed and on your PATH. Verify by running:
  ```bash
  flutter doctor
  ```
  All checks should pass (or show only minor warnings unrelated to your target platform).
- **An IDE** with Flutter support (VS Code recommended, or Android Studio).
- **A running device** -- emulator, simulator, or physical device.
- **The starter project** loaded in your IDE:
  ```
  week-07-local-data/lab/starter/mood_tracker/
  ```
  Open this folder and run `flutter pub get` to resolve dependencies. Verify the app builds and launches before starting the exercises.

> **Tip:** If the starter project does not compile, check that `sqflite`, `path`, `flutter_riverpod`, and `uuid` appear in `pubspec.yaml` and that `flutter pub get` completed without errors. Ask the instructor for help if needed.

---

## About the Starter Project

You are continuing the **Mood Tracker** app from Week 6. The starter project is the finished Week 6 code (Riverpod state management working) plus new stub files and TODOs for persistence. It already provides:

- A working Riverpod setup with `ProviderScope`, `MoodNotifier`, and reactive UI
- Four screens: Home, Add Mood, Mood Detail, and Statistics
- Reusable widgets: `MoodCard` and `MoodScoreIndicator`

The app currently stores mood entries **only in memory** -- they are lost every time the app restarts. Your job in this lab is to add **SQLite persistence** so that mood data survives app restarts by completing 7 TODOs across 5 files.

### Project structure

| File | Purpose |
|------|---------|
| `lib/models/mood_entry.dart` | TODO 1: SQLite serialization (toMap/fromMap) |
| `lib/data/database_helper.dart` | TODOs 2--4: SQLite database operations |
| `lib/data/mood_repository.dart` | TODO 5: Repository pattern |
| `lib/providers/mood_provider.dart` | TODO 6: Persistence-aware state management |
| `lib/screens/home_screen.dart` | TODO 7: Load data on startup |
| `lib/screens/` | Screens from Week 6 (no changes needed) |
| `lib/widgets/` | Reusable UI components (no changes needed) |

---

> **Healthcare Context: Why Data Persistence Matters in mHealth**
>
> In real mobile health applications, persistent local storage is not optional. Consider:
> - **Patient mood data MUST persist between sessions.** A patient who logs their mood in the morning expects that entry to still be there in the evening. Losing entries erodes trust and makes the app clinically useless.
> - **Clinical trials depend on reliable data collection.** If a research study uses your app to gather mood data over 8 weeks, a single lost session of data can compromise the entire dataset.
> - **Lost data means lost clinical insights.** Patterns in mood over time are only visible if every entry is reliably stored. Gaps in the data lead to incorrect conclusions.
> - **HIPAA requires data integrity.** The Health Insurance Portability and Accountability Act mandates that electronic health information be accurately preserved and retrievable. Your persistence layer is the foundation of that guarantee.
>
> The patterns you learn today -- SQLite storage, the repository pattern, and async initialization -- are the same patterns used in production mHealth apps to ensure reliable local data storage.

---

## Part 1: Understanding Local Data Persistence (~15 min)

### 1.1 The problem with in-memory state

In Week 6, you implemented Riverpod state management. The `MoodNotifier` holds a `List<MoodEntry>` in memory. This works perfectly for a single session, but has a critical limitation:

- **Data is lost on restart.** Close the app and reopen it -- all mood entries are gone.
- **No offline support.** Without local storage, the app is useless without a network connection (and you have not added networking yet).
- **No data history.** Patients cannot review past entries because they simply do not exist after a restart.

### 1.2 What is SQLite?

SQLite is a lightweight, file-based relational database that runs directly on the device:

| Property | Description |
|----------|------------|
| **Embedded** | Runs inside your app process -- no separate server needed. |
| **File-based** | The entire database is a single file on the device's filesystem. |
| **SQL-compatible** | Supports standard SQL for creating tables, inserting, querying, updating, and deleting data. |
| **Cross-platform** | Works on Android, iOS, macOS, Windows, and Linux. |

### 1.3 The sqflite package

Flutter does not include SQLite support out of the box. The `sqflite` package provides a Dart API for SQLite:

| Class/Method | What it does |
|-------------|-------------|
| `openDatabase()` | Opens (or creates) a database file and returns a `Database` instance. |
| `db.execute()` | Runs a raw SQL statement (e.g., `CREATE TABLE`). |
| `db.insert()` | Inserts a row from a `Map<String, dynamic>`. |
| `db.query()` | Queries a table and returns a `List<Map<String, dynamic>>`. |
| `db.update()` | Updates rows matching a `WHERE` clause. |
| `db.delete()` | Deletes rows matching a `WHERE` clause. |

### 1.4 The repository pattern

The repository pattern places an abstraction layer between your data source (SQLite) and your business logic (Riverpod notifier):

```
UI (Screens)
  --> StateNotifier (business logic)
    --> Repository (abstraction layer)
      --> DatabaseHelper (SQLite operations)
        --> SQLite file on disk
```

This separation means your `MoodNotifier` never touches SQL directly. If you later switch from SQLite to a REST API or Hive or another storage solution, you only change the repository implementation -- the notifier and UI remain untouched.

---

### Self-Check: Part 1

Before continuing, make sure you can answer these questions:

- [ ] Why is in-memory state insufficient for a health tracking app?
- [ ] What is SQLite and why is it a good fit for mobile apps?
- [ ] What role does the repository pattern play between the database and the state notifier?

---

## Part 2: Data Serialization (~15 min)

SQLite stores data in rows and columns, not Dart objects. You need to convert between the two representations.

### 2.1 TODO 1: Implement toMap() and fromMap()

Open `lib/models/mood_entry.dart`. Find the `TODO 1` comment block.

You need to implement two methods:

1. **`toMap()`** -- Converts a `MoodEntry` instance to a `Map<String, dynamic>` for SQLite insertion:
   ```dart
   Map<String, dynamic> toMap() {
     return {
       'id': id,
       'score': score,
       'note': note,
       'createdAt': createdAt.toIso8601String(),
     };
   }
   ```

2. **`factory MoodEntry.fromMap(Map<String, dynamic> map)`** -- Creates a `MoodEntry` from a database row:
   ```dart
   factory MoodEntry.fromMap(Map<String, dynamic> map) {
     return MoodEntry(
       id: map['id'] as String,
       score: map['score'] as int,
       note: map['note'] as String?,
       createdAt: DateTime.parse(map['createdAt'] as String),
     );
   }
   ```

> **Key insight:** `DateTime` cannot be stored directly in SQLite. You must serialize it to an ISO 8601 string (`toIso8601String()`) and parse it back (`DateTime.parse()`). This is a common pattern for date/time fields in database-backed apps.

---

### Self-Check: Part 2

- [ ] `toMap()` returns a map with keys matching the database column names.
- [ ] `fromMap()` correctly parses each field, including `DateTime` from a string.
- [ ] You understand why serialization is necessary for SQLite storage.

---

## Part 3: Database Setup and CRUD Operations (~30 min)

Open `lib/data/database_helper.dart`. This file contains the `DatabaseHelper` class that manages all direct SQLite interactions.

### 3.1 TODO 2: Initialize the database

Find the `TODO 2` comment block. Your task is to implement `_initDatabase()` and `_onCreate()`.

1. **`_initDatabase()`** -- Get the database path and open the database:
   ```dart
   Future<Database> _initDatabase() async {
     final dbPath = await getDatabasesPath();
     final path = join(dbPath, 'mood_tracker.db');
     return await openDatabase(
       path,
       version: 1,
       onCreate: _onCreate,
     );
   }
   ```

2. **`_onCreate()`** -- Create the moods table:
   ```dart
   Future<void> _onCreate(Database db, int version) async {
     await db.execute('''
       CREATE TABLE moods(
         id TEXT PRIMARY KEY,
         score INTEGER NOT NULL,
         note TEXT,
         createdAt TEXT NOT NULL
       )
     ''');
   }
   ```

> **Singleton pattern:** Notice that `DatabaseHelper` uses a private constructor and a static `instance` getter. This ensures only one instance of the helper (and one database connection) exists throughout the app. Multiple simultaneous connections to the same SQLite file can cause corruption.

### 3.2 TODO 3: Implement insertMood()

Find the `TODO 3` comment block. Implement the method to insert a mood entry:

```dart
Future<void> insertMood(MoodEntry mood) async {
  final db = await database;
  await db.insert(
    'moods',
    mood.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}
```

The `conflictAlgorithm: ConflictAlgorithm.replace` ensures that if an entry with the same `id` already exists, it is overwritten rather than causing an error.

### 3.3 TODO 4: Implement getMoods(), deleteMood(), and updateMood()

Find the `TODO 4` comment block. Implement the remaining three CRUD operations:

1. **`getMoods()`** -- Query all moods, ordered by creation date (newest first):
   ```dart
   Future<List<MoodEntry>> getMoods() async {
     final db = await database;
     final maps = await db.query('moods', orderBy: 'createdAt DESC');
     return maps.map((map) => MoodEntry.fromMap(map)).toList();
   }
   ```

2. **`deleteMood(String id)`** -- Delete a single mood by id:
   ```dart
   Future<void> deleteMood(String id) async {
     final db = await database;
     await db.delete('moods', where: 'id = ?', whereArgs: [id]);
   }
   ```

3. **`updateMood(MoodEntry mood)`** -- Update an existing mood entry:
   ```dart
   Future<void> updateMood(MoodEntry mood) async {
     final db = await database;
     await db.update(
       'moods',
       mood.toMap(),
       where: 'id = ?',
       whereArgs: [mood.id],
     );
   }
   ```

> **Parameterized queries:** Notice the `where: 'id = ?', whereArgs: [id]` pattern. The `?` is a placeholder that `sqflite` fills in with the value from `whereArgs`. This prevents SQL injection attacks -- never concatenate user input directly into SQL strings.

---

### Self-Check: Part 3

- [ ] `_initDatabase()` creates a database file called `mood_tracker.db`.
- [ ] `_onCreate()` runs a `CREATE TABLE` statement with the correct column types.
- [ ] `insertMood()` converts the entry to a map and inserts it.
- [ ] `getMoods()` returns entries sorted by `createdAt DESC`.
- [ ] `deleteMood()` and `updateMood()` use parameterized queries with `whereArgs`.

---

## Part 4: Repository Pattern (~15 min)

### 4.1 TODO 5: Implement the MoodRepository

Open `lib/data/mood_repository.dart`. Find the `TODO 5` comment block.

The repository acts as a clean interface between the database layer and the state management layer. Implement the four methods:

1. **`getAllMoods()`** -- Delegates to `DatabaseHelper`:
   ```dart
   Future<List<MoodEntry>> getAllMoods() async {
     return await DatabaseHelper.instance.getMoods();
   }
   ```

2. **`addMood(MoodEntry mood)`** -- Inserts via the helper:
   ```dart
   Future<void> addMood(MoodEntry mood) async {
     await DatabaseHelper.instance.insertMood(mood);
   }
   ```

3. **`deleteMood(String id)`** -- Deletes via the helper:
   ```dart
   Future<void> deleteMood(String id) async {
     await DatabaseHelper.instance.deleteMood(id);
   }
   ```

4. **`updateMood(MoodEntry mood)`** -- Updates via the helper:
   ```dart
   Future<void> updateMood(MoodEntry mood) async {
     await DatabaseHelper.instance.updateMood(mood);
   }
   ```

> **Why not call DatabaseHelper directly from the notifier?** The repository provides a stable interface. Today it delegates to SQLite. Tomorrow you might add caching, logging, data validation, or switch to a different storage backend. The notifier does not need to know or care about these implementation details.

---

### Self-Check: Part 4

- [ ] All four repository methods delegate to `DatabaseHelper.instance`.
- [ ] The repository does not contain SQL or direct database references -- it only calls helper methods.
- [ ] You can explain why the repository layer exists between the notifier and the database.

---

## Part 5: Integrating Persistence with State Management (~20 min)

### 5.1 TODO 6: Update MoodNotifier to use the repository

Open `lib/providers/mood_provider.dart`. Find the `TODO 6` comment block.

The `MoodNotifier` already has `addMood`, `deleteMood`, and `updateMood` methods from Week 6. Now you need to make them persist data through the repository. You also need to add a new `loadMoods()` method.

Make these changes:

1. **`loadMoods()`** -- Fetch all moods from the repository and update state:
   ```dart
   Future<void> loadMoods() async {
     final moods = await _repository.getAllMoods();
     state = moods;
   }
   ```

2. **`addMood(int score, String? note)`** -- After creating the entry and updating state, persist it:
   ```dart
   void addMood(int score, String? note) {
     final entry = MoodEntry(
       id: const Uuid().v4(),
       score: score,
       note: note,
       createdAt: DateTime.now(),
     );
     state = [entry, ...state];
     _repository.addMood(entry);
   }
   ```

3. **`deleteMood(String id)`** -- After updating state, delete from storage:
   ```dart
   void deleteMood(String id) {
     state = state.where((e) => e.id != id).toList();
     _repository.deleteMood(id);
   }
   ```

4. **`updateMood(String id, int score, String? note)`** -- After updating state, persist the change:
   ```dart
   void updateMood(String id, int score, String? note) {
     state = state.map((e) =>
       e.id == id ? e.copyWith(score: score, note: note) : e
     ).toList();
     final updated = state.firstWhere((e) => e.id == id);
     _repository.updateMood(updated);
   }
   ```

> **State-first, persist-second:** Notice that each method updates the in-memory state immediately and then calls the repository. This keeps the UI responsive -- the user sees the change instantly while the database write happens in the background. This is sometimes called an "optimistic update" pattern.

---

### Self-Check: Part 5

- [ ] `loadMoods()` fetches from the repository and assigns the result to `state`.
- [ ] `addMood()`, `deleteMood()`, and `updateMood()` all update `state` first, then call the repository.
- [ ] The notifier no longer starts with hardcoded sample data -- it starts with an empty list.
- [ ] You understand why state is updated before the database write.

---

## Part 6: Loading Data on Startup (~15 min)

### 6.1 TODO 7: Load persisted moods when the app starts

Open `lib/screens/home_screen.dart`. Find the `TODO 7` comment block.

The home screen is currently a `ConsumerWidget` (from Week 6). You need to change it to a `ConsumerStatefulWidget` so that you can use `initState()` to trigger data loading on startup.

Make these changes:

1. **Change `ConsumerWidget` to `ConsumerStatefulWidget`.**
2. **Change the `build` method** to live inside a `ConsumerState<HomeScreen>` class.
3. **Override `initState()`** to load moods from the database:
   ```dart
   @override
   void initState() {
     super.initState();
     Future.microtask(() {
       ref.read(moodProvider.notifier).loadMoods();
     });
   }
   ```

> **Why `Future.microtask()`?** The `ref` object is not safe to use during `initState()` in all cases. Wrapping the call in `Future.microtask()` defers it to the next microtask, after the widget is fully mounted. This avoids potential initialization errors.

Run the app. The home screen should start empty (no hardcoded data). Add a few mood entries, then fully close and reopen the app. Your entries should still be there -- they are now stored in SQLite.

---

### Self-Check: Part 6

- [ ] HomeScreen is now a `ConsumerStatefulWidget` with `ConsumerState`.
- [ ] `initState()` calls `loadMoods()` via `Future.microtask()`.
- [ ] Data persists across app restarts.

---

## Part 7: Self-Check and Summary (~10 min)

### 7.1 End-to-end verification

Walk through this complete flow to verify everything works:

1. Launch the app. The home screen should be empty (first launch) or show previously saved entries.
2. Tap the **+** button. Set a score, type a note, and tap **Save Entry**.
3. Verify the new entry appears at the top of the home screen list.
4. Tap the **bar chart** icon to view statistics. Verify the numbers reflect the stored entries.
5. **Fully close the app** (remove it from the recent apps list).
6. **Reopen the app.** Verify that all previously added entries are still present.
7. Tap a mood entry to view its details. Tap the **delete** icon, confirm deletion.
8. Verify the entry is gone from the home screen and the statistics have updated.
9. Close and reopen the app once more. Verify the deleted entry is still gone.

If all 9 steps work correctly, you have completed the lab.

### 7.2 Summary

| TODO | File | What you did |
|------|------|-------------|
| 1 | `models/mood_entry.dart` | Implemented `toMap()` and `fromMap()` to serialize `MoodEntry` for SQLite storage. |
| 2 | `data/database_helper.dart` | Implemented `_initDatabase()` and `_onCreate()` with `CREATE TABLE` statement. |
| 3 | `data/database_helper.dart` | Implemented `insertMood()` using `db.insert()` with conflict resolution. |
| 4 | `data/database_helper.dart` | Implemented `getMoods()`, `deleteMood()`, and `updateMood()` with parameterized queries. |
| 5 | `data/mood_repository.dart` | Implemented the repository pattern, delegating all operations to `DatabaseHelper`. |
| 6 | `providers/mood_provider.dart` | Updated `MoodNotifier` methods to call the repository and added `loadMoods()`. |
| 7 | `screens/home_screen.dart` | Changed to `ConsumerStatefulWidget` with `initState()` calling `loadMoods()`. |

### 7.3 Key concepts learned

| Concept | Key Takeaway |
|---------|--------------|
| SQLite | A lightweight, embedded relational database ideal for local storage on mobile devices. |
| Data serialization | `toMap()` and `fromMap()` convert between Dart objects and SQLite-compatible maps. |
| SQL DDL | `CREATE TABLE` defines the schema; column types include `TEXT`, `INTEGER`, and `PRIMARY KEY`. |
| CRUD operations | `insert()`, `query()`, `update()`, `delete()` -- the four fundamental database operations. |
| Singleton pattern | Ensures a single database connection shared across the entire app. |
| Repository pattern | An abstraction layer between data storage and business logic, enabling easy replacement of the data source. |
| Async initialization | Databases open asynchronously; `initState()` with `Future.microtask()` handles startup loading. |
| Parameterized queries | Using `?` placeholders and `whereArgs` prevents SQL injection and ensures safe queries. |
| Optimistic updates | Updating in-memory state before writing to disk keeps the UI responsive. |

---

## What Comes Next

In the following weeks, you will continue extending this Mood Tracker app:

- **Week 8:** Networking and API integration -- the app syncs mood data with a remote server.
- **Week 9:** Polish, testing, and final features.

The SQLite persistence layer you built today ensures that patient data is never lost, even when the device is offline. In Week 8, you will add server synchronization on top of this local storage foundation.

---

## Further Reading

- [sqflite package on pub.dev](https://pub.dev/packages/sqflite)
- [SQLite official documentation](https://www.sqlite.org/docs.html)
- [Flutter cookbook: Persist data with SQLite](https://docs.flutter.dev/cookbook/persistence/sqlite)
- [Repository pattern explained](https://developer.android.com/topic/architecture/data-layer)
- [path package on pub.dev](https://pub.dev/packages/path)
