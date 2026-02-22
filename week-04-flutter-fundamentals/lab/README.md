# Week 4 Lab: Flutter Fundamentals

> **Course:** Mobile Apps for Healthcare
> **Duration:** 2 hours
> **Prerequisites:** Dart fundamentals (Week 3)

---

## Learning Objectives

By the end of this lab you will be able to:

1. Create a new Flutter project and understand its folder structure.
2. Explain the widget tree and how Flutter renders UI.
3. Build custom `StatelessWidget` and `StatefulWidget` classes.
4. Use `setState()` to update the UI in response to user actions.
5. Combine multiple widgets into a simple healthcare-themed screen.

---

## Prerequisites

Before you begin, make sure you have the following set up on your machine:

- **Flutter SDK** installed and on your PATH. Verify by running:
  ```bash
  flutter doctor
  ```
  All checks should pass (or show only minor warnings unrelated to your target platform).
- **An IDE** — one of:
  - VS Code with the **Flutter** and **Dart** extensions (recommended), or
  - Android Studio with the **Flutter** plugin.
- **A device to run apps on** — one of:
  - An Android emulator (via Android Studio AVD Manager),
  - An iOS simulator (macOS only, via Xcode), or
  - A physical device connected via USB with developer mode enabled.

> **Tip:** If `flutter doctor` reports issues, resolve them now. Ask the instructor for help if needed; do not skip this step.

---

## Part 1: Create Your First Flutter App (~15 min)

### 1.1 Generate the project

Open a terminal and run:

```bash
flutter create my_first_app
cd my_first_app
```

### 1.2 Explore the project structure

Take a minute to look at the generated files:

| Path | Purpose |
|------|---------|
| `lib/main.dart` | Your app's entry point and main source code. |
| `pubspec.yaml` | Project metadata and dependency declarations (like `package.json` in Node or `build.gradle` in Android). |
| `android/` | Android-specific configuration and native code. |
| `ios/` | iOS-specific configuration and native code. |
| `test/` | Unit and widget tests. |

### 1.3 Run the app

```bash
flutter run
```

Once the app launches on your emulator or device:

- Press **`r`** in the terminal for **hot reload** (applies code changes instantly while preserving state).
- Press **`R`** for **hot restart** (restarts the app from scratch, resetting all state).
- Press **`q`** to quit.

### 1.4 Understand the entry point

Open `lib/main.dart`. Notice the two key pieces:

```dart
void main() {
  runApp(const MyApp());
}
```

- **`main()`** — the Dart entry point, just like in any Dart program.
- **`runApp()`** — takes a widget and makes it the root of the widget tree. Flutter then renders this tree on screen.

> **Key insight:** In Flutter, **everything on screen is a widget** — text, buttons, layout containers, even the entire app itself.

---

## Part 2: Understanding Widgets (~25 min)

### 2.1 Everything is a widget

Flutter UIs are built by composing small, reusable widgets into a **widget tree**. The default counter app has a tree that looks roughly like this:

```
MaterialApp
  └── Scaffold
        ├── AppBar
        │     └── Text("Flutter Demo Home Page")
        ├── Body
        │     └── Center
        │           └── Column
        │                 ├── Text("You have pushed...")
        │                 └── Text("$_counter")
        └── FloatingActionButton
              └── Icon(Icons.add)
```

### 2.2 Common basic widgets

| Widget | Purpose | Example |
|--------|---------|---------|
| `Text` | Display a string of text | `Text('Hello')` |
| `Icon` | Display a Material Design icon | `Icon(Icons.favorite)` |
| `Image` | Display an image from assets or network | `Image.network('https://...')` |
| `Container` | A convenience widget for padding, margins, decoration | `Container(color: Colors.blue, child: ...)` |
| `ElevatedButton` | A Material Design raised button | `ElevatedButton(onPressed: ..., child: Text('Tap'))` |

### 2.3 Exercise 1: Modify the Default Counter App

Open the starter code in **`exercises/exercise_1_hello_flutter/lib/main.dart`**.

Follow the `TODO` comments in the code to:

1. Change the app title to something healthcare-related.
2. Change the primary color theme.
3. Add an icon next to the counter text.
4. Change the floating action button so it **decrements** the counter.

> **Time:** ~10 minutes. Run the app and use hot reload (`r`) after each change to see the results immediately.

---

## Part 3: StatelessWidget (~20 min)

### 3.1 What is a StatelessWidget?

A `StatelessWidget` is a widget that **does not change over time**. Once built, its appearance is fixed unless the parent rebuilds it with different data.

Use a `StatelessWidget` when:
- The widget only displays data that is passed in from outside.
- The widget does not need to track any internal changing values.

### 3.2 Anatomy of a StatelessWidget

```dart
class GreetingCard extends StatelessWidget {
  final String name;

  const GreetingCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('Hello, $name!', style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
```

Key points:
- **Properties** are passed via the constructor and stored as `final` fields.
- The **`build()` method** returns a widget tree describing this widget's appearance.
- Every time Flutter needs to display this widget, it calls `build()`.

### 3.3 Exercise 2: PatientInfoCard

Open the starter code in **`exercises/exercise_2_patient_card/lib/main.dart`**.

Your task: create a `PatientInfoCard` StatelessWidget that displays:
- Patient name
- Age
- Diagnosis

Follow the `TODO` comments in the file. When done, the app should display a card with patient information styled in a clean, readable format.

> **Time:** ~15 minutes.

---

## Part 4: StatefulWidget (~30 min)

### 4.1 What is a StatefulWidget?

