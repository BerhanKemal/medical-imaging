# Week 4 Lab: Instructor Guide

**Course:** Multiplatform Mobile Software Engineering in Practice
**Lab Duration:** 2 hours
**Topic:** Flutter Fundamentals
**Audience:** Familiar with Dart basics from Week 3, first time writing Flutter code

> This document is for the **instructor only**. Students use the separate `README.md` workbook.

---

## Pre-Lab Checklist

Complete these **before students arrive**:

- [ ] Verify Flutter SDK installed on all lab machines (`flutter doctor` -- all checks pass or only minor warnings)
- [ ] Verify an emulator/simulator is available (Android AVD or iOS Simulator)
- [ ] Test that the 4 exercise starter projects compile and run:
  - `exercises/exercise_1_hello_flutter/`
  - `exercises/exercise_2_patient_card/`
  - `exercises/exercise_3_mood_selector/`
  - `exercises/exercise_4_health_checkin/`
- [ ] Have your own IDE open with the exercise projects for live demos
- [ ] Open the student workbook (`README.md`) on the projector
- [ ] Increase IDE/terminal font size to at least 18pt
- [ ] Remind students: AI tools policy starts this week -- AI allowed but with rules (Explain, Teammate, Attribution, Learning)
- [ ] Prepare a list of example project ideas for team formation discussion
- [ ] Have the AI tools policy document (`resources/ai-tools-policy.md`) ready to reference

### Room Setup

- Projector showing your IDE with the exercise projects ready to open
- An emulator or simulator running and visible on the projector
- Students should have their own emulator/simulator launched before you begin
- If lab has a mix of macOS and Windows machines, know which students can use iOS Simulator (macOS only) vs Android AVD (both)

### If Flutter Is Not Installed

If `flutter doctor` shows issues on a student's machine:

