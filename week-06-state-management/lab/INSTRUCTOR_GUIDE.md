# Week 6 Lab: Instructor Guide

**Course:** Multiplatform Mobile Software Engineering in Practice
**Lab Duration:** 2 hours
**Topic:** State Management with Riverpod
**Audience:** Familiar with Flutter widgets, navigation, and setState from Weeks 4--5

> This document is for the **instructor only**. Students use the separate `README.md` workbook.

---

## Pre-Lab Checklist

Complete these **before students arrive**:

- [ ] Verify Flutter is installed on all lab machines (`flutter doctor`)
- [ ] Open the **starter** project in an IDE and run `flutter pub get` -- confirm all dependencies resolve
- [ ] Build and launch the starter app on an emulator/simulator -- confirm it shows the hardcoded mood list
- [ ] Open the **finished** project and confirm it builds and runs correctly (this is your reference)
- [ ] Verify the `flutter_riverpod` package is present in `pubspec.yaml` (version 2.x)
- [ ] Verify the `uuid` package is present in `pubspec.yaml`
- [ ] Open the student workbook (`README.md`) on the projector
- [ ] Have the starter project open in a second IDE window for live coding demos
- [ ] Increase IDE/terminal font size to at least 18pt for projector readability
- [ ] Have a browser tab open to [riverpod.dev](https://riverpod.dev/) for quick reference

### Room Setup

- Projector showing your IDE with the starter project open
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
| 0:00--0:10 | 10 min | Welcome, context setting, verify setup | Instructor talk |
| 0:10--0:25 | 15 min | Part 1: Understanding State Management | Instructor talk + discussion |
| 0:25--0:45 | 20 min | Part 2: Building the MoodNotifier (TODOs 1--2) | Live coding + student work |
| 0:45--0:50 | 5 min | Break / catch-up buffer | --- |
| 0:50--1:00 | 10 min | Part 3: Wiring Up Riverpod (TODO 3) | Follow-along |
| 1:00--1:25 | 25 min | Part 4: Reactive UI (TODOs 4--5) | Live coding + student work |
| 1:25--1:30 | 5 min | Break / catch-up buffer | --- |
| 1:30--1:45 | 15 min | Part 5: State Mutations from Detail Views (TODO 6) | Student work |
| 1:45--2:00 | 15 min | Part 6: Derived State (TODO 7) + Wrap-up | Student work + summary |

**Total:** 120 minutes (2 hours)

> **Pacing note:** The two 5-minute buffers are critical. TODOs 1--2 are the hardest. If students struggle there, use the first buffer to help them catch up. TODOs 4--7 follow a repeating pattern (change widget type, add ref, call provider) and students should speed up as the pattern becomes familiar.

---

## Detailed Facilitation Guide

### 0:00--0:10 --- Welcome & Context Setting (10 min)

**Type:** Instructor talk

**What to say (talking points, not a script):**

- "Today we move from single-screen state management with setState to app-wide state management with Riverpod"
- "Think about what happens in a health app when a patient logs a symptom -- the list screen, the stats dashboard, and possibly notifications all need to update. setState cannot handle this."
- "We are building a Mood Tracker app. You will work on this app for the next 4 weeks."
- "The starter project already has the UI built. Your job today is to add the state management layer -- 7 TODOs across 5 files."
- "By the end of today, the app will reactively update across all screens when you add or delete mood entries."

**What students should be doing:**

- Opening the starter project in their IDE
- Running `flutter pub get`
- Launching the app and seeing the hardcoded mood list

**Checkpoint:** Before moving on, verify that **every student has the starter app running** and can see the three hardcoded mood entries on the home screen.

**Common pitfall:** Students who skipped Weeks 4--5 may not have Flutter set up. Pair them with a neighbor who does, or help them run `flutter doctor` to identify issues quickly.

---

### 0:10--0:25 --- Part 1: Understanding State Management (15 min)

**Type:** Instructor talk + discussion

**Demo on projector:**

Open the starter project and walk through the problem:

1. Open `home_screen.dart`. Point to the `_hardcodedMoods` list at the bottom. Say: "This is our current data source -- a hardcoded list. What happens if we add a new mood entry on the Add Mood screen?"
2. Open `add_mood_screen.dart`. Point to the placeholder SnackBar in `_submitMood()`. Say: "Right now, pressing Save does nothing useful. Even if we created a MoodEntry here, how would we get it back to the home screen?"
3. Open `stats_screen.dart`. Point to the hardcoded stats map. Say: "These numbers are fake. We need them to update automatically when the mood list changes."

**Key concepts to explain:**

- setState is **local** -- it only affects the widget that calls it
- We need state that is **shared** across screens and **reactive** -- UI updates automatically
- Riverpod provides three things: a place to store state (providers), a way to update it (StateNotifier), and a way to listen to it (ConsumerWidget + ref.watch)

**Draw on the whiteboard:**

```
                    ProviderScope (stores state)
                           |
                    moodProvider (MoodNotifier)
                    /      |       \
            HomeScreen  StatsScreen  AddMoodScreen
            ref.watch   ref.watch    ref.read
            (rebuilds)  (rebuilds)   (one-time action)
```

**Talking point:** "When AddMoodScreen calls `ref.read(moodProvider.notifier).addMood(...)`, the MoodNotifier updates its state. Riverpod then automatically notifies HomeScreen and StatsScreen to rebuild. Zero manual synchronization."

**Discussion question:** "In a real mHealth app, what kinds of data would need to be shared across multiple screens?" Expected answers: patient vitals, medication lists, appointment schedules, sensor readings, etc.

---

### 0:25--0:45 --- Part 2: Building the MoodNotifier (20 min)

**Type:** Live coding (first half) + student work (second half)

**This is the hardest part of the lab.** Students are writing a StateNotifier for the first time.

#### 0:25--0:35 --- Live Demo of TODO 1 (10 min)

**Demo on projector -- code TODO 1 live:**

Open `lib/providers/mood_provider.dart`. Walk through the scaffold comment and then write the class:

```dart
class MoodNotifier extends StateNotifier<List<MoodEntry>> {
  MoodNotifier()
      : super([
          MoodEntry(
            score: 8,
            note: 'Great day at the lab!',
            createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          MoodEntry(
            score: 5,
            note: 'Feeling okay',
            createdAt: DateTime.now().subtract(const Duration(hours: 5)),
          ),
          MoodEntry(
            score: 3,
            note: 'Stressful morning',
            createdAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
        ]);

  void addMood(int score, String? note) {
    final newEntry = MoodEntry(score: score, note: note);
    state = [newEntry, ...state];
  }

  void deleteMood(String id) {
    state = state.where((e) => e.id != id).toList();
  }

  void updateMood(String id, int score, String? note) {
    state = state
        .map((e) => e.id == id ? e.copyWith(score: score, note: note) : e)
        .toList();
  }
}
```

**Pause after the constructor.** Explain:
- `extends StateNotifier<List<MoodEntry>>` -- the type parameter is the state type
- `super([...])` -- initializes the state with sample data
- The sample data matches what was in `_hardcodedMoods` in `home_screen.dart`

**Pause after `addMood`.** Explain:
- `state = [newEntry, ...state]` -- creates a new list with the new entry first, then all existing entries
- "Why not `state.insert(0, newEntry)`?" Because that mutates the existing list. StateNotifier will not detect the change.

**Pause after `deleteMood`.** Explain:
- `state.where((e) => e.id != id)` -- keeps all entries except the one with the matching id
- `.toList()` -- converts the iterable back to a list

**Pause after `updateMood`.** Explain:
- `state.map(...)` -- transforms each entry, replacing the matching one with a copy that has new values
- `copyWith` -- creates a new `MoodEntry` with only the specified fields changed

#### 0:35--0:40 --- Student Work on TODO 2 (5 min)

**Say:** "Now it is your turn. Complete TODO 2 -- define the two providers. I will give you 5 minutes. The commented-out scaffold is there to guide you."

**Walk around the room.** Most students should be able to uncomment and complete the providers.

**If students struggle with `moodStatsProvider`**, point them to the hint in the TODO comment and remind them:
- Use `ref.watch(moodProvider)` to get the mood list
- Handle the empty list case first (return zeros)
- Use `scores.reduce((a, b) => a + b)` for sum, `scores.reduce((a, b) => a > b ? a : b)` for max

#### TODO 2 Solution

```dart
final moodProvider =
    StateNotifierProvider<MoodNotifier, List<MoodEntry>>((ref) {
  return MoodNotifier();
});

final moodStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final moods = ref.watch(moodProvider);
  if (moods.isEmpty) {
    return {
      'totalEntries': 0,
      'averageScore': 0.0,
      'highestScore': 0,
      'lowestScore': 0,
    };
  }
  final scores = moods.map((e) => e.score);
  return {
    'totalEntries': moods.length,
    'averageScore': scores.reduce((a, b) => a + b) / moods.length,
    'highestScore': scores.reduce((a, b) => a > b ? a : b),
    'lowestScore': scores.reduce((a, b) => a < b ? a : b),
  };
});
```

**Checkpoint:** "Raise your hand if your TODO 1 and TODO 2 are done. The app will NOT compile yet -- that is expected. We need TODO 3 before it will build."

**Common pitfall:** Students who forget `ref.watch(moodProvider)` in `moodStatsProvider` and instead try to access the notifier directly. Remind them: providers watch other providers using `ref.watch()`.

---

### 0:45--0:50 --- Break / Catch-Up Buffer (5 min)

- Students who finished TODOs 1--2: take a real break
- Students who are behind: use this time to finish
- Walk around and verify everyone has both the MoodNotifier class and the two provider definitions
- If many students are stuck, show the TODO 2 solution on the projector

---

### 0:50--1:00 --- Part 3: Wiring Up Riverpod (10 min)

**Type:** Follow-along (everyone together)

#### TODO 3 Demo (5 min)

**Demo on projector.** Open `lib/main.dart`:

**Before:**
```dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MoodTrackerApp());
}
```

**After:**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: MoodTrackerApp()));
}
```

**Explain:**
- "Two changes: one import, one wrapper"
- "ProviderScope is like a container that stores all provider state. It must be at the root."
- "Without ProviderScope, any `ref.watch()` or `ref.read()` call will crash at runtime"

**Have every student make this change.**

#### Verify (5 min)

**Say:** "Hot restart the app (capital R). It should still show the hardcoded mood entries on the home screen. Nothing has changed visually yet -- we still need to connect the screens to the providers."

**What to watch for:**
- Compilation errors usually mean TODO 1 or 2 has a syntax error. Help students fix those before continuing.
- If a student gets a `ProviderScope` not found error, they missed the import.

**Checkpoint:** "The app compiles and runs with the same hardcoded data? Good. Now we connect the UI."

---

### 1:00--1:25 --- Part 4: Reactive UI (25 min)

**Type:** Live coding (TODO 4) + student work (TODO 5)

#### 1:00--1:12 --- Live Demo of TODO 4 (12 min)

**Demo on projector.** Open `lib/screens/home_screen.dart`. Make changes step by step:

**Step 1 -- Add imports:**
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/mood_provider.dart';
```

