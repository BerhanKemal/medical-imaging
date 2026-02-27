# Week 7 Lab: Instructor Guide

**Course:** Mobile Apps for Healthcare
**Lab Duration:** 2 hours
**Topic:** Local Data with SQLite
**Audience:** 3rd-year Biomedical Engineering students -- familiar with Flutter widgets, Riverpod state management from Weeks 4--6

> This document is for the **instructor only**. Students use the separate `README.md` workbook.

---

## Pre-Lab Checklist

Complete these **before students arrive**:

- [ ] Verify Flutter is installed on all lab machines (`flutter doctor`)
- [ ] Verify `sqlite3` is available on all lab machines (`sqlite3 --version`). On Windows, this may need to be installed via `winget install SQLite.SQLite` or downloaded from [sqlite.org](https://www.sqlite.org/download.html) and added to PATH.
- [ ] (Optional but recommended) Install [DB Browser for SQLite](https://sqlitebrowser.org/) on the instructor machine for Part 0.5 demo
- [ ] Open the **starter** project in an IDE and run `flutter pub get` -- confirm all dependencies resolve
- [ ] Build and launch the starter app on an emulator/simulator -- confirm it compiles and runs (it should show an empty mood list since the MoodNotifier starts with `super([])`)
- [ ] Open the **finished** project and confirm it builds and runs correctly -- add a mood entry, fully close and reopen the app, and verify data persists across restarts (this is your reference)
- [ ] Verify `sqflite` and `path` packages are present in `pubspec.yaml`
- [ ] Open the student workbook (`README.md`) on the projector
- [ ] Have the starter project open in a second IDE window for live coding demos
- [ ] Increase IDE/terminal font size to at least 18pt for projector readability
- [ ] Have a browser tab open to the [sqflite package docs](https://pub.dev/packages/sqflite) for quick reference

### Room Setup

- Projector showing your IDE with the starter project open
- A terminal window ready for the sqlite3 demo (Part 0)
- Students should have the starter project loaded and running before you begin
- If students do not have the starter project, they can clone or copy it from the course repository

### If Dependencies Fail to Resolve

If `flutter pub get` fails:

1. Check internet connectivity (pub.dev must be reachable)
2. Try `flutter pub cache repair`
3. If the lab network is slow, have a pre-resolved project on USB drives (copy the entire project including `.dart_tool/` and `.packages`)
4. As a last resort, the `pubspec.lock` file in the starter project should work -- delete it and re-run `flutter pub get`

---

## Timing Overview

| Time | Duration | Activity | Type |
|------|----------|----------|------|
| 0:00--0:05 | 5 min | Welcome, context setting, verify setup | Instructor talk |
| 0:05--0:25 | 20 min | Part 0: Hands-on SQL Console | Demo + student follow-along |
| 0:25--0:35 | 10 min | Part 1: Understanding Local Data Persistence | Instructor talk + discussion |
| 0:35--0:47 | 12 min | Part 2: Data Serialization (TODO 1) | Live coding + student work |
| 0:47--0:50 | 3 min | Break / catch-up buffer | --- |
| 0:50--1:15 | 25 min | Part 3: Database Setup and CRUD (TODOs 2--4) | Live coding + student work |
| 1:15--1:27 | 12 min | Part 4: Repository Pattern (TODO 5) | Live coding + student work |
| 1:27--1:30 | 3 min | Break / catch-up buffer | --- |
| 1:30--1:45 | 15 min | Part 5: Integrating Persistence with State (TODO 6) | Live coding + student work |
| 1:45--2:00 | 15 min | Part 6: Loading Data on Startup (TODO 7) + Wrap-up | Follow-along + verification |

**Total:** 120 minutes (2 hours)

> **Pacing note:** Part 0 (SQL Console) significantly reduces friction in Parts 3--4 because students will already recognize the SQL syntax. TODOs 2--4 are all in the same file (`database_helper.dart`) and are the core of the lab. If students struggle there, use the first buffer. TODOs 5--6 follow logically from the database layer. TODO 7 is small but conceptually important -- it introduces `ConsumerStatefulWidget` and `initState` for async loading.

---

## Detailed Facilitation Guide

### 0:00--0:05 --- Welcome & Context Setting (5 min)

**Type:** Instructor talk

**What to say (talking points, not a script):**

- "Last week you built a Mood Tracker with Riverpod state management. The app works perfectly during a single session, but try this: close the app completely, reopen it, and... all your mood entries are gone."
- "In healthcare, losing patient data is not just an inconvenience -- it is a regulatory violation and a clinical risk."
- "Today we fix this. First, we will spend 20 minutes learning SQL in a terminal -- no Flutter, no Dart, just you and a database. Then you will add SQLite persistence to the Mood Tracker through 7 TODOs across 5 files."
- "By the end of today, you will close the app, reopen it, and your mood entries will still be there."

**What students should be doing:**

- Opening the starter project in their IDE
- Running `flutter pub get`
- Opening a terminal window (for Part 0)

**Checkpoint:** Before moving on, verify that **every student has a terminal open** and can run `sqlite3 --version` successfully. On Windows, if sqlite3 is not in PATH, help students download it or point them to the instructor demo.

---

### 0:05--0:25 --- Part 0: Hands-on SQL Console (20 min)

**Type:** Instructor demo on projector + students type along

**Goal:** Students experience SQL independently from Flutter. By the end, they will have created a table, inserted data, run queries, updated, and deleted rows -- all in a terminal. This establishes SQL fluency before wrapping it in Dart.

#### Setup (2 min)

**Demo on projector.** Open a terminal and run:

```bash
sqlite3 mood_practice.db
```

**Say:** "This command created a file called `mood_practice.db`. That file IS the database. No server, no configuration, no Docker containers, no passwords. This is what makes SQLite perfect for mobile apps -- your Flutter app will create a file just like this one."

Configure readable output:

```sql
.mode column
.headers on
```

**Say:** "These are sqlite3 shell commands (they start with a dot). They make the output look like a table instead of raw text."

#### Create Table + Insert Data (5 min)

**Demo on projector.** Type the CREATE TABLE statement:

```sql
CREATE TABLE mood_entries (
  id TEXT PRIMARY KEY,
  score INTEGER NOT NULL,
  note TEXT,
  created_at TEXT NOT NULL
);
```

**Explain while typing:**
- "This is the same table schema you will use in the Flutter lab."
- "`id TEXT PRIMARY KEY` -- every row needs a unique identifier."
- "`score INTEGER NOT NULL` -- cannot be null, every mood entry must have a score."
- "`note TEXT` -- nullable, the patient might not write a note."
- "`created_at TEXT NOT NULL` -- dates stored as text in ISO 8601 format because SQLite has no native date type."

**Verify:** Run `.tables` and `.schema mood_entries`.

**Insert the sample data.** Type (or paste) the six INSERT statements from the README. Have students type along.

**Say:** "Notice the INSERT syntax: table name, column list, then VALUES. The `NULL` for entry-4's note means no note was written."

**Windows troubleshooting:** If a student's terminal does not recognize `sqlite3`, they can:
1. Download `sqlite-tools-win-x64` from sqlite.org/download.html
2. Extract to a folder (e.g., `C:\sqlite`)
3. Run `C:\sqlite\sqlite3.exe mood_practice.db`
4. Or simply follow along on the projector

#### Query the Data (7 min)

**Demo each query on the projector.** Pause after each for students to type it:

1. `SELECT * FROM mood_entries;` -- "See everything."
2. `SELECT * FROM mood_entries ORDER BY created_at DESC;` -- "Newest first. This is exactly what your Flutter `getMoods()` will do."
3. `SELECT * FROM mood_entries WHERE score >= 4;` -- "Filtering. Only happy moods."
4. `SELECT * FROM mood_entries WHERE note IS NOT NULL;` -- "NULL handling. In SQL, you use `IS NOT NULL`, not `!= NULL`."
5. `SELECT COUNT(*) as total_entries FROM mood_entries;` -- "How many rows total?"
6. `SELECT AVG(score) as average_score FROM mood_entries;` -- "Average mood score."
7. `SELECT score, COUNT(*) as count FROM mood_entries GROUP BY score;` -- "How many entries for each score?"

**Say after GROUP BY:** "This is like doing a Python `Counter()` or grouping a list by a key. SQL does it in one line."

**Challenge query:** `SELECT MAX(score) as highest, MIN(score) as lowest FROM mood_entries;` -- "For students who finished early."

#### Update and Delete (3 min)

**Demo on projector:**

```sql
UPDATE mood_entries SET score = 3, note = 'Exam went OK actually' WHERE id = 'entry-3';
SELECT * FROM mood_entries WHERE id = 'entry-3';
```

**Say:** "Always use WHERE with UPDATE. Without it, you change every row. Same for DELETE."

```sql
DELETE FROM mood_entries WHERE id = 'entry-5';
SELECT COUNT(*) FROM mood_entries;
```

#### (Optional) DB Browser Demo (2 min)

If DB Browser for SQLite is installed on the instructor machine, open `mood_practice.db` in it. Show the "Browse Data" tab. **Say:** "Same data, visual representation. Useful for debugging when your Flutter app's database seems wrong."

#### Bridge to Flutter (1 min)

**Show the mapping table** from the README (terminal command → sqflite equivalent). **Say:** "The SQL is identical. The delivery mechanism is different. Every query you just wrote will appear inside a Dart string in the Flutter app."

**Have students exit sqlite3:** `.quit`

**Checkpoint:** "Raise your hand if you successfully queried data in the terminal. Great -- you now know SQL. The rest of the lab is wrapping these same operations in Dart."

---

### 0:25--0:35 --- Part 1: Understanding Local Data Persistence (10 min)

**Type:** Instructor talk + discussion

**Note:** This section is shorter than the original because Part 0 already established SQL context and the concept of SQLite as a file-based database. Focus on the architecture layers rather than explaining what SQL is.

**Demo on projector:**

Open the starter project and walk through the problem:

1. Open `mood_provider.dart`. Point to `MoodNotifier(this._repository) : super([])`. Say: "The notifier starts with an empty list. In Week 6, it started with sample data. Now we need to load real data from a database."
2. Open `database_helper.dart`. Point to the placeholder `_initDatabase()`. Say: "This placeholder lets the app compile, but it creates a database without any tables. The `onCreate` callback is missing."
3. Open `mood_repository.dart`. Point to the commented-out method stubs. Say: "The repository is the bridge between the database and the notifier. Right now it does nothing."

**Draw on the whiteboard:**

```
        HomeScreen (UI)
            |
        MoodNotifier (state management)
            |
        MoodRepository (abstraction)
            |
        DatabaseHelper (SQLite operations)
            |
        mood_tracker.db (file on device)
```

**Talking point:** "You just created `mood_practice.db` in the terminal. The Flutter app will create `mood_tracker.db` in the same way -- a single file on the device's filesystem."

**Discussion question:** "In a real mHealth app, what are the consequences if local data is lost between sessions?" Expected answers: patients lose trust, clinical data is incomplete, regulatory compliance issues (HIPAA), research datasets have gaps, treatment decisions based on incomplete information.

---

### 0:35--0:47 --- Part 2: Data Serialization -- TODO 1 (12 min)

**Type:** Live coding (first half) + student work (second half)

#### 0:35--0:40 --- Live Demo of TODO 1 (5 min)

**Demo on projector.** Open `lib/models/mood_entry.dart`. Walk through the existing class:

1. Point to the fields: `id`, `score`, `note`, `createdAt`. Say: "SQLite stores data in rows and columns, not Dart objects. We need methods to convert between the two representations."
2. Point to the `copyWith` method. Say: "This was from Week 6. Now we add two more methods: `toMap()` to convert a MoodEntry to a database-compatible map, and `fromMap()` to convert back."
3. Write the methods live:

```dart
Map<String, dynamic> toMap() {
  return {
    'id': id,
    'score': score,
    'note': note,
    'created_at': createdAt.toIso8601String(),
  };
}

factory MoodEntry.fromMap(Map<String, dynamic> map) {
  return MoodEntry(
    id: map['id'] as String,
    score: map['score'] as int,
    note: map['note'] as String?,
    createdAt: DateTime.parse(map['created_at'] as String),
  );
}
```

**Pause after `toMap()`.** Explain:

- "The map keys are the column names in our SQLite table. They use `snake_case` because that is the SQL convention."
- "`createdAt.toIso8601String()` converts the DateTime to a string like `2026-02-22T14:30:00.000`. SQLite has no native DateTime type, so we store it as text."
- "`note` can be `null` -- that is fine, SQLite allows NULL values in TEXT columns."

**Pause after `fromMap()`.** Explain:

- "This is a factory constructor -- it creates a new MoodEntry from database row data."
- "`map['score'] as int` -- we cast because the map values are `dynamic`."
- "`DateTime.parse()` reverses the ISO 8601 string back to a DateTime object."
- "The `note` field uses `as String?` because it may be null in the database."

#### 0:40--0:47 --- Student Work (7 min)

**Say:** "Now complete TODO 1 in your own project. Uncomment the method scaffolds and fill them in. You have 7 minutes. The hints in the TODO comment tell you exactly what to do."

**Walk around the room.** This should be straightforward for most students.

**Common pitfall:** Students who use `'createdAt'` instead of `'created_at'` as the map key. Emphasize: the map keys must match the database column names, and the column names use snake_case. This mismatch will cause silent failures later (null values when reading from the database).

**Checkpoint:** "Raise your hand if TODO 1 is done. The app will still compile and run -- but we cannot test serialization yet because there is no database to write to."

---

### 0:47--0:50 --- Break / Catch-Up Buffer (3 min)

- Students who finished TODO 1: take a real break
- Students who are behind: use this time to finish
- Walk around and verify everyone has `toMap()` and `fromMap()` implemented
- If many students are stuck, show the TODO 1 solution on the projector

---

### 0:50--1:15 --- Part 3: Database Setup and CRUD -- TODOs 2--4 (25 min)

**Type:** Live coding + student work

**This is the core of the lab.** Students are writing SQL and using the `sqflite` API for the first time in Dart. All three TODOs are in `database_helper.dart`. However, students who completed Part 0 will find the SQL syntax familiar -- the focus here should be on the sqflite API wrapper, not the SQL itself.

#### 0:50--0:58 --- Live Demo of TODO 2 (8 min)

**Demo on projector.** Open `lib/data/database_helper.dart`. Walk through the existing code:

1. Point to the singleton pattern: `static final DatabaseHelper instance = DatabaseHelper._init()`. Say: "Only one instance of DatabaseHelper exists. This ensures one database connection for the entire app -- multiple connections to the same SQLite file can cause corruption."
2. Point to the `database` getter. Say: "This is lazy initialization. The database is created only when first accessed."
3. Point to the placeholder `_initDatabase()`. Say: "This placeholder opens the database but does NOT create any tables. We need to replace it."

**Important:** Say: "You need to DELETE this placeholder `_initDatabase()` method and replace it with the real version. If you leave both, you will get a compilation error about duplicate method definitions."

Write the replacement live:

```dart
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
```

**Pause after `_initDatabase()`.** Explain:

- "`getDatabasesPath()` returns the platform-specific directory for databases (e.g., `/data/data/com.example.app/databases/` on Android)"
- "`join()` from the `path` package safely concatenates the directory and filename"
- "`openDatabase()` opens the file if it exists, or creates it if it does not"
- "`onCreate` is called only once -- when the database file is first created. It is NOT called on subsequent app launches."

**Pause after `_onCreate()`.** Explain:

- "This is exactly the same `CREATE TABLE` you typed in the sqlite3 console 30 minutes ago."
- "The column names here MUST match the keys in `toMap()`. If `toMap()` uses `'created_at'`, the column must be `created_at`."

**Have every student delete the placeholder `_initDatabase()` and write the replacement.**

#### 0:58--1:03 --- Live Demo of TODO 3 (5 min)

**Demo on projector.** Stay in `database_helper.dart`. Write `insertMood()`:

```dart
Future<void> insertMood(MoodEntry mood) async {
  final db = await database;
  await db.insert(
    'mood_entries',
    mood.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}
```

**Explain:**

- "`await database` -- this triggers the lazy initialization. The first call opens (or creates) the database."
- "`db.insert()` takes the table name and a map of column-value pairs"
- "The map comes from `MoodEntry.toMap()` -- that is why the keys must match the column names"
- "`ConflictAlgorithm.replace` -- if an entry with the same `id` already exists, replace it. This prevents duplicate key errors and doubles as an upsert."

**Have students implement TODO 3.**

#### 1:03--1:15 --- Student Work on TODO 4 (12 min)

**Say:** "Now implement TODO 4 -- three more database methods: `getMoods()`, `deleteMood()`, and `updateMood()`. The TODO comments have hints. You have 12 minutes."

**Say:** "Remember the queries you typed in the sqlite3 console -- `SELECT * ... ORDER BY`, `DELETE ... WHERE`, `UPDATE ... WHERE`. The sqflite methods do the same thing, just with Dart method calls instead of raw SQL strings."

**Walk around the room.** This is where students practice the `sqflite` API.

**Key points to mention before they start:**

- `getMoods()` uses `db.query()` which returns a `List<Map<String, dynamic>>`
- `deleteMood()` and `updateMood()` both need `where` and `whereArgs` parameters
- Always use parameterized queries (`'id = ?'` with `whereArgs: [id]`) -- never concatenate user input into SQL strings

#### Complete TODO 4 Solution

```dart
Future<List<MoodEntry>> getMoods() async {
  final db = await database;
  final maps = await db.query('mood_entries', orderBy: 'created_at DESC');
  return maps.map((map) => MoodEntry.fromMap(map)).toList();
}

Future<void> deleteMood(String id) async {
  final db = await database;
  await db.delete('mood_entries', where: 'id = ?', whereArgs: [id]);
}

Future<void> updateMood(MoodEntry mood) async {
  final db = await database;
  await db.update(
    'mood_entries',
    mood.toMap(),
    where: 'id = ?',
    whereArgs: [mood.id],
  );
}
```

**What to watch for:**

- Students who forget `orderBy: 'created_at DESC'` in `getMoods()` -- the list will appear in insertion order instead of newest-first
- Students who write `where: 'id = $id'` instead of using `whereArgs` -- this is a SQL injection vulnerability. Correct them immediately and explain why parameterized queries are essential, especially in healthcare apps handling patient data.
- Students who forget that `updateMood()` takes a `MoodEntry` and needs to call `.toMap()` and use `.id` for the where clause

**Checkpoint:** "All three TODOs in `database_helper.dart` are done? The app should still compile. We cannot test the database yet because nothing calls these methods -- that is the repository's job."

**Common pitfall:** Students who did not delete the placeholder `_initDatabase()`. They will see a compilation error about a duplicate method definition. Have them remove the placeholder (the one without `onCreate`).

> **Healthcare connection:** "In a real mHealth app, the database schema would be more complex -- multiple tables for different data types (medications, vitals, appointments), foreign key relationships, and version migrations. But the pattern is exactly the same."

---

### 1:15--1:27 --- Part 4: Repository Pattern -- TODO 5 (12 min)

**Type:** Live coding (first half) + student work (second half)

#### 1:15--1:20 --- Live Demo of TODO 5 (5 min)

**Demo on projector.** Open `lib/data/mood_repository.dart`. Walk through the existing code:

1. Point to the `_dbHelper` field. Say: "The repository holds a reference to the DatabaseHelper. All database access goes through this reference."
2. Point to the constructor with optional parameter. Say: "This constructor pattern allows dependency injection -- useful for testing. By default, it uses the singleton `DatabaseHelper.instance`."
3. Write the first method live:

```dart
Future<List<MoodEntry>> getAllMoods() async {
  return await DatabaseHelper.instance.getMoods();
}
```

**Explain:**

- "`DatabaseHelper.instance.getMoods()` returns MoodEntry objects from the database"
- "The repository is a thin translation layer between the notifier and the database"

4. Write the remaining methods:

```dart
Future<void> addMood(MoodEntry entry) async {
  await DatabaseHelper.instance.insertMood(entry);
}

Future<void> deleteMood(String id) async {
  await DatabaseHelper.instance.deleteMood(id);
}

Future<void> updateMood(MoodEntry entry) async {
  await DatabaseHelper.instance.updateMood(entry);
}
```

**Talking point:** "Why not call DatabaseHelper directly from the MoodNotifier? Because the repository gives you a clean abstraction boundary. Today it delegates to SQLite. In Week 8, you could add a remote API behind the same interface. The notifier would not need to change at all."

#### 1:20--1:27 --- Student Work (7 min)

**Say:** "Complete TODO 5 now. Uncomment the scaffolds and fill in the four methods. You have 7 minutes."

**Walk around the room.** This is relatively straightforward -- students are mostly wiring up calls between layers.

**Checkpoint:** "TODO 5 is done? The app should still compile. Now we have the full persistence stack: MoodEntry --> toMap/fromMap --> DatabaseHelper --> SQLite, with the Repository bridging the layers."

---

### 1:27--1:30 --- Break / Catch-Up Buffer (3 min)

- Priority: make sure every student has TODOs 1--5 completed
- Students who are ahead can start reading TODO 6 independently
- Walk around and verify everyone has all five TODOs done
- Quick check: "How many of you have TODOs 1 through 5 done? Raise your hand."
- If less than 70% raise their hand, show the TODO 4 or 5 solutions on the projector

---

### 1:30--1:45 --- Part 5: Integrating Persistence with State -- TODO 6 (15 min)

**Type:** Live coding (first half) + student work (second half)

**This is where all the layers connect.** The MoodNotifier will now persist every state change to the database.

#### 1:30--1:38 --- Live Demo of TODO 6 (8 min)

**Demo on projector.** Open `lib/providers/mood_provider.dart`. Walk through the existing code:

1. Point to the existing `addMood()`, `deleteMood()`, `updateMood()` methods. Say: "These are the Week 6 methods. They update in-memory state but do not touch the database. We need to add repository calls."
2. Point to `MoodNotifier(this._repository) : super([])`. Say: "The notifier already receives a MoodRepository. We just need to use it."
3. Say: "We are making two changes: (1) adding a new `loadMoods()` method, and (2) updating the existing three methods to be async and call the repository."

Write the updated class methods live:

```dart
Future<void> loadMoods() async {
  state = await _repository.getAllMoods();
}

Future<void> addMood(int score, String? note) async {
  final newEntry = MoodEntry(score: score, note: note);
  await _repository.addMood(newEntry);
  state = [newEntry, ...state];
}

Future<void> deleteMood(String id) async {
  await _repository.deleteMood(id);
  state = state.where((e) => e.id != id).toList();
}

Future<void> updateMood(String id, int score, String? note) async {
  final updated =
      state.firstWhere((e) => e.id == id).copyWith(score: score, note: note);
  await _repository.updateMood(updated);
  state = state.map((e) => e.id == id ? updated : e).toList();
}
```

**Pause after `loadMoods()`.** Explain:

- "This is a new method. It fetches all moods from the database and replaces the current state."
- "We will call this from the HomeScreen's `initState()` in TODO 7."

**Pause after `addMood()`.** Explain:

- "Two changes from Week 6: (1) it is now `async` with `Future<void>`, (2) it calls `_repository.addMood()` before updating state."
- "We create the MoodEntry first, then save it to the database, then add it to the in-memory list."
- "The `await` ensures the database write completes before we update the UI state. This guarantees data integrity."

**Key teaching point:** "Notice the methods changed from `void` to `Future<void>`. This means they are now asynchronous. The calling code (from the UI) should `await` these calls or handle them appropriately."

#### 1:38--1:45 --- Student Work (7 min)

**Say:** "Delete the existing three methods (addMood, deleteMood, updateMood) and replace them with the async versions that use the repository. Also add the new `loadMoods()` method. You have 7 minutes."

**Walk around the room.** This is where students connect all the pieces.

**Common pitfall:** Students who add the new methods but forget to delete the old ones. They will get compilation errors about duplicate method definitions or conflicting return types (`void` vs `Future<void>`).

**Common pitfall:** Students who forget the `await` before `_repository.addMood()`. The database write will still happen (it returns a Future that eventually completes), but any exceptions will be silently lost.

**Checkpoint:** "TODO 6 is done? The app compiles? Try adding a mood entry -- it should appear on the home screen. But if you close and reopen the app, the list will still be empty. That is because we are not loading data on startup yet. That is TODO 7."

---

### 1:45--2:00 --- Part 6: Loading Data on Startup -- TODO 7 + Wrap-up (15 min)

**Type:** Follow-along (first half) + verification (second half)

#### 1:45--1:50 --- Follow-along for TODO 7 (5 min)

**Demo on projector.** Open `lib/screens/home_screen.dart`:

**Say:** "The home screen is currently a `ConsumerWidget`. We need to change it to a `ConsumerStatefulWidget` so we can use `initState()` to load moods when the screen first appears."

**Walk through the changes step by step:**

**Step 1 -- Change the class declaration:**

```dart
// Before:
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

// After:
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(moodProvider.notifier).loadMoods());
  }

  @override
  Widget build(BuildContext context) {
    final moods = ref.watch(moodProvider);
    // ... rest of build method stays the same
  }
}
```

**Explain the three changes:**

1. "`ConsumerWidget` becomes `ConsumerStatefulWidget` -- this gives us access to `initState()`"
2. "We add a `createState()` method and a new `_HomeScreenState` class (just like StatefulWidget/State, but the Riverpod versions)"
3. "In `initState()`, we call `ref.read(moodProvider.notifier).loadMoods()` wrapped in `Future.microtask()`"

**Explain why `Future.microtask()` is needed:**

- "Riverpod does not allow state modifications during `initState()` directly. `Future.microtask()` defers the call to the next microtask, after the widget is fully mounted."
- "This is the same pattern you will see in Week 9 for checking authentication state on startup."
- "Without `Future.microtask()`, you may get an assertion error from Riverpod about modifying providers during build."

**Also explain the build method change:**

- "In `ConsumerWidget`, the `build` method takes `(BuildContext context, WidgetRef ref)`"
- "In `ConsumerState`, the `build` method takes only `(BuildContext context)` -- `ref` is already available as a property of the state class"

**Have every student make these changes.**

#### 1:50--2:00 --- End-to-End Verification + Summary (10 min)

**Say:** "Hot restart the app. Let us verify the full persistence flow together."

Walk students through the verification steps:

1. Launch the app -- should be empty on first launch (or show previous data if they added entries earlier)
2. Add a mood entry (score 8, note "Testing persistence")
3. Verify it appears on the home screen
4. **Fully close the app** (remove from recent apps, not just minimize)
5. **Reopen the app** -- the entry should still be there
6. Delete the entry from the detail screen
7. Close and reopen the app once more
8. Verify the deleted entry is gone

**Talking points:**

- "You completed 7 TODOs across 5 files. The app now has full local data persistence."
- "The key pattern: data flows through layers. MoodEntry objects at the top, maps in the middle, SQL at the bottom. Each layer has a single responsibility."
- "The repository pattern is the critical abstraction. It shields the notifier from database details."
- "The `ConsumerStatefulWidget` + `initState` pattern is how you trigger async loading when a screen first appears."
- "And remember -- the SQL you wrote in Part 0 is the same SQL running inside your Flutter app. The sqlite3 console is a great debugging tool if your queries are not returning what you expect."

**Preview Week 8:**

- "In Week 8, students will add networking -- the app will connect to a REST API to sync mood data with a remote server."
- "The great thing about our architecture: the UI code does not change at all. You only modify the repository to add API calls alongside (or instead of) the local database calls."

**Final words:**

- "If your app is not fully working, the finished project is available as a reference. Compare it file by file."
- "Practice the layered architecture pattern -- you will use it throughout the rest of this course."

---

## Instructor Notes: Pacing & Common Issues

### Where Students Typically Get Stuck

1. **Placeholder `_initDatabase()` (TODO 2).** Students uncomment the new `_initDatabase()` but forget to delete the placeholder. This causes a duplicate method error. Remind them loudly: "Delete the placeholder before writing the replacement."

2. **Column name mismatch (TODOs 1--2).** If `toMap()` uses `'created_at'` but the `CREATE TABLE` uses `createdAt` (or vice versa), data will silently fail to load. Column names must match map keys exactly. This is the single most common source of "data does not persist" bugs.

3. **Missing `await` in provider methods (TODO 6).** Students who omit `await` before repository calls will not see errors immediately, but data may not be saved before the state update happens. Emphasize: "Always `await` database operations."

4. **ConsumerStatefulWidget syntax (TODO 7).** Students confuse the class hierarchy. Draw the mapping on the board:
   ```
   ConsumerWidget                  -->  ConsumerStatefulWidget
   build(BuildContext, WidgetRef)  -->  build(BuildContext) [ref is a property]
   ```

5. **Forgetting `Future.microtask()` (TODO 7).** Students who call `ref.read(moodProvider.notifier).loadMoods()` directly in `initState()` may see assertion errors. Always wrap in `Future.microtask()`.

### Where to Slow Down

- The `CREATE TABLE` statement in TODO 2. Even though students practiced SQL in Part 0, connecting it to the sqflite API is a new step. Walk through each column, its type, and its constraints.
- The `where: 'id = ?', whereArgs: [id]` pattern in TODO 4. Explain parameterized queries and SQL injection prevention.
- The transition from synchronous (`void`) to asynchronous (`Future<void>`) methods in TODO 6. This is a conceptual shift.

### Where You Can Speed Up

- TODO 1 (toMap/fromMap) -- the pattern is well-documented in the TODO comments, and most students pick it up quickly.
- TODO 5 (repository) -- it is thin delegation. Once students see the first method, the other three follow the same pattern.
- TODO 7 -- it is a small change. Show it once on the projector and have everyone follow along.
- **Part 3 SQL explanations** -- students who completed Part 0 will find SQL syntax familiar. Focus the demo on the sqflite API wrapper, not the SQL itself.

### If You Are Running Out of Time

Priority order (must complete):

1. **TODOs 1--4** -- Serialization and all database operations. This is the foundation.
2. **TODO 5** -- Repository. Required for TODO 6 to work.
3. **TODO 6** -- Provider with persistence. Students can see data being saved.
4. **TODO 7** -- Load on startup. Without this, data is saved but not loaded.

Can be shortened:
- Part 0 can be reduced to 12 min (demo only, skip student typing along for INSERT/query steps)
- Part 1 explanation (reduce from 10 to 5 min if students are comfortable with the motivation)
- TODO 5 can be shown on the projector and copied (5 min instead of 12)
- TODO 7 can be done as a quick follow-along (3 min instead of 15)

### If You Have Extra Time

- Show students how to inspect the SQLite database file using Android Studio's Database Inspector or a SQLite browser tool
- Discuss database migrations: what happens when you need to add a column in version 2? Show the `onUpgrade` callback.
- Ask students to implement a "clear all data" button that deletes all entries from the database
- Discuss encryption at rest for healthcare data (SQLCipher as an alternative to plain SQLite)
- Preview the async patterns they will see in Week 8 (network requests that also save to local cache)

---

## Complete Solutions Reference

Below are the full solutions for every TODO. Use these if you need to quickly show a solution on the projector or help a struggling student.

### TODO 1 Solution -- toMap() and fromMap()

**File:** `lib/models/mood_entry.dart`

```dart
Map<String, dynamic> toMap() {
  return {
    'id': id,
    'score': score,
    'note': note,
    'created_at': createdAt.toIso8601String(),
  };
}

factory MoodEntry.fromMap(Map<String, dynamic> map) {
  return MoodEntry(
    id: map['id'] as String,
    score: map['score'] as int,
    note: map['note'] as String?,
    createdAt: DateTime.parse(map['created_at'] as String),
  );
}
```

### TODO 2 Solution -- _initDatabase() and _onCreate()

**File:** `lib/data/database_helper.dart`

**Important:** Students must DELETE the placeholder `_initDatabase()` (the one without `onCreate`) before adding this.

```dart
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
```

### TODO 3 Solution -- insertMood()

**File:** `lib/data/database_helper.dart`

```dart
Future<void> insertMood(MoodEntry mood) async {
  final db = await database;
  await db.insert(
    'mood_entries',
    mood.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}
```

### TODO 4 Solution -- getMoods(), deleteMood(), updateMood()

**File:** `lib/data/database_helper.dart`

```dart
Future<List<MoodEntry>> getMoods() async {
  final db = await database;
  final maps = await db.query('mood_entries', orderBy: 'created_at DESC');
  return maps.map((map) => MoodEntry.fromMap(map)).toList();
}

Future<void> deleteMood(String id) async {
  final db = await database;
  await db.delete('mood_entries', where: 'id = ?', whereArgs: [id]);
}

Future<void> updateMood(MoodEntry mood) async {
  final db = await database;
  await db.update(
    'mood_entries',
    mood.toMap(),
    where: 'id = ?',
    whereArgs: [mood.id],
  );
}
```

### TODO 5 Solution -- Repository Methods

**File:** `lib/data/mood_repository.dart`

```dart
Future<List<MoodEntry>> getAllMoods() async {
  return await DatabaseHelper.instance.getMoods();
}

Future<void> addMood(MoodEntry entry) async {
  await DatabaseHelper.instance.insertMood(entry);
}

Future<void> deleteMood(String id) async {
  await DatabaseHelper.instance.deleteMood(id);
}

Future<void> updateMood(MoodEntry entry) async {
  await DatabaseHelper.instance.updateMood(entry);
}
```

### TODO 6 Solution -- MoodNotifier with Persistence

**File:** `lib/providers/mood_provider.dart`

Replace the existing `addMood`, `deleteMood`, and `updateMood` methods and add `loadMoods`:

```dart
Future<void> loadMoods() async {
  state = await _repository.getAllMoods();
}

Future<void> addMood(int score, String? note) async {
  final newEntry = MoodEntry(score: score, note: note);
  await _repository.addMood(newEntry);
  state = [newEntry, ...state];
}

Future<void> deleteMood(String id) async {
  await _repository.deleteMood(id);
  state = state.where((e) => e.id != id).toList();
}

Future<void> updateMood(String id, int score, String? note) async {
  final updated =
      state.firstWhere((e) => e.id == id).copyWith(score: score, note: note);
  await _repository.updateMood(updated);
  state = state.map((e) => e.id == id ? updated : e).toList();
}
```

> **Note:** The `MoodNotifier` constructor remains `MoodNotifier(this._repository) : super([])`. It starts with an empty list -- no sample data. The `loadMoods()` call in TODO 7 populates it from the database.

### TODO 7 Solution -- HomeScreen as ConsumerStatefulWidget

**File:** `lib/screens/home_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/mood_provider.dart';
import '../widgets/mood_card.dart';
import 'add_mood_screen.dart';
import 'mood_detail_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(moodProvider.notifier).loadMoods());
  }

  @override
  Widget build(BuildContext context) {
    final moods = ref.watch(moodProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Tracker'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StatsScreen()),
              );
            },
          ),
        ],
      ),
      body: moods.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sentiment_neutral, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No mood entries yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap + to add your first entry',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: moods.length,
              itemBuilder: (context, index) {
                final entry = moods[index];
                return MoodCard(
                  entry: entry,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MoodDetailScreen(entry: entry),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMoodScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

---

## End-of-Lab Assessment

### Wrap-Up and Verification

Walk students through this end-to-end test sequence in the last few minutes:

1. Launch the app -- should be empty on first launch or show previously saved entries
2. Add a mood entry with a specific score and note
3. Verify it appears at the top of the home screen list
4. **Fully close the app** (remove from recent apps list, not just press home)
5. **Reopen the app** -- verify the entry persisted
6. Delete the entry from the detail screen
7. Close and reopen the app once more
8. Verify the deleted entry is gone

Students who complete all 8 steps have a fully working implementation.

### Recovery Strategies

- **If many students are stuck on TODOs 2--4:** Show the complete solutions on the projector. These are the core database operations and students need them correct to proceed.
- **If database errors occur:** Check that the table name (`mood_entries`) and column names (`id`, `score`, `note`, `created_at`) match exactly between the `CREATE TABLE` statement and the `toMap()` method. A single character difference causes silent failures.
- **If data does not persist:** Check that the placeholder `_initDatabase()` was REPLACED, not just added alongside. Two `_initDatabase()` methods cause a compilation error, but if a student modified the placeholder instead of replacing it, the `onCreate` callback may be missing.
- **If the app crashes on startup after TODO 7:** Check that `Future.microtask()` wraps the `loadMoods()` call. Direct calls to `ref.read()` in `initState()` can trigger Riverpod assertion errors.

### Minimum Completion Checklist

At minimum, every student should leave the lab with:

- [ ] Part 0 -- Practiced SQL in the sqlite3 console (CREATE, INSERT, SELECT, UPDATE, DELETE)
- [ ] TODO 1 -- `toMap()` and `fromMap()` implemented in `mood_entry.dart`
- [ ] TODOs 2--4 -- All database operations implemented in `database_helper.dart`
- [ ] TODO 5 -- Repository methods implemented in `mood_repository.dart`
- [ ] TODO 6 -- MoodNotifier updated with async repository calls in `mood_provider.dart`
- [ ] TODO 7 -- HomeScreen loads data on startup via `ConsumerStatefulWidget` and `initState`

### For Students Who Did Not Finish

- Reassure them: "The finished project is available as a reference. Compare it with your work file by file to find the differences."
- Minimum viable: TODOs 1--5 (the persistence stack is complete). TODOs 6--7 wire it to the UI and can be finished at home.
- Remind them that Week 8 builds directly on this foundation -- they must have a working persistence layer before adding networking.

### Common Errors Reference

| Error | Cause | Fix |
|-------|-------|-----|
| `DatabaseException: no such table: mood_entries` | The `_onCreate()` callback was not provided to `openDatabase()`, or the placeholder `_initDatabase()` was not replaced. | Delete the placeholder `_initDatabase()`. Replace it with the version that includes `onCreate: _onCreate`. If the database file was already created without the table, uninstall and reinstall the app (or delete the database file) so `onCreate` runs again. |
| `type 'Null' is not a subtype of type 'String' in type cast` | Column name mismatch between `toMap()` keys and the `CREATE TABLE` column names. For example, `toMap()` uses `'created_at'` but the SQL column is `createdAt`. | Ensure map keys in `toMap()` exactly match the column names in `CREATE TABLE`. Both should use `created_at` (snake_case). |
| `Duplicate method '_initDatabase'` | Student uncommented the new `_initDatabase()` without deleting the placeholder. | Delete the placeholder version (the one without `onCreate`). Keep only the version that calls `openDatabase()` with `onCreate: _onCreate`. |
| `The method 'loadMoods' isn't defined for the type 'MoodNotifier'` | TODO 6 was not completed -- the `loadMoods()` method was not added to `MoodNotifier`. | Complete TODO 6 by adding the `loadMoods()` method to the `MoodNotifier` class. |
| `setState() called after dispose()` or Riverpod assertion error in `initState` | `ref.read(moodProvider.notifier).loadMoods()` called directly in `initState()` without `Future.microtask()`. | Wrap the call: `Future.microtask(() => ref.read(moodProvider.notifier).loadMoods());` |

---

## What Comes Next

In Week 8, students will add networking -- the app will connect to a REST API to sync mood data with a remote server. The local SQLite database built today becomes the offline cache, and the repository layer will be extended to coordinate between local storage and remote API calls. The layered architecture established this week makes that extension straightforward -- the UI and state management layers remain unchanged.
