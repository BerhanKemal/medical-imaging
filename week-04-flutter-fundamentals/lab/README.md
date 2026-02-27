# Week 4 Lab: Flutter Fundamentals

> **Course:** Mobile Apps for Healthcare
> **Duration:** 2 hours
> **Prerequisites:** Dart fundamentals (Week 3)

!!! success "AI tools now allowed"
    Starting this week, you may use AI tools (ChatGPT, Copilot, etc.) to assist your work. However, you must **understand every line of code you submit**. AI is a productivity tool, not a replacement for learning. If you cannot explain what a piece of code does, rewrite it yourself.

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

### 2.3 Exercise files

The exercise projects are provided in the course materials at:

```
week-04-flutter-fundamentals/lab/exercises/
├── exercise_1_hello_flutter/    # Exercise 1: Modify the counter app
├── exercise_2_patient_card/     # Exercise 2: PatientInfoCard
├── exercise_3_mood_selector/    # Exercise 3: Mood Selector
└── exercise_4_health_checkin/   # Exercise 4: Health Check-In Screen
```

Each exercise is a complete Flutter project. Find them in the course materials repository you cloned in Week 0 (see [Getting Ready](../../resources/GETTING_READY.md#step-8-clone-the-course-materials-repository)). Copy the exercise folder to a working directory, open it in your IDE, and run `flutter pub get` before starting.

### 2.4 Exercise 1: Modify the Default Counter App

Open the starter code in **`exercises/exercise_1_hello_flutter/lib/main.dart`**.

Follow the `TODO` comments in the code to:

1. Change the app title to something healthcare-related.
2. Change the primary color theme.
3. Add an icon next to the counter text.
4. Change the floating action button so it **decrements** the counter.

> **Time:** ~10 minutes. Run the app and use hot reload (`r`) after each change to see the results immediately.

### Self-Check: Parts 1–2

- [ ] You created a Flutter project with `flutter create` and can run it on an emulator or device.
- [ ] You can explain what `runApp()` does and why `main()` is the entry point.
- [ ] You understand that **everything on screen is a widget** arranged in a tree.
- [ ] You modified the default counter app and saw changes via hot reload.

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

### Self-Check: Part 3

- [ ] You created a `StatelessWidget` with `final` fields passed via the constructor.
- [ ] You can explain why StatelessWidget properties must be `final`.
- [ ] Your PatientInfoCard displays patient data in a Card widget.

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

### Self-Check: Part 4

- [ ] You created a `StatefulWidget` with the two-class pattern (widget + state).
- [ ] You used `setState()` to update the UI and can explain why it's necessary.
- [ ] You understand that changing a variable **without** `setState()` updates memory but NOT the screen.

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

### Self-Check: Part 5

- [ ] You know when to use hot reload (`r`) vs hot restart (`R`).
- [ ] You tested: changing a Text string → hot reload works; changing a state variable's initial value → requires hot restart.

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

### Self-Check: Part 6

- [ ] Your Health Check-In screen has a `TextField`, a `Slider`, and an `ElevatedButton`.
- [ ] You used `Column`, `Padding`, and `SizedBox` for layout.
- [ ] Tapping the button prints collected data to the console.
- [ ] You can combine `StatelessWidget` and `StatefulWidget` in the same app.

---

## Team Formation

At the end of this lab session, form teams of **3-4 students** for the semester project.

### Steps

1. **Find your teammates.** Look for complementary skills (someone comfortable with UI, someone interested in backend/APIs, someone who likes testing).
2. **Exchange GitHub usernames.** Every team member must have a GitHub account.
3. **Create a team communication channel.** Use whatever platform your team prefers (Discord, Slack, MS Teams, WhatsApp, etc.).
4. **Review the AI tools policy.** A handout is available at [`resources/ai-tools-policy.md`](../../resources/ai-tools-policy.md). Read it together as a team and make sure everyone understands the rules. AI tools are allowed in this course, but specific guidelines apply.

> **Reminder:** Your project proposal is due at the end of Week 5. Start discussing project ideas with your team this week so you arrive at the sprint planning workshop with a clear direction.

---

## Part 7: Team Setup (Homework)

!!! warning "Complete before the Week 5 lab session"
    The following tasks must be done **before** next week's sprint planning workshop. They take ~30 minutes and require all team members to participate.

### 7.1 Create Your Team Repository

One team member creates the repository on GitHub:

1. Click **"New repository"** on GitHub
2. Name it something descriptive (e.g., `mhealth-diabetes-tracker`)
3. Set visibility to **Public** (so the instructor can see it)
4. Initialize with a README
5. Select **Flutter** from the `.gitignore` dropdown

### 7.2 Add Team Members as Collaborators

```
GitHub repo → Settings → Collaborators → Add people
```

Add all team members with **"Write"** access.

### 7.3 Set Up Branch Protection Rules

This is **critical** — it enforces the PR workflow you'll use all semester:

```
GitHub repo → Settings → Branches → Add branch protection rule
```

Configure:

- **Branch name pattern:** `main`
- **Require a pull request before merging:** ✅
- **Require approvals:** 1
- **Do not allow bypassing the above settings:** ✅

### 7.4 Everyone Clones the Repo

Every team member clones and verifies access:

```bash
git clone git@github.com:your-team/your-repo.git
cd your-repo
git remote -v
```

### 7.5 Create a GitHub Projects Board

```
GitHub repo → Projects → New project → Board
```

Create these 5 columns:

1. **Backlog** — all planned work
2. **Sprint Backlog** — work selected for current sprint
3. **In Progress** — actively being worked on
4. **In Review** — PR submitted, waiting for review
5. **Done** — merged to main

> **Verification:** Before Week 5, every team member should be able to push a branch, open a PR, and see the project board. If something doesn't work, fix it now — not during the workshop.

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

## Troubleshooting

??? question "`flutter run` says 'No connected devices'"
    Make sure your emulator is running (launch from Android Studio → AVD Manager) or your physical device has USB debugging enabled. Run `flutter devices` to see what Flutter detects. On macOS, you can also try `open -a Simulator` for the iOS simulator.

??? question "The app builds but shows a blank white screen"
    This usually means there is an error in your widget tree. Check the terminal for error messages (red text). Common causes: missing `const` keyword, incorrect constructor parameters, or a `null` value where a widget is expected.

??? question "`setState()` is called but the UI doesn't update"
    Make sure you are modifying the state variable **inside** the `setState()` callback, not outside it. Also verify you are modifying the correct variable — the one used in the `build()` method.

??? question "Hot reload doesn't apply my changes"
    Some changes require a **hot restart** (`R`) instead of hot reload (`r`). This includes: changes to `main()`, adding/removing state variables, changing initializers, or modifying `const` constructors. When in doubt, press `R`.

??? question "`The method 'setState' isn't defined for the type...`"
    You are calling `setState()` inside a `StatelessWidget`. Only `StatefulWidget` (specifically its `State` class) has `setState()`. Convert your widget to a `StatefulWidget` using the two-class pattern from Part 4.

---

## Further Reading

- [Flutter official documentation — Introduction to widgets](https://docs.flutter.dev/development/ui/widgets-intro)
- [Flutter cookbook — Basic widgets](https://docs.flutter.dev/cookbook)
- [StatefulWidget lifecycle](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)