**Step 2 -- Change widget type:**
```dart
// Before:
class HomeScreen extends StatelessWidget {

// After:
class HomeScreen extends ConsumerWidget {
```

**Step 3 -- Add ref parameter:**
```dart
// Before:
Widget build(BuildContext context) {

// After:
Widget build(BuildContext context, WidgetRef ref) {
```

**Step 4 -- Replace hardcoded data:**
```dart
// Before:
final moods = _hardcodedMoods;

// After:
final moods = ref.watch(moodProvider);
```

**Step 5 -- Delete the `_hardcodedMoods` variable** at the bottom of the file.

**Say:** "Hot restart. The app should look identical, but the data now comes from the MoodNotifier. Let me prove it -- let me temporarily change one of the sample entries in the MoodNotifier constructor and hot restart. See? The home screen reflects the change."

**Explain the pattern:** "This is the pattern you will repeat for every screen: (1) add imports, (2) change to ConsumerWidget, (3) add WidgetRef ref, (4) use ref.watch() or ref.read()."

#### Complete TODO 4 Solution

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/mood_provider.dart';
import '../widgets/mood_card.dart';
import 'add_mood_screen.dart';
import 'mood_detail_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moods = ref.watch(moodProvider);

    return Scaffold(
      // ... rest of the build method stays the same
    );
  }
}
// Delete the _hardcodedMoods variable entirely
```

#### 1:12--1:25 --- Student Work on TODO 5 (13 min)

**Say:** "Now do the same thing for the Add Mood screen -- TODO 5. This one is slightly different because it uses StatefulWidget. You need ConsumerStatefulWidget and ConsumerState instead. Follow the TODO comments. You have 13 minutes."

**Key differences to highlight before students start:**

| StatelessWidget | StatefulWidget |
|----------------|---------------|
| Change to `ConsumerWidget` | Change to `ConsumerStatefulWidget` |
| Add `WidgetRef ref` to `build()` | Change `State<X>` to `ConsumerState<X>` |
| --- | `ref` is already available (no extra parameter needed) |

**Walk around the room.** Common issues:
- Forgetting to change `State<AddMoodScreen>` to `ConsumerState<AddMoodScreen>`
- Forgetting to change `createState()` return type
- Using `ref.watch()` instead of `ref.read()` in `_submitMood()`

#### Complete TODO 5 Solution

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/mood_provider.dart';

class AddMoodScreen extends ConsumerStatefulWidget {
  const AddMoodScreen({super.key});

  @override
  ConsumerState<AddMoodScreen> createState() => _AddMoodScreenState();
}

class _AddMoodScreenState extends ConsumerState<AddMoodScreen> {
  int _score = 5;
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _submitMood() {
    ref.read(moodProvider.notifier).addMood(
          _score,
          _noteController.text.isEmpty ? null : _noteController.text,
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // ... rest of the build method stays the same
  }
}
```

