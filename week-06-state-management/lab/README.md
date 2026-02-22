# Week 6 Lab: State Management with Riverpod

> **Course:** Mobile Apps for Healthcare
> **Duration:** ~2 hours
> **Prerequisites:** Weeks 4--5 Flutter fundamentals (widgets, navigation, StatefulWidget, setState)

---

## Learning Objectives

By the end of this lab you will be able to:

1. Explain why `setState()` alone is insufficient for apps with shared state across multiple screens.
2. Describe the role of Riverpod as a state management solution in Flutter.
3. Implement a `StateNotifier` with immutable state updates (add, delete, update).
4. Define providers (`StateNotifierProvider`, computed `Provider`) to expose and derive state.
5. Wire a Flutter app to Riverpod using `ProviderScope` and `ConsumerWidget`.
6. Use `ref.watch()` for reactive UI rebuilds and `ref.read()` for one-time actions in event handlers.
7. Build a computed/derived provider that automatically recalculates when its dependencies change.

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
  week-06-state-management/lab/starter/mood_tracker/
  ```
  Open this folder and run `flutter pub get` to resolve dependencies. Verify the app builds and launches before starting the exercises.

> **Tip:** If the starter project does not compile, check that `flutter_riverpod` and `uuid` appear in `pubspec.yaml` and that `flutter pub get` completed without errors. Ask the instructor for help if needed.

---

## About the Starter Project

You are working on a **Mood Tracker** app that will be developed incrementally over Weeks 6--9. The starter project already provides:

- A `MoodEntry` model with `id`, `score`, `note`, and `createdAt` fields (plus `copyWith`)
- Four screens: Home, Add Mood, Mood Detail, and Statistics
- Reusable widgets: `MoodCard` and `MoodScoreIndicator`

The app currently uses **hardcoded data** and placeholder logic. Your job in this lab is to replace those with proper **Riverpod state management** by completing 7 TODOs across 5 files.

### Project structure

| File | Purpose |
|------|---------|
| `lib/models/mood_entry.dart` | Data model (provided -- do not edit) |
| `lib/providers/mood_provider.dart` | TODOs 1--2: State notifier and provider definitions |
| `lib/main.dart` | TODO 3: ProviderScope setup |
| `lib/screens/home_screen.dart` | TODO 4: Reactive mood list |
| `lib/screens/add_mood_screen.dart` | TODO 5: Adding new moods |
| `lib/screens/mood_detail_screen.dart` | TODO 6: Deleting moods |
| `lib/screens/stats_screen.dart` | TODO 7: Derived statistics |
| `lib/widgets/` | Reusable UI components (provided -- do not edit) |

---

> **Healthcare Context: Why State Management Matters in mHealth**
>
> In real mobile health applications, state management is critical. Consider:
> - **Real-time vital signs** from wearable sensors must update across multiple screens simultaneously.
> - **Medication reminders** need consistent state so a dismissal on one screen is reflected everywhere.
> - **Patient mood tracking** (exactly what you are building) requires that adding, editing, or deleting an entry immediately propagates to lists, detail views, and statistical dashboards.
> - **Data integrity** -- in healthcare, showing stale or inconsistent data is not just a bug, it is a safety risk.
>
> The patterns you learn today -- centralized state, immutable updates, and reactive UI -- are the same patterns used in production mHealth apps.

---

## Part 1: Understanding State Management (~15 min)

### 1.1 The problem with setState()

In Weeks 4--5, you used `setState()` to update the UI. This works well for **local state** within a single widget, but breaks down when:

- **Multiple screens need the same data.** If the Home screen and Stats screen both display mood entries, how do you keep them in sync?
- **A child widget modifies data that a parent or sibling needs.** You would have to pass callbacks up and down the widget tree.
- **The app grows.** With 10+ screens, passing state through constructors and callbacks becomes unmanageable.

### 1.2 What is Riverpod?

Riverpod is a state management library for Flutter that solves these problems:

| Concept | What it does |
|---------|-------------|
| **Provider** | A container that holds a piece of state and makes it accessible to any widget in the tree. |
| **StateNotifier** | A class that holds state and exposes methods to modify it using immutable updates. |
| **ConsumerWidget** | A widget that can read providers using `ref.watch()` and `ref.read()`. |
| **ProviderScope** | The root widget that stores all provider state. |

### 1.3 ref.watch() vs ref.read()

This distinction is fundamental:

| Method | When to use | Behavior |
|--------|------------|----------|
| `ref.watch(provider)` | In `build()` methods | Rebuilds the widget whenever the provider's state changes. |
| `ref.read(provider)` | In event handlers (onPressed, onSubmitted) | Reads the current value once, does not listen for changes. |

> **Rule of thumb:** `watch` in `build`, `read` in callbacks.

### 1.4 Immutable state updates

Riverpod's `StateNotifier` requires that you **replace** the state rather than **mutate** it:

```dart
// WRONG -- mutating the existing list (StateNotifier will not detect the change)
state.add(newEntry);

