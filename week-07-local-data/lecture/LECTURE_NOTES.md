# Week 7 Lecture: SharedPreferences, SQLite, Offline-First & Health Data

**Course:** Mobile Apps for Healthcare
**Duration:** ~2 hours (including Q&A)
**Format:** Student-facing notes with presenter cues

> Lines marked with `> PRESENTER NOTE:` are for the instructor only. Students can
> ignore these or treat them as bonus context.

---

## Table of Contents

1. [Why Local Data Matters](#1-why-local-data-matters-10-min) (10 min)
2. [Local Storage Options in Flutter](#2-local-storage-options-in-flutter-20-min) (20 min)
3. [SQLite Fundamentals](#3-sqlite-fundamentals-20-min) (20 min)
4. [Offline-First Architecture](#4-offline-first-architecture-15-min) (15 min)
5. [Health Data Considerations](#5-health-data-considerations-15-min) (15 min)
6. [Data Migration Strategies](#6-data-migration-strategies-10-min) (10 min)
7. [Key Takeaways](#7-key-takeaways-5-min) (5 min)

---

## 1. Why Local Data Matters (10 min)

### The Problem You Already Experienced

Your Mood Tracker app from Week 6 lost all data when you restarted it. Every mood entry, every note, every score -- gone the moment the app closed. For a demo or prototype, that is fine. For a real health app, that is a critical failure.

Think about it from a patient's perspective. Imagine someone managing a chronic condition -- depression, diabetes, hypertension. They log their mood or blood sugar every morning. They depend on that data to see trends, to share with their doctor, to feel in control. If the app loses their data because they received a phone call or stepped into an elevator, they will uninstall the app and never come back.

> PRESENTER NOTE: Ask the audience: "How many of you noticed data disappearing when you
> restarted the Mood Tracker in Week 6?" This is the perfect setup -- they lived the
> problem, now we solve it.

### Five Reasons to Store Data Locally

**1. Persistence.** Data must survive app restarts, device reboots, and even OS updates. A blood pressure reading logged at 7 AM should still be there at 7 PM, next week, and next year.

**2. Performance.** Reading from a local database takes milliseconds. Reading from a remote server takes hundreds of milliseconds at best, seconds at worst. For an app that a patient opens multiple times a day, that speed difference matters.

**3. Offline access.** Healthcare happens in places where internet connectivity is unreliable: ambulances racing between hospitals, rural clinics with spotty satellite links, basement imaging rooms surrounded by concrete and metal. A patient logging their blood pressure should not lose their data because they were in an elevator without signal.

**4. Privacy.** Some data should never leave the device unless explicitly shared. A patient's mental health journal is deeply personal. Local storage gives users control over where their data lives.

**5. Caching.** Even when you have a backend server, caching data locally reduces server load, saves bandwidth, and makes the app feel faster. Fetching the same 200 mood entries from the server every time the user opens the app is wasteful when the data has not changed.

### The Core Principle

Local storage is not a nice-to-have feature. It is infrastructure. Every mobile health app needs it. The question is not *whether* to store data locally, but *which technology* to use for each type of data.

---

## 2. Local Storage Options in Flutter (20 min)

Flutter gives you several options for local storage. Each one fits a different use case. Choosing the wrong tool leads to security vulnerabilities, performance problems, or unnecessary complexity.

### SharedPreferences: The Post-it Note

**What it is:** A simple key-value store backed by NSUserDefaults on iOS and SharedPreferences on Android.

**Use cases:**
- User settings (dark mode on/off, preferred language)
- Simple flags (has the user completed onboarding? Is this the first launch?)
- Last sync timestamp
- Theme preference

**What it is NOT for:**
- Large datasets (it loads the entire file into memory)
- Structured data that needs querying
- Sensitive data (it is stored as plain text on the device)

**Analogy:** SharedPreferences is like Post-it notes stuck to your fridge. Quick to write, quick to read, always visible. But you would not organize your entire medical record on Post-it notes.

```dart
// Writing a value
final prefs = await SharedPreferences.getInstance();
await prefs.setBool('onboarding_complete', true);
await prefs.setString('last_sync', DateTime.now().toIso8601String());

// Reading a value
final onboardingDone = prefs.getBool('onboarding_complete') ?? false;
final lastSync = prefs.getString('last_sync');
```

Simple, straightforward, and limited by design.

### SQLite: The Filing Cabinet

**What it is:** A full relational database that runs inside your app. No server needed -- the entire database is a single file on the device.

**Use cases:**
- Structured data that needs querying (mood entries, patient records, medication schedules)
- Large datasets (thousands or millions of rows)
- Complex relationships between data (a patient has many entries, each entry has tags)
- Data that needs to be sorted, filtered, and aggregated

**Analogy:** SQLite is like a well-organized filing cabinet with labeled folders, dividers, and an index. It takes more effort to set up than a Post-it note, but once it is in place, you can find anything quickly.

In Flutter, you access SQLite through one of two packages:

- **sqflite** -- a direct SQL interface. You write raw SQL strings. Simple, widely used, battle-tested.
- **drift** (formerly moor) -- a type-safe, code-generated wrapper around SQLite. You define tables in Dart code, and drift generates the SQL for you. Compile-time query validation. Reactive streams that update your UI when data changes (pairs perfectly with Riverpod).

We will focus on sqflite because it is simpler to learn, and you practiced it in the lab. Know that drift exists for when you want stronger type safety in production projects.

### Hive and Isar: The NoSQL Alternatives

**What they are:** Dart-native NoSQL databases. Key-value stores with more features than SharedPreferences but without the SQL overhead.

**Use cases:**
- When you want database features (persistence, indexing, querying) but do not want to write SQL
- Dart objects can be stored directly without manual serialization (with code generation)

**Trade-offs:**
- Hive is fast and simple but development has slowed
- Isar is newer and more actively developed but has a smaller community
- Both have less mature ecosystems compared to SQLite, which has been around since 2000

For most projects in this course, SQLite will be the right choice. But these alternatives are worth knowing about.

### Secure Storage: The Safe

**What it is:** Encrypted key-value storage backed by the platform's hardware security module -- Keychain on iOS, Keystore on Android.

**Use cases:**
- Authentication tokens (JWT tokens, API keys)
- Encryption keys
- Passwords and PINs
- Any credential that grants access to sensitive data

**Critical rule:** NEVER store authentication tokens in SharedPreferences. SharedPreferences is plain text. Anyone with physical access to the device -- or any app that gains file system access through a vulnerability -- can read them.

```dart
// flutter_secure_storage example
final storage = FlutterSecureStorage();

// Write (encrypted automatically)
await storage.write(key: 'auth_token', value: 'eyJhbGciOiJIUzI1...');

// Read (decrypted automatically)
final token = await storage.read(key: 'auth_token');

// Delete
await storage.delete(key: 'auth_token');
```

The encryption is hardware-backed. On iOS, the Keychain is protected by the Secure Enclave. On Android, the Keystore uses hardware-backed keys when available. This means even if the device is jailbroken or rooted, the data is significantly harder to extract.

### File System: The Document Drawer

**What it is:** Direct file read/write using `dart:io` and the `path_provider` package to find the right directory.

**Use cases:**
- Downloaded documents (PDFs, images)
- Exported data (CSV files for sharing with clinicians)
- Cached media files
- Any large binary data that does not belong in a database

```dart
final directory = await getApplicationDocumentsDirectory();
final file = File('${directory.path}/exported_moods.csv');
await file.writeAsString(csvContent);
```

### Comparison Table

| Feature | SharedPreferences | SQLite | Hive/Isar | Secure Storage | File System |
|---------|-------------------|--------|-----------|----------------|-------------|
| Data type | Key-value pairs | Relational tables | Key-value / objects | Key-value pairs | Raw files |
| Querying | By key only | Full SQL | Basic queries | By key only | N/A |
| Encryption | None | Optional (sqlcipher) | Optional | Built-in (HW) | Manual |
| Performance | Fast (small data) | Fast (any size) | Very fast | Slower | Varies |
| Best for | Settings, flags | Structured records | Object storage | Credentials | Documents |
| Capacity | Kilobytes | Gigabytes | Gigabytes | Kilobytes | Gigabytes |

### The Decision Tree

When deciding which storage to use, walk through this tree:

```
What kind of data do you need to store?
           |
           |-- Simple key-value (settings, flags, preferences)?
           |     +-- SharedPreferences
           |
           |-- Structured records (patients, mood entries, vitals)?
           |     +-- Need SQL queries or complex relationships?
           |           |-- Yes --> SQLite (sqflite / drift)
           |           +-- No ---> Hive / Isar
           |
           |-- Sensitive credentials (tokens, keys, passwords)?
           |     +-- flutter_secure_storage
           |
           +-- Large files (images, PDFs, exported CSVs)?
                 +-- File system (path_provider + dart:io)
```

> PRESENTER NOTE: This is a good time for interaction. Ask the class: "What kind of
> data does your team's project need to store? Which storage option fits best?" Have
> 2-3 teams share their answers. Common answers will include patient records (SQLite),
> user settings (SharedPreferences), and auth tokens (secure storage). If a team says
> "we'll just put everything in SharedPreferences," gently correct them.

---

## 3. SQLite Fundamentals (20 min)

### Why SQLite Dominates Mobile Storage

Most of your projects will need SQLite for structured data. Before we look at how to use it in Flutter, let's understand what SQLite actually is and why it is so widely used.

SQLite is an **embedded** relational database. Unlike PostgreSQL or MySQL, there is no separate server process. The database engine runs inside your app, and the entire database is stored as a **single file** on the device's file system.

SQLite is everywhere. It is built into every iPhone, every Android phone, every Mac, every Windows machine, every web browser. It is estimated to be the most widely deployed database engine in the world -- there are literally trillions of SQLite databases in active use.

For mobile apps, SQLite is ideal because:
- No server configuration or management
- Zero-latency local queries
- Reliable -- it has been in production since 2000
- Handles databases up to 281 terabytes (far more than any mobile app needs)
- ACID-compliant -- transactions are safe even if the app crashes mid-write

### SQL Basics: A Quick Review

You know Python. SQL follows a similar logic, just with a different syntax. Here are the five fundamental operations:

**CREATE TABLE** -- Define the structure of your data:

```sql
CREATE TABLE moods (
  id TEXT PRIMARY KEY,
  score INTEGER NOT NULL,
  note TEXT,
  createdAt TEXT NOT NULL
);
```

This is like defining a class in Dart or Python, except you are defining columns in a table.

**INSERT** -- Add a new row:

```sql
INSERT INTO moods (id, score, note, createdAt)
VALUES ('abc-123', 4, 'Feeling good today', '2026-02-22T10:30:00');
```

**SELECT** -- Query data (the most powerful operation):

```sql
-- Get all moods, newest first
SELECT * FROM moods ORDER BY createdAt DESC;

-- Get only happy moods (score >= 4)
SELECT * FROM moods WHERE score >= 4;

-- Count entries per score
SELECT score, COUNT(*) as count FROM moods GROUP BY score;
```

**UPDATE** -- Modify existing data:

```sql
UPDATE moods SET score = 5, note = 'Actually, great day!'
WHERE id = 'abc-123';
```

**DELETE** -- Remove data:

```sql
DELETE FROM moods WHERE id = 'abc-123';
```

> PRESENTER NOTE: Students know Python and C/C++, so SQL syntax will be new but the
> concepts are familiar. Don't spend too much time on SQL syntax -- they practiced
> the Dart/sqflite API in the lab. The goal here is conceptual understanding.

### sqflite vs drift: Two Ways to Use SQLite in Flutter

**sqflite** gives you a direct SQL interface. You write SQL strings, and sqflite executes them:

```dart
// sqflite: raw SQL
final maps = await db.query('moods', where: 'score >= ?', whereArgs: [4]);
```

This is what you used in the lab. It is simple and explicit. But SQL strings are not checked at compile time -- a typo in a column name only shows up when the app runs.

**drift** takes a different approach. You define tables in Dart code, and drift generates type-safe queries:

```dart
// drift: type-safe, code-generated
class Moods extends Table {
  TextColumn get id => text()();
  IntColumn get score => integer()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

// Usage: compile-time checked
final happyMoods = await (select(moods)..where((m) => m.score.isBiggerOrEqualValue(4))).get();
```

With drift, if you misspell a column name, the compiler catches it. If you try to compare a text column with an integer, the compiler catches it. This is safer for production apps.

drift also gives you **reactive streams** -- queries that automatically re-emit results when the underlying data changes. This pairs perfectly with Riverpod's state management model.

For this course, sqflite is sufficient. But if you continue building health apps professionally, drift is worth learning.

### The Repository Pattern

In the lab, you implemented the repository pattern. Let's examine *why* it exists and *why* it matters so much for health apps.

The repository pattern places a clean abstraction layer between your business logic and your data source:

```
+------------+     +--------------+     +--------------+
| UI (Widget)|     |  Riverpod    |     |  Repository  |
|            |---->|  Notifier    |---->|              |
| ref.watch()|     |              |     | addMood()    |
|            |     | state: moods |     | getMoods()   |
+------------+     +--------------+     | deleteMood() |
                                        +------+-------+
                                               |
                                        +------+-------+
                                        |   SQLite     |
                                        |   Database   |
                                        |   (file)     |
                                        +--------------+
```

The key insight: **your Riverpod notifier talks to the repository, not directly to the database.** The notifier calls `repository.addMood(entry)`. It does not know or care whether the repository saves that entry to SQLite, sends it to a REST API, writes it to a CSV file, or does all three.

This matters in healthcare for a very practical reason. During development, you use a local SQLite database. In a clinical trial deployment, you might need to sync data with a FHIR server. In a hospital integration, you might need to write to an HL7 interface. The repository pattern lets you swap the data source without changing a single line of UI code or business logic.

It also makes testing easy. In your unit tests, you can replace the real repository with a mock that returns pre-defined data. No database setup, no cleanup, no flaky tests.

> PRESENTER NOTE: This is a good moment to connect to the lab. "In the lab, you noticed
> that the UI code from Week 6 stayed EXACTLY the same. The only files you changed were
> in the data layer and the notifier. The screens and widgets did not need a single edit.
> That is the power of the repository pattern."

### The Optimistic Update Pattern

You also practiced another important pattern in the lab: **optimistic updates**. When a user adds a mood entry, the app:

1. Updates the in-memory state immediately (the UI refreshes instantly)
2. Writes to the database in the background

```dart
void addMood(int score, String? note) {
  final entry = MoodEntry(/* ... */);
  state = [entry, ...state];     // Step 1: UI updates immediately
  _repository.addMood(entry);    // Step 2: Database write happens async
}
```

Why not wait for the database write to complete before updating the UI? Because SQLite writes take a few milliseconds, and making the user wait -- even for a few milliseconds -- creates a perceptible lag. In a health app where patients log entries multiple times a day, that lag accumulates into a frustrating experience.

The risk of optimistic updates is that the database write could fail. In practice, local SQLite writes almost never fail (unlike network requests). If they do fail, it usually means the device is out of storage, which is a bigger problem that requires its own handling.

---

## 4. Offline-First Architecture (15 min)

### Two Philosophies

There are two fundamentally different ways to build a mobile app that talks to a server:

**Online-first (most apps):** The app fetches data from the server, displays it, and caches a copy locally. If the network is unavailable, the app shows cached data or an error message.

```
User action --> Network request --> Server responds --> Update local cache --> Show data
                     |
                     +-- Network unavailable? Show error or stale cache.
```

**Offline-first (health apps):** The app reads and writes data locally. When a network connection is available, the app syncs changes to the server in the background. The user never waits for the network.

```
User action --> Write to local DB --> Show data immediately
                     |
                     +-- When online --> Sync to server in background
```

The key difference: in an online-first app, the network is the primary data source. In an offline-first app, the local database is the primary data source.

### Why Offline-First Matters in Healthcare

Offline-first is not just a nice architecture pattern. In healthcare, it can be a patient safety requirement:

**Ambulances have intermittent connectivity.** A paramedic logging vital signs while racing to the hospital cannot wait for a server response. The data must be captured locally and synced later.

**Rural clinics may have slow or unreliable internet.** In many developing countries, community health workers use mobile apps to track vaccinations, maternal health, and disease outbreaks. These workers often operate in areas with no cellular coverage. The app must work completely offline for days or weeks, then sync when the worker returns to a facility with connectivity.

**Hospital infrastructure blocks signals.** Basements, MRI rooms, and Faraday-caged areas in hospitals have no cellular or Wi-Fi coverage. A clinician documenting observations in these areas needs an app that works without connectivity.

**Patient safety requires the app to always work.** If a nurse is administering medication based on data in the app, the app MUST display that data. "Network error -- please try again" is not acceptable when a patient's medication dose depends on it.

> PRESENTER NOTE: Demo the concept of offline-first live. Open the Notes app on your
> phone (or any note-taking app). Put the phone in airplane mode. Create a few notes,
> edit them, delete one. Everything works. Now turn airplane mode off. The notes sync.
> That is offline-first. The user never noticed the network was down.

### The Architecture

Here is how offline-first works in practice:

```
+---------------------------------------------------+
|             Offline-First Architecture             |
|                                                    |
|  +----------+  always    +----------+              |
|  |   UI     | ---------> |  Local   |              |
|  |          | <--------- |  DB      |              |
|  |          |   reads    | (SQLite) |              |
|  +----------+            +----+-----+              |
|                               |                    |
|                          when online               |
|                               |                    |
|                          +----v-----+              |
|                          |  Sync    |              |
|                          |  Engine  |              |
|                          +----+-----+              |
|                               |                    |
|                          +----v-----+              |
|                          |  Remote  |              |
|                          |  Server  |              |
|                          | (FastAPI)|              |
|                          +----------+              |
|                                                    |
|  User never waits for network.                     |
|  Data syncs in background when possible.           |
+---------------------------------------------------+
```

**The UI always talks to the local database.** Every read and every write goes to SQLite first. The user experience is identical whether the device is online or offline.

**The sync engine handles background synchronization.** When the device has a network connection, the sync engine:
1. Pushes local changes to the server
2. Pulls remote changes to the local database
3. Handles any conflicts

### The Sync Challenge: Conflicts

Offline-first architecture introduces a hard problem: **conflict resolution.**

Imagine this scenario: A patient has the app installed on their phone and their tablet. While on an airplane (offline), they edit a mood entry on their phone. Meanwhile, their therapist edits the same entry's note on the server. When the phone reconnects, there are two conflicting versions of the same record.

What should happen?

**Last-write-wins:** The most recent edit overwrites the other. Simple but potentially loses data. The therapist's note is gone.

**Merge:** Attempt to combine both changes. Works for some data types (adding items to a list) but not others (changing a single field to two different values).

**Manual resolution:** Show the user both versions and let them choose. Safe but disrupts the user experience.

For this course, you do not need to implement sync. A simple "push local changes, pull remote changes" approach is sufficient for your projects. But be aware that sync is one of the hardest problems in distributed systems, and healthcare makes it even harder because data accuracy has clinical consequences.

> PRESENTER NOTE: Don't let this section scare students. They are not implementing
> sync in this course. The point is awareness: if they build health apps professionally,
> they will encounter this problem. For now, local-only storage (which they built in the
> lab) is perfectly appropriate for their projects.

### What You Built in the Lab Is the Foundation

The architecture you implemented in the lab -- UI talks to Riverpod, Riverpod talks to a Repository, Repository talks to SQLite -- is the first half of an offline-first system. You have the local storage layer. In Week 8, you will add networking. If you were to combine both with a sync engine, you would have a complete offline-first architecture.

---

## 5. Health Data Considerations (15 min)

### Health Data Is Not Like Other Data

When you build a photo-sharing app and lose a user's photo, it is annoying. When you build a health app and lose a patient's data, it can affect clinical decisions. Health data has properties that demand extra care:

**It is highly sensitive.** Diagnoses, medications, mental health notes, genetic information -- this data can affect someone's employment, insurance, and personal relationships if exposed.

**It is legally protected.** The European Union's GDPR (General Data Protection Regulation) and the United States' HIPAA (Health Insurance Portability and Accountability Act) impose strict requirements on how health data is collected, stored, processed, and shared. Violations carry significant fines -- up to 20 million euros under GDPR.

**It must be accurate.** Clinical decisions depend on it. If a database corruption changes a medication dosage from 5mg to 50mg, the consequences are life-threatening.

**It must be available.** Emergencies do not wait for servers. A patient's allergy information must be accessible even when the hospital's network is down.

### Data Classification

Not all health data has the same sensitivity level. Understanding the classification helps you choose the right storage and protection strategy:

**Personally Identifiable Information (PII):**
- Name, date of birth, address, phone number, email
- Enough to identify a specific person
- Protected under GDPR and similar regulations worldwide

**Protected Health Information (PHI):**
- PII combined with health conditions, treatments, test results, provider names
- "Jan Kowalski has depression" is PHI. "A 25-year-old patient has depression" is not (unless the demographics are specific enough to identify the person).
- Protected under HIPAA (US), GDPR (EU), and other health-specific regulations

**De-identified data:**
- PII stripped from health records
- Safe to use for research and analytics
- Must follow specific de-identification standards (HIPAA defines 18 identifiers that must be removed)

For your course projects, most of you are building apps that handle at least PII and possibly PHI. Even though these are student projects, building with proper data handling habits now will serve you well in professional work.

### Local Storage Security

SQLite, by default, does **not** encrypt the database file. Anyone with physical access to the device -- or any app that exploits a file system vulnerability -- can open the database file and read its contents directly.

For a health app, this is not acceptable.

**Encryption at rest:** Use sqlcipher (an encrypted variant of SQLite) to encrypt the entire database file. The data is unreadable without the encryption key, even if the file is extracted from the device.

**Key management:** Store the encryption key in secure storage (Keychain on iOS, Keystore on Android), NEVER in SharedPreferences or hardcoded in the source code. The key should be protected by the device's hardware security module.

```
+--------------------+        +---------------------+
|  Your App          |        |  Platform Secure    |
|                    |        |  Storage             |
|  SQLite DB         |  key   |                     |
|  (encrypted with   |<-------|  Encryption key     |
|   sqlcipher)       |        |  (hardware-backed)  |
|                    |        |                     |
+--------------------+        +---------------------+
```

Even if the phone is stolen, the data should be unreadable without the encryption key, which is protected by the device's biometrics or PIN.

> PRESENTER NOTE: Brief mention: "We'll go deeper into GDPR, HIPAA, and security in
> Weeks 8 and 9. Today, just be aware that health data storage has legal requirements.
> The key takeaway: encrypt sensitive data at rest and store encryption keys in secure
> storage."

### The Cost of Getting It Wrong

This is not theoretical. In 2015, Anthem -- one of the largest health insurance providers in the United States -- experienced a data breach that exposed the records of 78.8 million individuals. In another case, a healthcare provider's stolen laptop exposed 4.5 million patient records because the hard drive was not encrypted. Local data encryption is not optional -- it is a regulatory requirement and an ethical obligation.

In the European Union, the GDPR has resulted in significant fines for healthcare organizations that failed to protect patient data. The message is clear: if you handle health data, you must handle it carefully.

### Data Minimization

GDPR introduces a powerful principle: **data minimization**. Only collect and store data that you actually need for the stated purpose of your app.

Your mood tracker needs to store mood scores, timestamps, and optional notes. It does **not** need the patient's home address, social security number, or date of birth (unless there is a specific clinical reason). Every additional piece of data you store increases your liability and the potential impact of a breach.

Ask yourself for every data field: "Does my app need this to function? If not, don't collect it."

### Audit Logging

In a clinical app, you need to know **who** accessed or modified data and **when**. This is both a GDPR requirement and a basic clinical safety practice.

At a minimum, every record in your database should include:

- `created_at` -- when the record was first created
- `updated_at` -- when it was last modified

For production health apps, you might also track:

- Who created or modified the record
- What the previous values were before modification
- Why the modification was made

In your SQLite tables, always include `created_at` and `updated_at` timestamps. It costs almost nothing in storage and provides invaluable audit information.

---

## 6. Data Migration Strategies (10 min)

### The Inevitability of Schema Change

Your first database schema will not be your last. As your app evolves, you will need to:

- Add new columns (e.g., adding a `tags` field to mood entries)
- Rename columns (e.g., `note` becomes `notes`)
- Add new tables (e.g., a `medications` table)
- Change column types (e.g., storing `score` as a REAL instead of INTEGER)
- Add indexes for performance

The problem: when a user updates your app from version 1.0 to version 2.0, they already have a database file on their device with the old schema. The new code expects the new schema. If you just try to run, the app crashes.

### Database Migrations

A **migration** is a script that transforms the database from one schema version to another without losing data.

SQLite (and sqflite) use a version number to track which migrations have been applied:

```dart
final db = await openDatabase(
  path,
  version: 2,  // Current schema version
  onCreate: (db, version) {
    // Fresh install: create the latest schema directly
    db.execute('CREATE TABLE moods (id TEXT PRIMARY KEY, score INTEGER, ...)');
  },
  onUpgrade: (db, oldVersion, newVersion) {
    // Existing user updating from an older version
    if (oldVersion < 2) {
      db.execute('ALTER TABLE moods ADD COLUMN tags TEXT');
    }
  },
);
```

**How it works:**
1. On fresh install: `onCreate` runs, creating the latest schema (version 2)
2. On update from version 1 to 2: `onUpgrade` runs, applying only the necessary changes
3. If the database is already version 2: neither callback runs

### Migration Best Practices

**Always increment the version number** when you change the schema. Never modify the `onCreate` callback without also adding a corresponding `onUpgrade` step.

**Migrations must be cumulative.** If a user skips from version 1 directly to version 3, all intermediate migrations must run in order:

```dart
onUpgrade: (db, oldVersion, newVersion) {
  if (oldVersion < 2) {
    db.execute('ALTER TABLE moods ADD COLUMN tags TEXT');
  }
  if (oldVersion < 3) {
    db.execute('ALTER TABLE moods ADD COLUMN location TEXT');
  }
},
```

**Never delete old migration code.** Even if no user is on version 1 anymore, keep the migration code. You never know when someone will update after months of not using the app.

**Test migrations thoroughly.** Create a test database with the old schema, run the migration, and verify that the data is intact and the new schema is correct. A failed migration means data loss.

**Back up before migrating.** In a production health app, copy the database file before running migrations. If something goes wrong, you can restore the backup.

```dart
// Simple backup strategy
final dbFile = File(dbPath);
final backupFile = File('$dbPath.backup');
await dbFile.copy(backupFile.path);
```

### drift Handles This More Elegantly

If you use drift instead of raw sqflite, migrations become more structured. drift tracks schema versions and lets you define migration steps declaratively:

```dart
@override
MigrationStrategy get migration => MigrationStrategy(
  onCreate: (m) async => await m.createAll(),
  onUpgrade: stepByStep(
    from1To2: (m, schema) async {
      await m.addColumn(schema.moods, schema.moods.tags);
    },
  ),
);
```

The `stepByStep` function automatically applies only the necessary migrations based on the user's current version. It is less error-prone than managing `if (oldVersion < N)` chains manually.

### The Bottom Line

Plan for migrations from day one. Your schema **will** change. In a production health app, losing a patient's data because of a botched migration is unacceptable. Test every migration with real data before releasing an update.

---

## 7. Key Takeaways (5 min)

1. **Local data persistence is essential for health apps** -- data must survive restarts, work offline, and remain available when connectivity is unreliable. A patient's data is too important to exist only in memory.

2. **Choose the right storage for each type of data** -- SharedPreferences for settings and flags, SQLite for structured records that need querying, flutter_secure_storage for credentials and encryption keys, and the file system for large binary files.

3. **The Repository Pattern abstracts your data layer** -- your Riverpod notifier talks to a repository, not directly to the database. This makes your code testable, your storage swappable, and your architecture clean.

4. **Offline-first architecture ensures your app works without internet** -- critical in healthcare settings where connectivity is unreliable. The UI always reads from and writes to the local database. Sync happens in the background when a connection is available.

5. **Health data requires encryption at rest, data minimization, and audit logging** -- SQLite does not encrypt by default. Use sqlcipher for encrypted databases and store encryption keys in secure storage. Only collect data you need. Always include timestamps.

6. **Plan for database migrations from day one** -- your schema will change as your app evolves. Migrations must be cumulative, thoroughly tested, and backed up. A failed migration means data loss for your users.

---

## Further Reading

If you want to go deeper on any topic covered today:

- **sqflite package:** [https://pub.dev/packages/sqflite](https://pub.dev/packages/sqflite)
- **drift (type-safe SQLite for Dart/Flutter):** [https://drift.simonbinder.eu/](https://drift.simonbinder.eu/)
- **SharedPreferences:** [https://pub.dev/packages/shared_preferences](https://pub.dev/packages/shared_preferences)
- **flutter_secure_storage:** [https://pub.dev/packages/flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)
- **Offline-first design principles:** [https://offlinefirst.org/](https://offlinefirst.org/)
- **GDPR for developers:** [https://gdpr.eu/](https://gdpr.eu/)
- **SQLite official documentation:** [https://www.sqlite.org/docs.html](https://www.sqlite.org/docs.html)
- **Flutter cookbook -- Persist data with SQLite:** [https://docs.flutter.dev/cookbook/persistence/sqlite](https://docs.flutter.dev/cookbook/persistence/sqlite)