**Checkpoint:** "Try adding a mood entry. Go back to the home screen. Does the new entry appear at the top? If yes, TODOs 4 and 5 are working."

**Common pitfall:** Students who see the SnackBar "Not implemented yet" message after pressing Save -- they forgot to remove the placeholder code in `_submitMood()`.

**Recovery if behind:** Show the complete TODO 5 solution on the projector. Emphasize the three-class change: `StatefulWidget` -> `ConsumerStatefulWidget`, `State` -> `ConsumerState`, `createState` return type.

---

### 1:25--1:30 --- Break / Catch-Up Buffer (5 min)

- Priority: make sure every student can add a mood entry and see it on the home screen
- Students who are ahead can start TODO 6 independently
- Quick check: "How many of you can add a new mood and see it appear on the home screen? Raise your hand."
- If less than 70% raise their hand, spend this buffer doing TODO 5 together on the projector

---

### 1:30--1:45 --- Part 5: State Mutations from Detail Views (15 min)

**Type:** Student work (with instructor available for help)

**Say:** "TODO 6 follows the exact same ConsumerWidget pattern as TODO 4. Open `mood_detail_screen.dart` and follow the TODO comments. The only new thing is the delete logic -- you need two `Navigator.pop()` calls, one to close the dialog and one to go back to the list. You have 15 minutes."