A `StatefulWidget` is a widget that **can change over time**. It maintains mutable state in a separate `State` object that persists across rebuilds.

Use a `StatefulWidget` when:
- The widget needs to react to user input (taps, typing, sliders).
- The widget displays data that changes dynamically.

### 4.2 The two-class pattern

Every `StatefulWidget` consists of two classes:

```dart
// 1. The widget class — immutable, creates the state
class MoodSelector extends StatefulWidget {
  const MoodSelector({super.key});

  @override
  State<MoodSelector> createState() => _MoodSelectorState();
}

// 2. The state class — mutable, holds changing data
class _MoodSelectorState extends State<MoodSelector> {
  String _selectedMood = 'None';

  @override
  Widget build(BuildContext context) {
    return Text('Current mood: $_selectedMood');
  }
}
```

### 4.3 setState() — triggering a rebuild

To update the UI, you **must** wrap state changes in `setState()`:

```dart
void _selectMood(String mood) {
  setState(() {
    _selectedMood = mood;
  });
}
```

Calling `setState()` tells Flutter: "the state has changed, please call `build()` again so the UI reflects the new data."

> **Warning:** Changing a variable without `setState()` will update the variable in memory but the screen will NOT reflect the change. This is one of the most common beginner mistakes.

### 4.4 Exercise 3: Mood Selector

Open the starter code in **`exercises/exercise_3_mood_selector/lib/main.dart`**.

Your task: build a mood selector with buttons for different moods and a display showing which mood is currently selected. Follow the `TODO` comments.

> **Time:** ~15 minutes.

### 4.5 Bonus: Counter with Increment and Decrement

If you finish early, add decrement functionality to your mood selector file or modify the Exercise 1 counter to support both increment and decrement buttons.

---

## Part 5: Hot Reload vs Hot Restart (~10 min)

### 5.1 Quick comparison

| | Hot Reload (`r`) | Hot Restart (`R`) |
|---|---|---|
| **Speed** | Sub-second | A few seconds |
| **State** | Preserved | Reset |
| **Use when** | Changing UI code, tweaking styles | Changing `main()`, adding new state fields, changing initializers |

### 5.2 When does hot reload NOT work?

Hot reload will not apply changes when you:
- Modify the `main()` function.
- Add or remove state fields in a `State` class.
- Change initializer expressions for fields.
- Change `const` constructors.

In these cases, use **hot restart** (`R`) instead.

### 5.3 Practice

Try the following in any of your exercise files:

1. Change a `Text` widget's string and press `r`. Observe the instant update.
2. Change the initial value of a state variable and press `r`. Notice it does NOT take effect.
3. Press `R` and observe the state variable now uses the new initial value.

---

## Part 6: Building a Simple Screen (~20 min)

### 6.1 Layout essentials

Before starting the final exercise, you need three layout concepts:

| Widget | Purpose | Example |
|--------|---------|---------|
| `Column` | Arrange children **vertically** | `Column(children: [Text('A'), Text('B')])` |
| `Padding` | Add space around a widget | `Padding(padding: EdgeInsets.all(16), child: ...)` |
| `SizedBox` | Fixed-size empty space between widgets | `SizedBox(height: 16)` |

You will also use:
- **`TextField`** — a text input field.
- **`Slider`** — a slider for selecting a numeric value.
- **`ElevatedButton`** — a tappable button.

### 6.2 Exercise 4: Health Check-In Screen

Open the starter code in **`exercises/exercise_4_health_checkin/lib/main.dart`**.

Build a "Health Check-In" screen that combines everything you have learned:
- An `AppBar` with the title "Health Check-In".
- A `TextField` for the patient's name.
- A `Slider` for pain level (1 to 10).
- A `Text` widget that displays the current pain level.
- An `ElevatedButton` that prints the collected data to the console.

This exercise uses both `StatelessWidget` (the overall app shell) and `StatefulWidget` (the form with changing state).

Follow the `TODO` comments in the starter file.

> **Time:** ~20 minutes.

---

## Team Formation

At the end of this lab session, form teams of **3-4 students** for the semester project.

### Steps

1. **Find your teammates.** Look for complementary skills (someone comfortable with UI, someone interested in backend/APIs, someone who likes testing).
2. **Exchange GitHub usernames.** Every team member must have a GitHub account.
3. **Create a team communication channel.** Use whatever platform your team prefers (Discord, Slack, MS Teams, WhatsApp, etc.).
4. **Review the AI tools policy.** A handout is available at [`resources/ai-tools-policy.md`](../../resources/ai-tools-policy.md). Read it together as a team and make sure everyone understands the rules. AI tools are allowed in this course, but specific guidelines apply.

> **Reminder:** Your project proposal is due in Week 5. Start discussing project ideas with your team this week.

---

## Summary

Today you learned:

| Concept | Key Takeaway |
|---------|--------------|
| Project structure | `lib/main.dart` is the entry point; `pubspec.yaml` manages dependencies. |
| Widget tree | Flutter UI = a tree of composable widgets. |
| `StatelessWidget` | Immutable UI — receives data via constructor, no internal state. |
| `StatefulWidget` | Mutable UI — uses `setState()` to trigger rebuilds when state changes. |
| Hot reload / restart | `r` for quick UI tweaks; `R` when state definitions change. |
| Basic layout | `Column`, `Padding`, `SizedBox` for vertical arrangement and spacing. |

---

## Further Reading

- [Flutter official documentation — Introduction to widgets](https://docs.flutter.dev/development/ui/widgets-intro)
- [Flutter cookbook — Basic widgets](https://docs.flutter.dev/cookbook)
- [StatefulWidget lifecycle](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)