1. Check that the Flutter SDK is on the PATH (`which flutter` on macOS/Linux, `where flutter` on Windows)
2. If not installed, download from [flutter.dev](https://flutter.dev/docs/get-started/install) -- this takes 10--15 min and should not happen in the lab
3. If Android SDK is missing, open Android Studio and install it via the SDK Manager
4. If no emulator is available, students can use a physical device connected via USB with developer mode enabled
5. As a last resort, pair the student with a neighbor who has a working setup

---

## Timing Overview

| Time | Duration | Activity | Type |
|------|----------|----------|------|
| 0:00--0:05 | 5 min | Welcome & Flutter overview | Instructor talk |
| 0:05--0:20 | 15 min | Part 1: Create first Flutter app | Follow-along |
| 0:20--0:35 | 15 min | Part 2: Widgets + Exercise 1 | Demo + student work |
| 0:35--0:40 | 5 min | Break / catch-up buffer | --- |
| 0:40--1:00 | 20 min | Part 3: StatelessWidget + Exercise 2 | Demo + student work |
| 1:00--1:30 | 30 min | Part 4: StatefulWidget + Exercise 3 | Demo + student work |
| 1:30--1:35 | 5 min | Break / catch-up buffer | --- |
| 1:35--1:45 | 10 min | Part 5: Hot Reload demo | Demo |
| 1:45--1:55 | 10 min | Exercise 4: Health Check-In | Student work |
| 1:55--2:00 | 5 min | Team formation kickoff | Discussion |

**Total:** 120 minutes (2 hours)

> **Pacing note:** The two 5-minute buffers are critical. The first one comes after the warmup exercises (Parts 1--2), before the conceptually harder StatelessWidget and StatefulWidget sections. The second comes before the final exercise and team formation. Never skip the buffers -- someone always needs them. If everyone is on track, use the time for Q&A or to reinforce concepts.

---

## Detailed Facilitation Guide

### 0:00--0:05 --- Welcome & Flutter Overview (5 min)

**Type:** Instructor talk

**What to say (talking points, not a script):**

- "Today we move from Dart -- the language -- to Flutter -- the framework. This is where things get visual."
- "Flutter lets you build mobile apps for iOS and Android from a single codebase. In healthcare, this means you write your patient-facing app once and deploy it everywhere."
- "The core idea in Flutter is simple: everything on screen is a widget. Text? Widget. Button? Widget. The entire screen? Also a widget."
- "We will build four small exercises today, each introducing a new concept. By the end of the lab, you will have a working Health Check-In screen."
- "AI tools are now allowed starting this week, but with rules. We will review the AI tools policy together at the end of the lab when we form teams."
- "Follow the workbook (`README.md`) step by step. Ask questions at any time."

**What students should be doing:**

- Opening their IDE (VS Code or Android Studio)
- Launching an emulator or connecting a physical device
- Having the workbook open on their screen or on the projector

**Checkpoint:** Before moving on, verify that **every student has an IDE open and an emulator/device running**. Walk around the room if necessary. Students without a working emulator are going to fall behind quickly.

**Common pitfall:** Students who did not install Flutter before the lab. Identify them immediately. If the install cannot be done quickly, pair them with a neighbor. Do not let them sit idle for 15 minutes waiting for a download.

---

### 0:05--0:20 --- Part 1: Create Your First Flutter App (15 min)

**Type:** Follow-along (everyone together)

#### 0:05--0:08 --- `flutter create` (3 min)

**Demo on projector:**

```bash
flutter create my_first_app
cd my_first_app
```

**Have students follow along.** Wait for everyone to finish before continuing.

**What to watch for:**
- Students running `flutter create` in the wrong directory (remind them to `pwd` first)
- Name conflicts if they already have a `my_first_app` folder from pre-lab experimentation
- Windows students may need to use `cd` with backslashes

**Talking point:** "Flutter just generated an entire app for you -- around 80 files. Do not be intimidated. We only care about one file today: `lib/main.dart`."

#### 0:08--0:13 --- Project structure walkthrough (5 min)

**Demo on projector.** Open the project in the IDE and briefly show:

| Path | What to say |
|------|-------------|
| `lib/main.dart` | "This is your app. All your code lives under `lib/`." |
| `pubspec.yaml` | "This is like a package.json or build.gradle. It declares dependencies." |
| `android/` and `ios/` | "Platform-specific config. You rarely touch these directly." |
| `test/` | "We will write tests in later weeks." |

Do not linger here. The goal is orientation, not deep understanding.

#### 0:13--0:20 --- Run the app (7 min)

**Demo on projector:**

```bash
flutter run
```

**Wait for the app to build and launch.** This can take 1--3 minutes on the first run. Use the wait time productively:

- While the build is running, open `lib/main.dart` and point to `void main()` and `runApp()`
- Explain: "`main()` is the Dart entry point. `runApp()` takes a widget and makes it the root of the widget tree."
- "Every pixel on this screen is produced by a widget. The counter, the button, the app bar -- all widgets."

**Once the app launches:**
- Press the floating action button a few times. Show the counter incrementing.
- Press `r` in the terminal for hot reload (nothing changes visually since we have not modified code yet, but show the command)
- Press `q` to quit -- but then immediately re-run with `flutter run` so the app is live for the next section

**What to watch for:**
- Gradle build failures on Android (common causes: missing Android SDK, wrong Java version). Check `flutter doctor` output.
- iOS Simulator not launching (students may need to open Xcode first and accept the license agreement)
- Very slow first build -- reassure students this is normal. Subsequent hot reloads will be instant.

**Checkpoint:** "Does everyone see the counter app running on their emulator or device? Tap the button a few times. If it increments, you are ready."

---

### 0:20--0:35 --- Part 2: Understanding Widgets + Exercise 1 (15 min)

**Type:** Demo (5 min) + student work (10 min)

#### 0:20--0:25 --- Widget Tree Explanation (5 min)

**Demo on projector.** Show the widget tree diagram from the workbook:

```
MaterialApp
  -- Scaffold
       |-- AppBar
       |     -- Text("Flutter Demo Home Page")
       |-- Body
       |     -- Center
       |           -- Column
       |                 |-- Text("You have pushed...")
       |                 -- Text("$_counter")
       -- FloatingActionButton
             -- Icon(Icons.add)
```

**Talking points:**
- "Everything nests inside everything else. This is the widget tree."
- "Scaffold gives you the basic screen structure -- app bar, body, floating action button."
- "Column arranges children vertically. Center centers its child. These are layout widgets."
- "You will get used to reading deeply nested code. It feels strange at first, but it is the Flutter way."

**Show the common widgets table from the workbook:** Text, Icon, Image, Container, ElevatedButton. Do not demo each one individually -- students will use them in the exercises.

#### 0:25--0:35 --- Exercise 1: Modify the Default Counter App (10 min)

**Say:** "Open the starter code in `exercises/exercise_1_hello_flutter/lib/main.dart`. Follow the TODO comments. You have 10 minutes. Use hot reload (`r`) after each change to see the result immediately."

**Walk around the room.** This is a warmup exercise -- most students should complete it quickly.

**What to watch for:**
- Students editing the wrong `main.dart` (the one they created with `flutter create` instead of the exercise starter)
- Students not using hot reload -- they quit and re-run the app for every change
- Students confused by the `const` keyword -- tell them: "For now, use `const` when the IDE suggests it. We will explain it properly soon."

**If a student finishes early:** Suggest they experiment. Change colors, add more icons, try different `Icons.*` values. The goal is to build comfort with editing Flutter code and seeing instant results.

**Checkpoint:** "Who has the app title saying 'Health Counter'? Who changed the color to teal? Who has the heart icon showing above the counter? Who has the decrement button working?"

**Common pitfall:** TODO 4 (decrement button) requires students to both create a `_decrementCounter` method and change the `floatingActionButton`. Some students will create the method but forget to update the button, or vice versa.

---

### 0:35--0:40 --- Break / Catch-Up Buffer (5 min)

- Students who finished Exercise 1: take a real break
- Students who are behind: use this time to catch up on the remaining TODOs
- Walk around and verify everyone has at least the app running with a changed title and color
- If many students are stuck on TODO 4 (decrement), show the solution briefly on the projector
- Answer individual questions

---

### 0:40--1:00 --- Part 3: StatelessWidget + Exercise 2 (20 min)

**Type:** Demo (8 min) + student work (12 min)

**This is the first big concept.** Go slowly here. Students are learning a pattern they will use hundreds of times.

#### 0:40--0:48 --- StatelessWidget Explanation (8 min)

**Demo on projector.** Show the `GreetingCard` example from the workbook:

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

**Walk through each part slowly:**

1. **`extends StatelessWidget`** -- "This tells Flutter: this widget does not change on its own. Once built, it stays the same unless the parent passes different data."

2. **`final String name`** -- "Properties are passed in from outside and stored as `final` fields. Final means they cannot change after construction."

3. **`const GreetingCard({super.key, required this.name})`** -- "The constructor. `required` means the caller must provide this value. `super.key` is boilerplate Flutter needs for widget identity."

4. **`Widget build(BuildContext context)`** -- "This is where you describe what the widget looks like. Flutter calls this method whenever it needs to display the widget."

5. **The return value** -- "You return a tree of other widgets. Here: a Card containing Padding containing Text. Widgets all the way down."

**Healthcare context:** "In a real health app, you would use StatelessWidget for things like a patient info card, a medication label, or a vital sign display -- anything that just shows data without letting the user interact with it."

**Talking point:** "Think of a StatelessWidget like a printed label. You write the information on it once. If you want different information, you print a new label."

#### 0:48--1:00 --- Exercise 2: PatientInfoCard (12 min)

**Say:** "Open `exercises/exercise_2_patient_card/lib/main.dart`. The starter code has the class skeleton with the fields already defined. Your job is to complete the `build` method so it displays the patient's name, age, and diagnosis in a Card. Then add more PatientInfoCard instances in the parent widget. Follow the TODO comments. You have 12 minutes."

**Walk around the room.** This is where the pattern needs to click.

**What to watch for:**
- Students who try to make the widget interactive (adding onPressed, etc.) -- redirect them: "This is a StatelessWidget. It only displays data. Interaction comes in Part 4."
- Students overwhelmed by the nesting (Card > Padding > Column > children) -- encourage them to build one level at a time and hot reload after each addition
- Students forgetting `crossAxisAlignment: CrossAxisAlignment.start` -- the text will be centered by default, which looks wrong for a patient card

**If students are struggling with the build method:** Live-code the first two lines (name and age) on the projector, then let them finish the rest on their own.

**Checkpoint:** "Does your card show a patient name in bold, an age, and a diagnosis? Can you see multiple cards on the screen?"

**Common pitfall:** TODO 5 asks students to add more `PatientInfoCard` instances. Some students will try to put them inside the existing card instead of adding them as siblings in the parent's `Column`.

---

### 1:00--1:30 --- Part 4: StatefulWidget + Exercise 3 (30 min)

**Type:** Demo (12 min) + student work (18 min)

**This is the most important section of the entire lab.** The concept of `setState()` is foundational to everything that follows in the course. Budget extra time here and do not rush.

#### 1:00--1:12 --- StatefulWidget + setState Explanation (12 min)

**Demo on projector.** Walk through the two-class pattern from the workbook:

```dart
// Class 1: The widget itself -- immutable
class MoodSelector extends StatefulWidget {
  const MoodSelector({super.key});

  @override
  State<MoodSelector> createState() => _MoodSelectorState();
}

// Class 2: The state -- mutable, holds changing data
class _MoodSelectorState extends State<MoodSelector> {
  String _selectedMood = 'None';

  @override
  Widget build(BuildContext context) {
    return Text('Current mood: $_selectedMood');
  }
}
```

**Anticipate the question:** "Why two classes? Why not just one?"

**Answer:** "The widget class (`MoodSelector`) is like a blueprint -- Flutter can throw it away and recreate it at any time. The state class (`_MoodSelectorState`) holds the actual data and persists across rebuilds. If they were one class, Flutter would lose your data every time it needed to redraw the widget."

**Draw on the whiteboard (or verbally explain):**

```
MoodSelector (immutable, can be recreated)
    |
    creates
    |
    v
_MoodSelectorState (mutable, persists)
    |
    holds: _selectedMood = 'None'
    |
    build() -> returns widget tree
```

**Now demo `setState()`:**

```dart
void _selectMood(String mood) {
  setState(() {
    _selectedMood = mood;
  });
}
```

**Key teaching moment:** Do a live demo to show what happens with and without `setState()`.

1. First, show the correct version with `setState()`. Tap a button, the text updates.
2. Then, comment out `setState()` and just assign the variable directly:
   ```dart
   void _selectMood(String mood) {
     _selectedMood = mood;  // no setState!
   }
   ```
3. Tap the button. Nothing happens on screen. Add a `debugPrint(_selectedMood)` to show that the variable DID change in memory -- the screen just does not know about it.
4. Restore `setState()`. Tap the button again. It works.

**Say:** "This is the single most common beginner mistake in Flutter. You change a variable, but the screen does not update. 99% of the time, you forgot `setState()`. If your UI seems frozen, check for missing `setState()` first."

**Healthcare context:** "In a health app, setState is how a pain level slider updates the display, how a mood selector shows the current selection, how a symptom checklist marks items as checked. Any time the user interacts and the screen should change -- that is setState."

#### 1:12--1:30 --- Exercise 3: Mood Selector (18 min)

**Say:** "Open `exercises/exercise_3_mood_selector/lib/main.dart`. Build the full mood selector widget: three buttons (Happy, Neutral, Sad) and a text display that shows the selected mood. Follow the TODO comments. You have 18 minutes."

**Walk around the room actively.** This exercise has the most moving parts so far.

**What to watch for:**
- Students who write only one class instead of two -- remind them of the two-class pattern
- Students who forget `setState()` and wonder why the text does not update -- this is the most likely issue
- Students who put the buttons in a `Column` instead of a `Row` -- the workbook says Row, but Column will also work visually. Do not be strict about this.
- Students confused by `ElevatedButton.icon` syntax -- show them the pattern: `ElevatedButton.icon(onPressed: ..., icon: ..., label: ...)`

**If students are struggling:** Live-code the first button (Happy) on the projector, including the `_selectMood` method and `setState()`. Let them add the other two buttons on their own.

**Checkpoint:** "Tap each button. Does the text at the bottom change? If it shows 'You selected: Happy' when you tap Happy, you are done."

**Common pitfall:** Students who put the `_selectMood` method inside the `build` method instead of in the `State` class. This causes a rebuild loop or compilation error. Show them the correct placement: methods go in the State class, at the same level as `build()`.

---

### 1:30--1:35 --- Break / Catch-Up Buffer (5 min)

- Students who finished Exercise 3: take a real break
- Students who are behind: prioritize getting Exercise 3 working -- the `setState()` pattern is the most important concept today
- Walk around and verify that every student has a mood selector that responds to taps
- Quick check: "How many of you have all three mood buttons working? How many have at least the Happy button working?"
- If more than 30% of students are stuck, do a quick walkthrough of the key parts on the projector

---

### 1:35--1:45 --- Part 5: Hot Reload vs Hot Restart (10 min)

**Type:** Demo

**Demo on projector.** Use any of the exercise projects that are still running.

#### Hot Reload (`r`) Demo (4 min)

1. Change a `Text` widget's string (e.g., change "Select your current mood:" to "How are you feeling?")
2. Press `r` in the terminal. Show the instant update -- sub-second.
3. Point out: "The app did not restart. Your selected mood is still showing. State was preserved."

#### Hot Restart (`R`) Demo (3 min)

1. Change the initial value of `_selectedMood` from `''` to `'Happy'`
2. Press `r`. Nothing happens -- the state variable was initialized before the reload.
3. Press `R`. Now the app restarts and the initial value takes effect.
4. Explain: "Hot reload only updates the `build` method. If you change state initialization, constructors, or `main()`, you need hot restart."

#### When Hot Reload Does Not Work (3 min)

**Show the comparison table from the workbook:**

| | Hot Reload (`r`) | Hot Restart (`R`) |
|---|---|---|
| **Speed** | Sub-second | A few seconds |
| **State** | Preserved | Reset |
| **Use when** | Changing UI code, tweaking styles | Changing `main()`, adding new state fields, changing initializers |

**Talking point:** "Hot reload is your best friend during development. It is what makes Flutter feel so fast to work with. You will use it dozens of times per lab session. But when things look wrong and your changes are not taking effect, try hot restart before assuming your code is broken."

**What to watch for:**
- Students who have already been using hot reload throughout the lab -- this section will feel redundant to them. That is fine. Use it as reinforcement.
- Students who have been quitting and re-running the app for every change -- show them how much faster hot reload is

---

### 1:45--1:55 --- Exercise 4: Health Check-In Screen (10 min)

**Type:** Student work

**Say:** "Open `exercises/exercise_4_health_checkin/lib/main.dart`. This exercise combines everything: StatefulWidget, setState, layout widgets, text input, and a slider. Build a Health Check-In screen with a patient name field, a pain level slider, and a submit button. Follow the TODO comments. You have 10 minutes."

**Walk around the room.** This exercise is the most ambitious, and students only have 10 minutes. Set expectations:

**Say:** "If you do not finish in 10 minutes, that is completely fine. The starter code has detailed TODO comments that guide you through every step. You can finish this at home."

**What to watch for:**
- Students who are overwhelmed by the number of widgets -- suggest they tackle one widget at a time (first TextField, then Slider, then Button)
- Students who forget to create a `TextEditingController` -- the starter code should have the TODO hint for this
- Students who forget to call `dispose()` on the controller -- mention it but do not stress it; it is a good practice that becomes critical in larger apps
- Students confused by `Slider` syntax -- show the basic pattern: `Slider(value: ..., min: ..., max: ..., onChanged: ...)`

**If running short on time:** Tell students they can look at the detailed TODO comments in the starter code, which include inline hints that are close to the solution. The priority is to attempt it, not to finish it perfectly.

**Checkpoint:** "Does your screen have a text field, a slider, and a button? Does the slider update the pain level display? If yes, you have the core working."

---

### 1:55--2:00 --- Team Formation Kickoff (5 min)

**Type:** Discussion

**This is critical. Do not skip team formation even if exercises are incomplete.**

**Say:** "We are forming teams for the semester project. Teams of 3--4 students. You will work with this team for the rest of the course."

#### Facilitation Steps

1. **Announce team size:** "3--4 students per team. Not 2, not 5. If you end up with 2, find another pair to join. If you have 5, split into a group of 3 and a group of 2, and the group of 2 finds others."

2. **Encourage diversity of skills:** "Look for complementary strengths. Someone who is comfortable with UI, someone who is interested in backend or APIs, someone who likes testing. Do not just team up with your best friend -- team up with people who bring different skills."

3. **Give 2 minutes for self-selection.** Most students will naturally form groups. Watch for students sitting alone or looking lost.

4. **Assign remaining students.** If anyone is left over, assign them to existing teams that are short a member. Do this quickly and positively: "You three need a fourth -- here is your new teammate."

5. **Exchange information (1 min):**
   - Exchange GitHub usernames
   - Create a team communication channel (Discord, Slack, MS Teams, WhatsApp -- whatever the team prefers)

6. **Review AI tools policy (1 min):**
   - Point to `resources/ai-tools-policy.md`
   - Summarize the four rules: Explain (you must understand what AI generates), Teammate (AI is a pair-programming partner, not a replacement), Attribution (cite AI usage), Learning (use AI to learn, not to avoid learning)
   - "Read the full policy with your team before next week."

7. **Project ideas (1 min):**
   - Share example ideas: medication reminder, symptom tracker, exercise logger, blood pressure diary, mental health check-in, diabetes management
   - "Your project proposal is due in Week 5. Start discussing ideas this week."

**What to watch for:**
- Students who are shy or do not know anyone in the class -- actively help them find a team
- Teams that are all one skill level -- gently suggest mixing experienced and less experienced students
- Students who want to work alone -- this is a team project, gently insist on teams

---

## Complete Exercise Solutions

Below are the full solutions for every exercise. Use these if you need to quickly show a solution on the projector or help a struggling student.

### Exercise 1 Solution -- Modify the Default Counter App

**File:** `exercises/exercise_1_hello_flutter/lib/main.dart`

The starter code has TODO 1--4. Here are the solutions for each:

```dart
// TODO 1: Change the app title to something healthcare-related
title: 'Health Counter',
// ...
home: const MyHomePage(title: 'Health Counter'),

// TODO 2: Change the color scheme seed color
colorSchemeSeed: Colors.teal,

// TODO 3: Add an icon above the counter text
Icon(Icons.favorite, color: Colors.red, size: 48),

// TODO 4: Create a decrement method and update the FAB
void _decrementCounter() {
  setState(() {
    _counter--;
  });
}

// In the build method, update the floatingActionButton:
floatingActionButton: FloatingActionButton(
  onPressed: _decrementCounter,
  tooltip: 'Decrement',
  child: const Icon(Icons.remove),
),
```

### Exercise 2 Solution -- PatientInfoCard (StatelessWidget)

**File:** `exercises/exercise_2_patient_card/lib/main.dart`

The starter code has the class skeleton with fields defined. Students complete the build method:

```dart
class PatientInfoCard extends StatelessWidget {
  final String name;
  final int age;
  final String diagnosis;

  const PatientInfoCard({
    super.key,
    required this.name,
    required this.age,
    required this.diagnosis,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Age: $age'),
            const SizedBox(height: 8),
            Text('Diagnosis: $diagnosis'),
          ],
        ),
      ),
    );
  }
}
```

For TODO 5 (adding more cards), students add additional instances in the parent widget's Column:

```dart
Column(
  children: [
    PatientInfoCard(name: 'Anna Kowalska', age: 34, diagnosis: 'Hypertension'),
    PatientInfoCard(name: 'Jan Nowak', age: 58, diagnosis: 'Type 2 Diabetes'),
    PatientInfoCard(name: 'Maria Wisniewska', age: 45, diagnosis: 'Asthma'),
  ],
)
```

### Exercise 3 Solution -- Mood Selector (StatefulWidget)

**File:** `exercises/exercise_3_mood_selector/lib/main.dart`

Students implement the full StatefulWidget with the two-class pattern:

```dart
class _MoodSelectorState extends State<MoodSelector> {
  String _selectedMood = '';

  void _selectMood(String mood) {
    setState(() {
      _selectedMood = mood;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Select your current mood:',
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () => _selectMood('Happy'),
              icon: const Icon(Icons.sentiment_very_satisfied),
              label: const Text('Happy'),
            ),
            ElevatedButton.icon(
              onPressed: () => _selectMood('Neutral'),
              icon: const Icon(Icons.sentiment_neutral),
              label: const Text('Neutral'),
            ),
            ElevatedButton.icon(
              onPressed: () => _selectMood('Sad'),
              icon: const Icon(Icons.sentiment_very_dissatisfied),
              label: const Text('Sad'),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Text(
          _selectedMood.isEmpty
              ? 'No mood selected yet.'
              : 'You selected: $_selectedMood',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
```

### Exercise 4 Solution -- Health Check-In Screen

**File:** `exercises/exercise_4_health_checkin/lib/main.dart`

Students build a complete screen combining TextField, Slider, and ElevatedButton:

```dart
class _HealthCheckInScreenState extends State<HealthCheckInScreen> {
  final TextEditingController _nameController = TextEditingController();
  double _painLevel = 5.0;

  void _submit() {
    debugPrint('Patient: ${_nameController.text}');
    debugPrint('Pain level: ${_painLevel.round()}');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Check-In'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Patient Name',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter patient name',
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Pain Level: ${_painLevel.round()}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Slider(
                value: _painLevel,
                min: 1,
                max: 10,
                divisions: 9,
                label: _painLevel.round().toString(),
                onChanged: (value) {
                  setState(() {
                    _painLevel = value;
                  });
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Submit Check-In',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## Instructor Notes: Pacing & Common Issues

### Where Students Typically Get Stuck

1. **Flutter SDK not properly installed.** `flutter doctor` shows issues with Android SDK, missing licenses, or no connected device. This can eat 15+ minutes if it happens to multiple students. Identify and triage these students in the first 5 minutes. If the fix is not quick, pair them with a neighbor.

2. **No emulator available.** Students who do not have Android Studio installed or cannot launch iOS Simulator. Help them set up an Android AVD or use a physical device via USB. If neither option works quickly, pair them with a neighbor.

3. **StatefulWidget two-class pattern is confusing.** "Why two classes? Why not just one?" This is the most common conceptual question. Use the analogy: "The widget is a blueprint. The state is the actual building. Flutter can throw away and recreate blueprints anytime, but the building stays."

4. **Forgetting `setState()`.** The UI does not update and students think the code is broken. This is the #1 practical mistake. Demo the before/after explicitly (with and without `setState`). When helping a stuck student, check for missing `setState()` first.

5. **Widget tree nesting.** Deep indentation is overwhelming at first. Students see 4--5 levels of nesting and freeze. Encourage them to build one level at a time: "First create the Column. Hot reload. Then add the first Text child. Hot reload. Then add the next child."

6. **`const` constructors.** Students are unsure when to use `const`. For this lab, the simple rule is: "Use `const` when the IDE underlines it and suggests it. If it compiles, you are fine. We will explain the nuances later."

### Where to Slow Down

- **The first StatelessWidget explanation (Exercise 2).** This is the pattern they will use for the rest of the course. Walk through every line. Make sure they understand what `build()` does and why properties are `final`.

- **The first `setState()` demo (Exercise 3).** This is the key concept of the entire lab. Do the live demo showing what happens without `setState()`. Let it sink in. Ask questions: "What do you think will happen if I remove `setState()` here?"

- **Hot reload vs hot restart (Part 5).** Demo this clearly with a concrete example. The distinction between "state-preserving reload" and "full restart" is important for their daily workflow.

### Where You Can Speed Up

- **Project creation (`flutter create`).** This is mechanical. Just have everyone follow along. No need to explain every generated file.

- **Hot reload section (Part 5).** If students have already been using hot reload throughout the lab (which they should have), this section is reinforcement. You can compress it to 5 minutes if needed.

- **Exercise 4 if running short.** Students can look at the detailed TODO comments in the starter code, which provide step-by-step hints. They can also finish this at home.

### If You Are Running Out of Time

Priority order (must complete):

1. **Exercise 1 (modify counter)** -- warmup exercise, gets students comfortable editing Flutter code. Must do.
2. **Exercise 2 (StatelessWidget)** -- foundational pattern. Must do.
3. **Exercise 3 (StatefulWidget + setState)** -- the most important concept in the lab. Must do.
4. **Team formation** -- CRITICAL. Do not skip this even if exercises are incomplete. Students need teams formed before Week 5.
5. **Exercise 4** -- can be assigned as homework.

Can be shortened:
- Part 1 project structure walkthrough (reduce from 5 min to 2 min)
- Part 5 hot reload demo (reduce from 10 min to 5 min)
- Exercise 4 (reduce from 10 min to 5 min, or assign as homework)

### If You Have Extra Time

- Have students add a "Reset" button to the mood selector (Exercise 3) that clears the selection
- Ask students to add a `Row` with both increment and decrement buttons to the counter app
- Show Flutter DevTools and the widget inspector -- let students see the widget tree visually
- Discuss how the Health Check-In screen (Exercise 4) would look in a real clinical app -- what additional fields would you need? (vitals, symptoms, medication compliance)
- Let students explore `Icons.*` to find healthcare-related icons and customize their apps

### Recovery Strategies

**If many students cannot get Flutter running (first 15 min):**
- Switch to a "follow along on the projector" mode for Part 1
- Dedicate the first buffer (0:35--0:40) entirely to helping students fix their setup
- Consider pairing students who have a working setup with those who do not

**If Exercise 3 (setState) is taking too long:**
- Live-code the entire solution on the projector at the 20-minute mark
- Have students type it in rather than figure it out independently
- The goal is understanding, not independent discovery -- they need to see `setState()` working

**If team formation is chaotic:**
- Have a list of students ready and pre-assign teams if self-selection is not working
- Post team assignments on the course platform after the lab if needed
- The important thing is that every student knows their team before they leave

---

## Team Formation Facilitation Notes

### Logistics

- **Ideal team size:** 3--4 students
- **Encourage diversity of skills:** UI-focused, backend-focused, testing-focused. Students who are stronger in programming should be spread across teams, not concentrated in one.
- **If students cannot form teams:** Assign remaining students to teams that need members. Do this positively and quickly.
- **Exchange GitHub usernames:** Every team member must have a GitHub account. If someone does not have one, they should create it before the next lab.
- **Create team chat channel:** Suggest Discord, Slack, or MS Teams. Whatever the team agrees on.
- **Review AI tools policy together:** Point to `resources/ai-tools-policy.md`. Each team should read it together and agree to follow the rules.
- **Remind about project proposal:** Due in Week 5. Teams should start brainstorming this week.

### Example Project Ideas to Share

Offer these as inspiration, not as a fixed list:

- **Medication reminder app** -- schedule and track medication doses, send notifications
- **Symptom tracker** -- log daily symptoms with severity, visualize trends over time
- **Exercise logger** -- record workouts with duration and intensity, track weekly goals
- **Blood pressure diary** -- log systolic/diastolic readings, chart history, flag abnormal values
- **Mental health check-in** -- daily mood logging with journaling, weekly mood summaries
- **Diabetes management** -- blood glucose logging, meal tracking, insulin dose calculator

**Say:** "These are starting points. Your project should solve a real problem that matters to you or someone you know. The best projects come from genuine interest."

---

## End-of-Lab Assessment

### Minimum Completion Checklist

Every student should leave the lab with:

- [ ] Flutter app runs on emulator/device
- [ ] Completed Exercise 1 (modified counter app with healthcare theme)
- [ ] Built a StatelessWidget (Exercise 2 -- PatientInfoCard)
- [ ] Built a StatefulWidget with setState (Exercise 3 -- Mood Selector)
- [ ] Understands hot reload vs hot restart
- [ ] Team formed (3--4 students) with GitHub usernames exchanged
- [ ] AI tools policy reviewed as a team

### Quick Verification Method

In the last 2 minutes before team formation, ask students to show their mood selector (Exercise 3):

1. Tap "Happy" -- does the text update?
2. Tap "Sad" -- does it change?
3. If yes, the student understands `setState()` and has a working StatefulWidget.

Students who can demonstrate this have grasped the core concept of the lab.

### For Students Who Did Not Finish

- Reassure them: "You have the workbook and the starter code. Follow the TODO comments at home."
- Minimum viable: Exercises 1--3 completed. Exercise 4 can be finished at home.
- Remind them that next week builds on these fundamentals -- they should be comfortable with StatelessWidget and StatefulWidget before Week 5.
- Point them to the Flutter documentation: [flutter.dev/docs](https://flutter.dev/docs) and the widget catalog.
- Offer office hours or the team communication channel for questions.