**Walk around the room.** This is where students should be gaining confidence with the pattern.

#### Complete TODO 6 Solution

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/mood_entry.dart';
import '../providers/mood_provider.dart';
import '../widgets/mood_score_indicator.dart';

class MoodDetailScreen extends ConsumerWidget {
  final MoodEntry entry;

  const MoodDetailScreen({super.key, required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Entry'),
                  content: const Text(
                    'Are you sure you want to delete this mood entry?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () {
                        ref
                            .read(moodProvider.notifier)
                            .deleteMood(entry.id);
                        Navigator.pop(context); // close dialog
                        Navigator.pop(context); // go back to list
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        // ... rest of the body stays the same
      ),
    );
  }
}
```

**What to watch for:**
- Students who only do one `Navigator.pop()` and get stuck on the detail screen after deleting
- Students who forget to remove the SnackBar placeholder code
- Students who use `ref.watch()` instead of `ref.read()` for the delete action

**Checkpoint:** "Tap an entry, delete it. Are you back on the home screen with the entry gone? If yes, TODO 6 is done."

---

### 1:45--2:00 --- Part 6: Derived State + Wrap-up (15 min)

**Type:** Student work (7 min) + summary (8 min)

#### 1:45--1:52 --- Student Work on TODO 7 (7 min)

**Say:** "Last TODO. Open `stats_screen.dart`. Same ConsumerWidget pattern. Replace the hardcoded stats map with `ref.watch(moodStatsProvider)`. You have 7 minutes."

#### Complete TODO 7 Solution

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/mood_provider.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(moodStatsProvider);

    return Scaffold(
      // ... rest of the build method stays the same
    );
  }
}
// The _StatCard class at the bottom stays unchanged
```