// RIGHT -- creating a new list (StateNotifier detects the reassignment)
state = [newEntry, ...state];
```

This is because Riverpod compares object identity (`==`) to decide whether to rebuild widgets. If you mutate the same list in place, the identity does not change, and the UI will not update.

---

### Self-Check: Part 1

Before continuing, make sure you can answer these questions:

- [ ] Why does `setState()` not work well for state shared across screens?
- [ ] What is the difference between `ref.watch()` and `ref.read()`?
- [ ] Why must state updates in `StateNotifier` be immutable?

---

## Part 2: Building the MoodNotifier (~20 min)

Open `lib/providers/mood_provider.dart`. This file will contain all your state management logic.

### 2.1 TODO 1: Implement the MoodNotifier class

Find the `TODO 1` comment block. Your task is to uncomment and complete the `MoodNotifier` class that extends `StateNotifier<List<MoodEntry>>`.

You need to implement:

1. **Constructor** -- Initialize with 2--3 sample `MoodEntry` objects passed to `super([...])`. Use the sample data from the hardcoded list in `home_screen.dart` as reference.

2. **`addMood(int score, String? note)`** -- Create a new `MoodEntry` and prepend it to the list:
   ```dart
   state = [newEntry, ...state];
   ```

3. **`deleteMood(String id)`** -- Remove the entry with the matching id:
   ```dart
   state = state.where((e) => e.id != id).toList();
   ```

4. **`updateMood(String id, int score, String? note)`** -- Replace the matching entry using `copyWith`:
   ```dart
   state = state.map((e) => e.id == id ? e.copyWith(score: score, note: note) : e).toList();
   ```

> **Key insight:** Every method reassigns `state` to a brand-new list. This is the immutable update pattern. Riverpod detects the reassignment and notifies all listening widgets.

### 2.2 TODO 2: Define the providers

Find the `TODO 2` comment block in the same file. Uncomment and complete two providers:

1. **`moodProvider`** -- A `StateNotifierProvider` that creates and exposes the `MoodNotifier`:
   ```dart
   final moodProvider = StateNotifierProvider<MoodNotifier, List<MoodEntry>>((ref) {
     return MoodNotifier();
   });
   ```

2. **`moodStatsProvider`** -- A computed `Provider` that derives statistics from the mood list. It should return a `Map<String, dynamic>` with four keys: `totalEntries`, `averageScore`, `highestScore`, `lowestScore`.

   Use `ref.watch(moodProvider)` inside this provider to access the current mood list. This creates a dependency: whenever `moodProvider` changes, `moodStatsProvider` automatically recalculates.

   Handle the empty-list edge case by returning zeros.

> **Tip:** The app will not compile after completing TODOs 1--2 alone because the providers are referenced in other files. That is expected. Continue to TODO 3 to make the app compilable.

---

### Self-Check: Part 2

- [ ] Your `MoodNotifier` class extends `StateNotifier<List<MoodEntry>>`.
- [ ] The constructor initializes with 2--3 sample entries.
- [ ] All three methods (`addMood`, `deleteMood`, `updateMood`) use immutable state updates.
- [ ] `moodStatsProvider` uses `ref.watch(moodProvider)` to derive its data.

---

## Part 3: Wiring Up Riverpod (~10 min)

### 3.1 TODO 3: Wrap the app with ProviderScope

Open `lib/main.dart`. Find the `TODO 3` comments.

You need to make two changes:

1. **Add the import** at the top of the file:
   ```dart
   import 'package:flutter_riverpod/flutter_riverpod.dart';
   ```

2. **Wrap `runApp()` with `ProviderScope`**:
   ```dart
   runApp(const ProviderScope(child: MoodTrackerApp()));
   ```

`ProviderScope` is the container that stores all your provider state. Without it, any call to `ref.watch()` or `ref.read()` will throw a runtime error.

> **Why at the root?** `ProviderScope` must be an ancestor of every widget that uses providers. Placing it at `runApp()` ensures it covers the entire app.

After this change, try running the app. It should compile and display the same hardcoded data as before (because the screens have not been updated yet).

---

### Self-Check: Part 3

- [ ] The app compiles and runs.
- [ ] `ProviderScope` wraps the entire `MoodTrackerApp`.

---

## Part 4: Reactive UI with ConsumerWidget (~25 min)

Now you will connect the UI to your providers. This is where the app starts feeling reactive.

### 4.1 TODO 4: Make HomeScreen reactive

Open `lib/screens/home_screen.dart`. Find the `TODO 4` comments.

Make these changes:

1. **Add imports** for `flutter_riverpod` and `mood_provider.dart`.
2. **Change `StatelessWidget` to `ConsumerWidget`.**
3. **Add `WidgetRef ref`** as the second parameter to the `build` method:
   ```dart
   Widget build(BuildContext context, WidgetRef ref) {
   ```
4. **Replace the hardcoded list** with a provider read:
   ```dart
   final moods = ref.watch(moodProvider);
   ```
5. **Remove the `_hardcodedMoods` variable** at the bottom of the file (it is no longer needed).

Run the app. The home screen should now display the sample data from your `MoodNotifier` constructor. It looks the same, but the data is now coming from Riverpod.

### 4.2 TODO 5: Wire the Add Mood form

Open `lib/screens/add_mood_screen.dart`. Find the `TODO 5` comments.

This screen uses `StatefulWidget` because it has local form state (the slider value and text field). Riverpod provides a variant for this: `ConsumerStatefulWidget`.

Make these changes:

1. **Add imports** for `flutter_riverpod` and `mood_provider.dart`.
2. **Change `StatefulWidget` to `ConsumerStatefulWidget`.**
3. **Change `State<AddMoodScreen>` to `ConsumerState<AddMoodScreen>`.**
4. **In `_submitMood()`**, replace the SnackBar placeholder with:
   ```dart
   ref.read(moodProvider.notifier).addMood(
     _score,
     _noteController.text.isEmpty ? null : _noteController.text,
   );
   ```

> **Notice:** We use `ref.read()` here, not `ref.watch()`. The submit handler is a one-time action triggered by a button press, not a continuous subscription. Using `ref.watch()` inside a callback would be incorrect.

Run the app and try adding a mood entry. Navigate back to the home screen -- the new entry should appear at the top of the list automatically. This is the power of reactive state management: you did not write any code to refresh the list, Riverpod handled it.

---

### Self-Check: Part 4

- [ ] The home screen displays mood entries from the provider, not hardcoded data.
- [ ] Adding a new mood entry works and the home screen updates automatically.
- [ ] You understand why `ConsumerWidget` is used for HomeScreen and `ConsumerStatefulWidget` for AddMoodScreen.
- [ ] You understand why `ref.watch()` is used in `build()` but `ref.read()` is used in `_submitMood()`.

---

## Part 5: State Mutations from Detail Views (~15 min)

### 5.1 TODO 6: Wire the delete button

Open `lib/screens/mood_detail_screen.dart`. Find the `TODO 6` comments.

Make these changes:

1. **Add imports** for `flutter_riverpod` and `mood_provider.dart`.
2. **Change `StatelessWidget` to `ConsumerWidget`.**
3. **Add `WidgetRef ref`** to the `build` method signature.
4. **In the delete confirmation dialog**, replace the placeholder with:
   ```dart
   ref.read(moodProvider.notifier).deleteMood(entry.id);
   Navigator.pop(context); // close dialog
   Navigator.pop(context); // go back to list
   ```

Run the app. Tap a mood entry to open the detail screen, then tap the delete icon. Confirm the deletion. You should be taken back to the home screen with the entry removed.

> **Two Navigator.pop() calls:** The first closes the confirmation dialog. The second navigates back from the detail screen to the home screen. Without both, the user would be stuck on the detail screen of a deleted entry.

---

### Self-Check: Part 5

- [ ] Deleting a mood entry from the detail screen works.
- [ ] After deletion, the app navigates back to the home screen.
- [ ] The home screen no longer shows the deleted entry.

---

## Part 6: Derived/Computed State (~15 min)

### 6.1 TODO 7: Wire the statistics screen

Open `lib/screens/stats_screen.dart`. Find the `TODO 7` comments.

Make these changes:

1. **Add imports** for `flutter_riverpod` and `mood_provider.dart`.
2. **Change `StatelessWidget` to `ConsumerWidget`.**
3. **Add `WidgetRef ref`** to the `build` method signature.
4. **Replace the hardcoded stats map** with:
   ```dart
   final stats = ref.watch(moodStatsProvider);
   ```

Run the app and navigate to the statistics screen (bar chart icon in the app bar). The stats should reflect the actual mood entries. Now try adding or deleting entries and revisiting the stats screen -- the numbers update automatically.

### 6.2 How derived state works

The `moodStatsProvider` you defined in TODO 2 uses `ref.watch(moodProvider)` internally. This creates a dependency chain:

```
User action (add/delete)
  --> MoodNotifier updates state
    --> moodProvider notifies listeners
      --> moodStatsProvider recalculates
        --> StatsScreen rebuilds with new values
```

You wrote zero synchronization code. Riverpod handles all of it through the provider dependency graph. This is one of the most powerful patterns in state management: **derived state that stays in sync automatically**.

---

### Self-Check: Part 6

- [ ] The statistics screen displays live data from the provider.
- [ ] Adding or deleting entries causes the statistics to update.
- [ ] You can explain how `moodStatsProvider` depends on `moodProvider`.

---

## Part 7: Self-Check and Summary (~10 min)

### 7.1 End-to-end verification

Walk through this complete flow to verify everything works:

1. Launch the app. You should see the sample mood entries on the home screen.
2. Tap the **+** button. Set a score, type a note, and tap **Save Entry**.
3. Verify the new entry appears at the top of the home screen list.
4. Tap the **bar chart** icon to view statistics. Verify the numbers are correct (total entries, average, highest, lowest).
5. Go back and tap a mood entry to view its details.
6. Tap the **delete** icon, confirm deletion.
7. Verify the entry is gone from the home screen.
8. Check the statistics screen again -- the numbers should have updated.

If all 8 steps work correctly, you have completed the lab.

### 7.2 Summary

| TODO | File | What you did |
|------|------|-------------|
| 1 | `providers/mood_provider.dart` | Implemented `MoodNotifier` with `StateNotifier`, sample data, and immutable state update methods. |
| 2 | `providers/mood_provider.dart` | Defined `moodProvider` (StateNotifierProvider) and `moodStatsProvider` (computed Provider). |
| 3 | `main.dart` | Wrapped the app in `ProviderScope` to enable Riverpod. |
| 4 | `screens/home_screen.dart` | Changed to `ConsumerWidget`, replaced hardcoded list with `ref.watch(moodProvider)`. |
| 5 | `screens/add_mood_screen.dart` | Changed to `ConsumerStatefulWidget`, wired submit to `ref.read(moodProvider.notifier).addMood()`. |
| 6 | `screens/mood_detail_screen.dart` | Changed to `ConsumerWidget`, wired delete to `ref.read(moodProvider.notifier).deleteMood()`. |
| 7 | `screens/stats_screen.dart` | Changed to `ConsumerWidget`, replaced hardcoded stats with `ref.watch(moodStatsProvider)`. |

### 7.3 Key concepts learned

| Concept | Key Takeaway |
|---------|--------------|
| State management | Centralized state solves the problem of keeping multiple screens in sync. |
| `StateNotifier` | Holds state and exposes methods for immutable updates via `state = ...`. |
| `StateNotifierProvider` | Makes a `StateNotifier` accessible to any widget via `ref`. |
| Computed `Provider` | Derives new state from existing providers; recalculates automatically. |
| `ConsumerWidget` | Replaces `StatelessWidget` when you need to access providers. |
| `ConsumerStatefulWidget` | Replaces `StatefulWidget` when you need both local state and provider access. |
| `ref.watch()` | Subscribes to a provider in `build()` -- rebuilds widget on changes. |
| `ref.read()` | Reads a provider once in event handlers -- no subscription. |
| `ProviderScope` | Root widget that stores all provider state; required for Riverpod to work. |

---

## What Comes Next

In the following weeks, you will extend this Mood Tracker app:

- **Week 7:** Local persistence with SQLite -- mood entries survive app restarts.
- **Week 8:** Charts and data visualization -- mood trends over time.
- **Week 9:** Polish, testing, and final features.

The Riverpod foundation you built today will remain at the core of the app throughout.

---

## Further Reading

- [Riverpod official documentation](https://riverpod.dev/)
- [Flutter Riverpod package on pub.dev](https://pub.dev/packages/flutter_riverpod)
- [StateNotifier documentation](https://pub.dev/packages/state_notifier)
- [Flutter state management overview](https://docs.flutter.dev/data-and-backend/state-mgmt/intro)
- [Immutable data patterns in Dart](https://dart.dev/effective-dart/design#prefer-making-declarations-using-top-level-variables)