**Checkpoint:** "Navigate to the stats screen. Are the numbers real? Add a new entry and check again -- did the stats update?"

#### 1:52--2:00 --- Summary and Wrap-up (8 min)

**Talking points:**

- "You completed 7 TODOs across 5 files. The app now has proper state management."
- "The key pattern you learned: ConsumerWidget + ref.watch() for reading state, ref.read() for actions."
- "The MoodNotifier is the single source of truth. Every screen reads from it, and any mutation is immediately reflected everywhere."
- "Notice that the StatsScreen never needed to know about add or delete operations. It just watches `moodStatsProvider`, which watches `moodProvider`. The dependency chain handles everything."

**Preview Week 7:**
- "Next week we add SQLite persistence. The mood entries will survive app restarts."
- "The great thing about our architecture: we only need to modify the MoodNotifier to load from and save to a database. The UI code stays exactly the same."

**Final words:**
- "If your app is not fully working, the finished project is available as a reference."
- "Practice the ConsumerWidget pattern -- you will use it many more times."

---

## Instructor Notes: Pacing & Common Issues

### Where Students Typically Get Stuck

1. **Immutable state updates (TODO 1).** The concept of `state = [newEntry, ...state]` instead of `state.add(newEntry)` is counterintuitive. Emphasize the analogy: "You are replacing the entire list, not modifying the existing one. Think of it like replacing a photograph rather than drawing on it."

2. **ConsumerStatefulWidget (TODO 5).** Students confuse which classes to change. Draw the mapping on the board:
   ```
   StatelessWidget       -->  ConsumerWidget
   StatefulWidget        -->  ConsumerStatefulWidget
   State<X>              -->  ConsumerState<X>
   ```

3. **ref.watch() vs ref.read().** Students will use `ref.watch()` everywhere. Remind them: "watch in build, read in callbacks. If you watch in a callback, you get a linter warning and potentially unexpected behavior."

4. **Two Navigator.pop() calls (TODO 6).** Students forget that the delete dialog is a separate route. They call one pop, close the dialog, but stay on the detail screen showing a deleted entry.

5. **Compilation errors between TODOs.** After TODO 1--2, the app will not compile because other files reference providers that do not exist yet (if students try to build). Reassure them: "This is expected. Complete TODO 3 and it will compile."

### Where to Slow Down

- The first explanation of immutable state updates. Do multiple examples on the whiteboard.
- The ConsumerWidget conversion for TODO 4. Go step by step, pausing after each change.
- The distinction between `ref.watch()` and `ref.read()`.

### Where You Can Speed Up

- TODO 3 (ProviderScope) -- it is two lines of code, no conceptual difficulty.
- TODOs 6--7 -- they follow the exact same pattern as TODO 4. By this point, students should be faster.
- The `updateMood()` method in TODO 1 -- it is not actually used in the lab (it will be used in later weeks). Briefly explain it but do not dwell on it.

### If You Are Running Out of Time

Priority order (must complete):

1. **TODOs 1--3** -- MoodNotifier, providers, ProviderScope. This is the foundation.
2. **TODOs 4--5** -- HomeScreen and AddMoodScreen. Students can see reactive state working (add a mood, see it appear).
3. **TODO 6** -- Delete functionality.
4. **TODO 7** -- Statistics. Can be assigned as homework.

Can be shortened:
- Part 1 explanation (reduce from 15 to 10 min if students already understand the problem)
- TODOs 6--7 can be done together quickly by showing the pattern once and having students apply it to both files

### If You Have Extra Time

- Show students the Flutter DevTools and the Riverpod inspector
- Discuss why `moodStatsProvider` is a `Provider` (not `StateNotifierProvider`) -- it has no methods, it is pure derived state
- Ask students to implement an "edit mood" flow using the `updateMood` method
- Discuss how this architecture would scale to a real mHealth app with multiple data types (medications, vitals, appointments)
- Preview the async patterns they will see in Week 7 (AsyncNotifier, FutureProvider)

---

## Complete Solutions Reference

Below are the full solutions for every TODO. Use these if you need to quickly show a solution on the projector or help a struggling student.

### TODO 1 Solution -- MoodNotifier class

**File:** `lib/providers/mood_provider.dart`

```dart
class MoodNotifier extends StateNotifier<List<MoodEntry>> {
  MoodNotifier()
      : super([
          MoodEntry(
            score: 8,
            note: 'Great day at the lab!',
            createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          MoodEntry(
            score: 5,
            note: 'Feeling okay',
            createdAt: DateTime.now().subtract(const Duration(hours: 5)),
          ),
          MoodEntry(
            score: 3,
            note: 'Stressful morning',
            createdAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
        ]);

  void addMood(int score, String? note) {
    final newEntry = MoodEntry(score: score, note: note);
    state = [newEntry, ...state];
  }

  void deleteMood(String id) {
    state = state.where((e) => e.id != id).toList();
  }

  void updateMood(String id, int score, String? note) {
    state = state
        .map((e) => e.id == id ? e.copyWith(score: score, note: note) : e)
        .toList();
  }
}
```

### TODO 2 Solution -- Provider definitions

**File:** `lib/providers/mood_provider.dart` (below the MoodNotifier class)

```dart
final moodProvider =
    StateNotifierProvider<MoodNotifier, List<MoodEntry>>((ref) {
  return MoodNotifier();
});

final moodStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final moods = ref.watch(moodProvider);
  if (moods.isEmpty) {
    return {
      'totalEntries': 0,
      'averageScore': 0.0,
      'highestScore': 0,
      'lowestScore': 0,
    };
  }
  final scores = moods.map((e) => e.score);
  return {
    'totalEntries': moods.length,
    'averageScore': scores.reduce((a, b) => a + b) / moods.length,
    'highestScore': scores.reduce((a, b) => a > b ? a : b),
    'lowestScore': scores.reduce((a, b) => a < b ? a : b),
  };
});
```

### TODO 3 Solution -- ProviderScope

**File:** `lib/main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: MoodTrackerApp()));
}
```

### TODO 4 Solution -- HomeScreen as ConsumerWidget

**File:** `lib/screens/home_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/mood_provider.dart';
import '../widgets/mood_card.dart';
import 'add_mood_screen.dart';
import 'mood_detail_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

### TODO 5 Solution -- AddMoodScreen as ConsumerStatefulWidget

**File:** `lib/screens/add_mood_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/mood_provider.dart';

class AddMoodScreen extends ConsumerStatefulWidget {
  const AddMoodScreen({super.key});

  @override
  ConsumerState<AddMoodScreen> createState() => _AddMoodScreenState();
}

class _AddMoodScreenState extends ConsumerState<AddMoodScreen> {
  int _score = 5;
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _submitMood() {
    ref.read(moodProvider.notifier).addMood(
          _score,
          _noteController.text.isEmpty ? null : _noteController.text,
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Mood Entry'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'How are you feeling?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            Text(
              'Score: $_score',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            Slider(
              value: _score.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              label: '$_score',
              onChanged: (value) {
                setState(() {
                  _score = value.round();
                });
              },
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('1 — Terrible'),
                Text('10 — Excellent'),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Note (optional)',
                hintText: 'How was your day?',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _submitMood,
              icon: const Icon(Icons.check),
              label: const Text('Save Entry'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### TODO 6 Solution -- MoodDetailScreen as ConsumerWidget

**File:** `lib/screens/mood_detail_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/mood_entry.dart';
import '../providers/mood_provider.dart';
import '../widgets/mood_score_indicator.dart';

class MoodDetailScreen extends ConsumerWidget {
  final MoodEntry entry;

  const MoodDetailScreen({super.key, required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Entry'),
                  content: const Text(
                    'Are you sure you want to delete this mood entry?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () {
                        ref
                            .read(moodProvider.notifier)
                            .deleteMood(entry.id);
                        Navigator.pop(context); // close dialog
                        Navigator.pop(context); // go back to list
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: MoodScoreIndicator(score: entry.score, size: 80)),
            const SizedBox(height: 24),
            Text(
              'Score: ${entry.score}/10',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              'Date',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('EEEE, MMMM d, yyyy – HH:mm').format(entry.createdAt),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Note',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              entry.note ?? 'No note provided',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontStyle: entry.note == null ? FontStyle.italic : null,
                    color: entry.note == null ? Colors.grey : null,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### TODO 7 Solution -- StatsScreen as ConsumerWidget

**File:** `lib/screens/stats_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/mood_provider.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(moodStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _StatCard(
              icon: Icons.format_list_numbered,
              label: 'Total Entries',
              value: '${stats['totalEntries']}',
            ),
            const SizedBox(height: 12),
            _StatCard(
              icon: Icons.trending_up,
              label: 'Average Score',
              value: (stats['averageScore'] as double).toStringAsFixed(1),
            ),
            const SizedBox(height: 12),
            _StatCard(
              icon: Icons.arrow_upward,
              label: 'Highest Score',
              value: '${stats['highestScore']}',
            ),
            const SizedBox(height: 12),
            _StatCard(
              icon: Icons.arrow_downward,
              label: 'Lowest Score',
              value: '${stats['lowestScore']}',
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.titleMedium),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## End-of-Lab Assessment

### Minimum Completion Checklist

Every student should leave the lab with:

- [ ] `MoodNotifier` class implemented with `addMood`, `deleteMood`, and `updateMood` methods
- [ ] `moodProvider` and `moodStatsProvider` defined
- [ ] App wrapped in `ProviderScope`
- [ ] Home screen displaying mood entries from the provider (not hardcoded)
- [ ] Adding a mood entry works and the home screen updates reactively
- [ ] Deleting a mood entry works from the detail screen
- [ ] Statistics screen shows live computed data

### Quick Verification Method

In the last 2 minutes, ask students to perform this sequence:

1. Add a new mood entry with score 10
2. Verify it appears on the home screen
3. Check the statistics screen (highest score should be 10)
4. Delete the entry
5. Check statistics again (highest score should revert)

Students who complete all 5 steps have a fully working implementation.

### For Students Who Did Not Finish

- Reassure them: "The finished project is available as a reference. Compare it with your work to find the differences."
- Minimum viable: TODOs 1--5 (they can add and view moods). TODOs 6--7 can be finished at home.
- Remind them that next week builds on this foundation -- they should have a working app by then.
- Point them to the Riverpod documentation at [riverpod.dev](https://riverpod.dev/) for additional learning.
