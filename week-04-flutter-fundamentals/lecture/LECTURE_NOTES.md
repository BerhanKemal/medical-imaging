# Week 4 Lecture: Widget Lifecycle, State Basics & Project Kickoff

**Course:** Multiplatform Mobile Software Engineering in Practice
**Duration:** ~2 hours (including Q&A)
**Format:** Student-facing notes with presenter cues

> Lines marked with `> PRESENTER NOTE:` are for the instructor only. Students can
> ignore these or treat them as bonus context.

---

## Table of Contents

1. [Widget Lifecycle Deep Dive](#1-widget-lifecycle-deep-dive-25-min) (25 min)
2. [State -- A Conceptual Foundation](#2-state-a-conceptual-foundation-20-min) (20 min)
3. [The Widget Tree in Depth](#3-the-widget-tree-in-depth-15-min) (15 min)
4. [Project Kickoff -- From Idea to App](#4-project-kickoff-from-idea-to-app-15-min) (15 min)
5. [From Prototype to Product -- The Healthcare Path](#5-from-prototype-to-product-the-healthcare-path-10-min) (10 min)
6. [Key Takeaways](#6-key-takeaways-5-min) (5 min)

---

## 1. Widget Lifecycle Deep Dive (25 min)

### What Happens When Flutter Renders Your Widgets?

In the lab, you built widgets with `StatelessWidget` and `StatefulWidget`. You used `setState()` to update the UI, created a `TextEditingController` for the health check-in form, and wired up buttons to change the selected mood. Now let's understand the lifecycle behind them -- what Flutter actually does from the moment a widget appears on screen to the moment it is removed.

Understanding the lifecycle is not just academic curiosity. When you know *when* each method is called and *why*, you can make better decisions about where to put your code. Load data in the right place. Clean up resources at the right time. Avoid bugs that only show up after you navigate away from a screen and come back.

### StatelessWidget: The Simple Case

A `StatelessWidget` has the simplest lifecycle of any widget. It goes through exactly two steps:

1. **Constructor** -- Flutter creates an instance of the widget, passing in any required data (the constructor parameters you marked as `final`).
2. **`build()`** -- Flutter calls `build()` to get the widget tree that this widget represents.

That is it. There is no `initState`, no `dispose`, no cleanup. The widget receives its data, builds its UI, and is done.

But here is the catch: "done" does not mean "never called again." If the *parent* widget rebuilds, it may create a new instance of your `StatelessWidget` with different data. When that happens, Flutter creates a new widget object and calls `build()` again.

This is why all properties on a `StatelessWidget` must be `final` -- they cannot change once set. If the data needs to change, the parent creates a brand new widget with new values.

**Think of it this way:** A `StatelessWidget` is like a printed medical label. Once printed, the label does not change. If the patient's information updates, you print a new label entirely. You do not erase and rewrite on the old one.

> PRESENTER NOTE: This is a good place to revisit Exercise 2 from the lab. The
> `PatientInfoCard` was a StatelessWidget. Its name, age, and diagnosis were passed
> in from the parent and never changed internally. Ask: "Could you have used a
> StatefulWidget for the patient card? Yes, but why would you? There was nothing
> to change."

### StatefulWidget: The Full Lifecycle

A `StatefulWidget` is where things get interesting. Unlike a `StatelessWidget`, it maintains mutable state that can change over time and trigger UI updates. This requires a more involved lifecycle.

Here is the complete picture:

```d2
direction: down

title: "StatefulWidget Lifecycle" {
  style.fill: "#F5F5F5"
  style.font-size: 20

  create: "createState()" {style.fill: "#E3F2FD"}
  init: "initState()" {style.fill: "#C8E6C9"}
  deps: "didChangeDependencies()" {style.fill: "#FFF9C4"}
  build: "build()" {style.fill: "#BBDEFB"; style.bold: true}
  update: "didUpdateWidget()" {style.fill: "#FFF9C4"}
  dispose: "dispose()" {style.fill: "#FFCDD2"}

  create -> init: ""
  init -> deps: ""
  deps -> build: ""
  build -> update: "parent rebuilds\nwith new config"
  update -> build: ""
  build -> dispose: "widget removed"

  setState: "setState()" {style.fill: "#FFE0B2"; style.bold: true}
  setState -> build: "triggers rebuild"
  build -> setState: "" {style.stroke-dash: 3}

  init_note: |md
    Called **ONCE**. Set up initial state,
    start streams, create controllers.
  |

  build_note: |md
    Called **MANY** times.
    Must be fast and side-effect-free.
  |

  dispose_note: |md
    Called **ONCE**. Clean up everything:
    controllers, listeners, streams.
  |
}
```

Let's walk through each step.

#### createState()

When Flutter encounters a `StatefulWidget` in the widget tree for the first time, it calls `createState()`. This is the factory method you write -- it returns an instance of your `State` class. You saw this pattern in every exercise:

```dart
@override
State<MoodSelector> createState() => _MoodSelectorState();
```

This method is called exactly once per position in the widget tree. The resulting `State` object will persist even as the widget itself may be recreated.

#### initState()

Called exactly once, right after `createState()`. This is where you set up anything that needs to happen once when the widget first appears:

- Create controllers (`TextEditingController`, `AnimationController`)
- Start listening to streams
- Load initial data
- Set up subscriptions

In Exercise 4, you created a `TextEditingController`. The right place for that was in `initState()` (or as a field initializer, which Dart evaluates at the same time). The key point: this code runs once, not on every rebuild.

```dart
@override
void initState() {
  super.initState();
  _nameController = TextEditingController();
  // Start listening to a data stream, load saved preferences, etc.
}
```

Always call `super.initState()` first. The framework depends on it.

#### build()

The most important method. Called many times -- potentially dozens or hundreds of times during the widget's lifetime. Flutter calls `build()` whenever:

1. You call `setState()`
2. The parent widget rebuilds and passes new configuration
3. An `InheritedWidget` that this widget depends on changes (we will cover this in a later week)

Because `build()` runs so often, it must follow two rules:

- **Be fast.** Do not perform expensive calculations, network requests, or file I/O in `build()`. If building your widget takes too long, the UI will stutter.
- **Be pure.** Given the same state, `build()` should always return the same widget tree. No side effects -- do not start HTTP requests, write to databases, or print debug output inside `build()`.

**Analogy:** Think of `build()` as a doctor filling out a patient chart. Every time the patient's vitals change, the doctor rewrites the chart. The chart itself is cheap to produce -- it is just a description. The expensive work (actually treating the patient) happens elsewhere. Similarly, `build()` just describes the UI. The expensive rendering work is handled by Flutter's rendering engine.

> PRESENTER NOTE: Live code demo -- open one of the lab exercises (Exercise 3 or 4)
> and add `debugPrint('build called')` inside `build()`, `debugPrint('initState called')`
> inside `initState()`, and `debugPrint('dispose called')` inside `dispose()`. Run the
> app and tap buttons to trigger setState. Show how build is called multiple times while
> initState only runs once. Then navigate away from the screen (if there is navigation)
> to trigger dispose. This makes the lifecycle concrete and visible.

#### setState()

You used `setState()` in every stateful exercise. Now you know what it actually does: it marks the widget as "dirty" and schedules a call to `build()`. The callback you pass to `setState()` is where you update your state variables:

```dart
void _selectMood(String mood) {
  setState(() {
    _selectedMood = mood;
  });
}
```

A common beginner mistake is changing the variable *without* calling `setState()`. The variable updates in memory, but Flutter does not know about it, so the UI stays stale. You might have encountered this in the lab if you forgot to wrap changes in `setState()`.

The opposite mistake is less obvious but equally important: calling `setState()` when nothing actually changed. This causes unnecessary rebuilds and wastes CPU cycles. In a simple counter app, this does not matter. In a complex healthcare dashboard with charts, patient lists, and real-time vitals, unnecessary rebuilds can cause visible frame drops.

#### dispose()

Called exactly once, when the widget is permanently removed from the tree. This is your cleanup opportunity:

- Dispose controllers (`TextEditingController`, `AnimationController`, `ScrollController`)
- Cancel stream subscriptions
- Remove listeners
- Close database connections

```dart
@override
void dispose() {
  _nameController.dispose();
  super.dispose();
}
```

In Exercise 4, the optional TODO asked you to dispose the `TextEditingController`. This was not optional in spirit -- in a real app, forgetting to dispose a controller leaks memory.

Always call `super.dispose()` last. This is the mirror of `initState()`, where you call `super.initState()` first.

### Why dispose() Matters in Healthcare Apps

Consider a patient monitoring application. When a nurse opens a patient's detail screen, the app might:

- Start a Bluetooth Low Energy (BLE) connection to the bedside monitor
- Subscribe to a real-time vitals stream (heart rate, SpO2, blood pressure)
- Begin writing data to a local database for offline access

If the nurse navigates away and `dispose()` does not clean up these resources:

- The BLE connection stays open, draining the tablet's battery
- The vitals stream keeps running in the background, consuming memory and CPU
- The database write operations continue with nowhere to send the data

In a consumer app, this might mean slightly worse battery life. In a hospital app running on a shared tablet during a 12-hour shift, it means the device dies halfway through the shift. `dispose()` is not a formality -- it is a safety practice.

### When Does Rebuild Happen? -- A Summary

```d2
direction: down

triggers: "What triggers build()?" {
  style.fill: "#E3F2FD"
  style.font-size: 20

  s1: "1. setState()" {style.fill: "#FFF9C4"}
  s1_desc: "You explicitly asked for it" {style.fill: "transparent"; style.stroke: "transparent"}

  s2: "2. Parent rebuilds" {style.fill: "#FFF9C4"}
  s2_desc: "Parent created a new instance\nof this widget with new data" {style.fill: "transparent"; style.stroke: "transparent"}

  s3: "3. InheritedWidget changes" {style.fill: "#FFF9C4"}
  s3_desc: "A dependency higher in the tree\nchanged (e.g., Theme, MediaQuery, Locale)" {style.fill: "transparent"; style.stroke: "transparent"}

  s1 -> s1_desc: "" {style.stroke: "transparent"}
  s2 -> s2_desc: "" {style.stroke: "transparent"}
  s3 -> s3_desc: "" {style.stroke: "transparent"}
}
```

The first one is within your control. The second and third happen automatically. This is why `build()` must always be fast -- you cannot predict exactly when or how often it will be called.

> PRESENTER NOTE: Ask students: "In your health check-in form from Exercise 4, what
> triggered rebuild?" Answer: calling setState inside the Slider's onChanged callback.
> Every time the slider moved, setState was called, build ran again, and the Text widget
> showing the pain level updated. This could be dozens of times per second if the user
> drags the slider slowly.

---

## 2. State -- A Conceptual Foundation (20 min)

### What Is "State"?

In the broadest sense, **state** is any data that can change over time and affects what the UI displays. If something on screen can change after the initial render, there is state behind it.

In the lab, you worked with state in every exercise:

- Exercise 1: The counter value (`_counter`) -- changes when you tap the button
- Exercise 3: The selected mood (`_selectedMood`) -- changes when you tap a mood button
- Exercise 4: The pain level (`_painLevel`) -- changes as you drag the slider
- Exercise 4: The patient name -- changes as the user types in the TextField

All of these are examples of state. But not all state is created equal.

### Two Kinds of State

Flutter developers (and the Flutter documentation) distinguish between two categories of state. Understanding this distinction early will save you significant confusion later.

#### Ephemeral (Local) State

Ephemeral state belongs to a single widget. No other widget needs to know about it. It lives and dies with that one widget.

Examples from your lab work:

- `_selectedMood` in the MoodSelector widget -- only that widget cares which mood is selected
- `_painLevel` in the health check-in form -- only the slider and its label need this value
- The current page index in a bottom navigation bar
- Whether a dropdown is open or closed
- The current value of an animation

Ephemeral state is managed with `setState()` inside a `StatefulWidget`. This is what you have been doing in the lab, and for these cases, it is the right tool.

#### App State (Shared State)

App state is data that multiple widgets, multiple screens, or the entire application needs to access. It cannot live inside a single widget because other parts of the app need it too.

Examples in a healthcare context:

- The currently logged-in user (displayed in the app bar, used for API calls, checked on every screen)
- A list of patient records (displayed on the list screen, the detail screen, and the search screen)
- The user's mood history (shown on the log screen, the calendar view, and the statistics chart)
- Authentication tokens (needed for every API request, from any screen)
- App settings and preferences (dark mode, notification preferences, language)

You cannot manage app state with `setState()` because `setState()` only rebuilds a single widget. If the patient list changes, you need *every* screen that shows patient data to update -- not just the one where the change happened.

### The Mental Model

```d2
direction: right

ephemeral: "Ephemeral State\n(single widget owns it)" {
  style.fill: "#E3F2FD"
  widget: "MoodSelector" {
    style.fill: "#BBDEFB"
    mood: "_mood = happy"
    action: "setState()\nrebuilds THIS\nwidget only"
  }
}

app: "App State\n(shared across many widgets)" {
  style.fill: "#E8F5E9"
  store: "State Store\n(centralized)" {
    style.fill: "#C8E6C9"
    data: |md
      patientList: [..]
      currentUser: {...}
      moodEntries: [..]
    |
    behavior: |md
      When state changes,
      ALL widgets that depend
      on it are notified
      and rebuild.
    |
  }
}
```

### The setState() Problem

Imagine you are building a mood tracking app (which you will be, for your project). The app has three screens:

1. **Log screen** -- where the user enters today's mood
2. **History screen** -- shows a list of all past mood entries
3. **Stats screen** -- shows charts and trends

When the user logs a new mood on screen 1, screens 2 and 3 need to update. But `setState()` only works within one widget. Screen 1 cannot call `setState()` on screen 2.

You could try passing callbacks up and down the widget tree, but this quickly becomes unmanageable. What if screens 2 and 3 are deeply nested? What if you add a fourth screen? The callback chain becomes a tangled mess.

This is the fundamental problem that state management solutions exist to solve. They provide a way for widgets to:

1. **Read** shared data from a central source
2. **Write** changes to that central source
3. **React** automatically when the data changes -- no matter which widget made the change

### A Preview of What's Coming

In Week 6, we will introduce **Riverpod** -- the state management solution we will use for the rest of the course. Riverpod lets you define "providers" that hold app state, and any widget anywhere in the tree can listen to them:

```dart
// Define a provider (Week 6)
final moodEntriesProvider = StateNotifierProvider<MoodNotifier, List<MoodEntry>>(...);

// Any widget can read it
final entries = ref.watch(moodEntriesProvider);

// Any widget can update it
ref.read(moodEntriesProvider.notifier).addEntry(newEntry);
```

For now, do not worry about the syntax. The concept is what matters: there will be a clean way to share state across your entire app without passing callbacks through every widget.

> PRESENTER NOTE: Ask students: "In your team's app idea, what data is ephemeral and
> what is app state?" Have 2-3 teams share their answers. This builds intuition for
> Week 6. Common answers might include: "the login form fields are ephemeral, but the
> user's session is app state" or "the search query is ephemeral, but the search results
> need to be shared."

### The Rule of Thumb

If you are unsure whether something is ephemeral or app state, ask yourself: **"If I completely destroy this widget and recreate it, should this data persist?"**

- If yes -- it is app state (store it outside the widget)
- If no -- it is ephemeral state (keep it in the widget with `setState()`)

The slider position in your health check-in form? Ephemeral -- if you leave the screen and come back, starting at 5 is fine. The list of all submitted check-ins? App state -- you definitely do not want to lose those.

---

## 3. The Widget Tree in Depth (15 min)

### Everything Is a Tree

You have been composing widgets by nesting them inside each other since the first exercise. A `Scaffold` contains a `Column`, which contains `Text` and `Button` widgets. This nesting forms a **tree structure** -- the widget tree.

But here is something most beginners do not realize: Flutter actually maintains **three** parallel trees, not one. Understanding these three trees helps you reason about performance, understand why `const` constructors matter, and debug rendering issues.

### The Three Trees

```d2
direction: right

widget: "Your Code\n(Widget Tree)" {
  style.fill: "#E3F2FD"
  app: "MaterialApp"
  scaffold: "Scaffold"
  appbar: "AppBar"
  column: "Column"
  text: "Text"
  button: "Button"
  app -> scaffold
  scaffold -> appbar
  scaffold -> column
  column -> text
  column -> button

  note: "Lightweight,\nimmutable\ndescriptions" {style.fill: "transparent"; style.stroke: "transparent"}
}

element: "Flutter Internal\n(Element Tree)" {
  style.fill: "#FFF9C4"
  e1: "Element"
  e2: "Element"
  e3: "Element"
  e4: "Element"
  e5: "Element"
  e6: "Element"
  e1 -> e2
  e2 -> e3
  e2 -> e4
  e4 -> e5
  e4 -> e6

  note: "Persistent,\ntracks identity\nand lifecycle" {style.fill: "transparent"; style.stroke: "transparent"}
}

render: "Actual Rendering\n(RenderObject Tree)" {
  style.fill: "#E8F5E9"
  r1: "RenderObject"
  r2: "RenderBox"
  r3: "Render"
  r4: "Render"
  r5: "Render"
  r6: "Render"
  r1 -> r2
  r2 -> r3
  r2 -> r4
  r4 -> r5
  r4 -> r6

  note: "Expensive,\nhandles layout\nand painting" {style.fill: "transparent"; style.stroke: "transparent"}
}

widget -> element: "==>"
element -> render: "==>"
```

#### Tree 1: The Widget Tree (Your Code)

This is what you write. Widgets are **lightweight, immutable descriptions** of the UI. They are cheap to create and cheap to throw away. When `build()` runs, it creates a fresh widget tree every time.

Think of widgets as **blueprints**. A blueprint for a hospital room describes what should be there (a bed, a monitor, a nurse call button) but is not the room itself. You can print a hundred copies of the blueprint cheaply. Building the actual room is the expensive part.

#### Tree 2: The Element Tree (Flutter's Bookkeeping)

The element tree is Flutter's internal tracking system. Each element corresponds to a widget and maintains:

- A reference to the current widget (the configuration)
- A reference to the render object (the actual rendered output)
- The position in the tree
- The `State` object (for `StatefulWidget` elements)

When `build()` returns a new widget tree, Flutter does not throw everything away and start over. Instead, it **walks the element tree** and compares the old widgets with the new ones:

- **Same type, same key?** Update the existing element with the new widget's configuration.
- **Different type?** Remove the old element and create a new one.

This is how Flutter achieves its performance: it only creates new render objects when the widget *type* changes, not when the widget *data* changes.

#### Tree 3: The RenderObject Tree (The Actual Pixels)

Render objects handle the expensive work: calculating layout (size and position) and painting pixels to the screen. Creating and updating render objects is costly, which is why Flutter tries to reuse them as much as possible via the element tree.

You will rarely interact with render objects directly. But knowing they exist helps you understand why Flutter is fast: the lightweight widget tree changes frequently, but the expensive render tree changes only when necessary.

### Why const Constructors Matter

You have seen `const` scattered throughout Flutter code:

```dart
const Text('Hello')
const SizedBox(height: 16)
const EdgeInsets.all(24.0)
```

A `const` constructor creates a compile-time constant. This means:

1. **Only one instance exists** -- if you write `const Text('Hello')` in ten places, Dart reuses the same object in memory.
2. **Flutter can skip it during diffing** -- if a widget is `const`, Flutter knows it cannot possibly have changed, so it skips comparing it entirely.

In a small app, this makes no visible difference. In a complex healthcare dashboard with hundreds of widgets, `const` constructors measurably improve performance by reducing the work Flutter does during rebuilds.

### Keys: Helping Flutter Track Identity

Normally, Flutter identifies widgets by their type and position in the tree. This works fine for static layouts. But what happens when you have a **list of items that can be reordered**?

Imagine a list of patient records. The user sorts by name instead of by date. Without keys, Flutter sees "there is a `PatientCard` at position 0, and the new tree also has a `PatientCard` at position 0" -- so it reuses the same element and just updates the data. This can cause visual glitches if the widgets have internal state (like expanded/collapsed status).

With keys, Flutter can track *which* widget moved to *which* position and update the tree correctly:

```dart
// Without a key -- Flutter matches by position
PatientCard(patient: patients[0])

// With a key -- Flutter matches by identity
PatientCard(key: ValueKey(patient.id), patient: patients[0])
```

You do not need to add keys everywhere. The rule is: **use keys when you have a list of widgets of the same type that can be reordered, added, or removed.** We will practice this when we build list views in later weeks.

> PRESENTER NOTE: If time allows, show the classic Flutter key demo: a list of colored
> boxes with checkboxes. Reorder the list without keys -- the colors move but the
> checkbox states stay in place (wrong!). Add keys -- everything moves together
> correctly. This demo is very visual and memorable.

### Performance: How Flutter Stays Fast

Flutter's rendering pipeline can be summarized in three principles:

1. **Widgets are cheap.** Creating a new widget tree on every `build()` is fine because widgets are just lightweight descriptions.
2. **Elements provide continuity.** The element tree persists across rebuilds, so Flutter only updates what actually changed.
3. **Render objects are reused.** The expensive layout and painting work is only redone for the parts of the tree that were actually modified.

This three-tree architecture is what allows Flutter to render at 60 frames per second (or 120 on newer devices) even for complex UIs. Each frame, Flutter runs `build()` for any dirty widgets, diffs the widget tree against the element tree, and updates only the affected render objects.

---

## 4. Project Kickoff -- From Idea to App (15 min)

### Turning Your Idea Into a Plan

You formed teams in the lab. Maybe you already have a project idea brewing -- a mental health journal, a medication reminder, a symptom tracker, a fitness companion. Whatever it is, the next step is the same: **plan before you code.**

The temptation is strong to open your IDE and start writing widgets immediately. Resist it. An hour of planning saves ten hours of rewriting. This is true in any software project, but especially in mobile apps where navigation flows, data models, and screen layouts are tightly interconnected.

### The Development Process

```d2
direction: right

idea: "Idea" {style.fill: "#E3F2FD"}
wireframes: "Wireframes" {style.fill: "#BBDEFB"}
architecture: "Architecture" {style.fill: "#FFF9C4"}
code: "Code" {style.fill: "#E8F5E9"}
test: "Test" {style.fill: "#FFE0B2"}
deploy: "Deploy" {style.fill: "#C8E6C9"}

idea -> wireframes -> architecture -> code -> test -> deploy
```

You are currently between "Idea" and "Wireframes." Let's talk about each step.

### Step 1: Wireframes -- Sketch Your Screens

A wireframe is a rough sketch of what each screen in your app will look like. It does not need to be beautiful. It does not need precise measurements or exact colors. It needs to answer three questions:

1. **What screens does the app have?** (List them all.)
2. **What does each screen show?** (What data, what controls, what layout.)
3. **How does the user get from one screen to another?** (Navigation flow.)

You do not need Figma, Sketch, or any design tool. Pen and paper is enough for this course. Five minutes with a pencil often reveals problems that would take an hour to discover in code.

**Example: A mood tracker wireframe**

```
+-----------------+     +-----------------+     +-----------------+
|   Home Screen   |     |   Log Mood      |     |   History       |
|                 |     |                 |     |                 |
| [Today's Mood]  |     | How are you     |     | Oct 15: Happy   |
| [Quick Stats]   |     | feeling?        |     | Oct 14: Neutral |
|                 |     |                 |     | Oct 13: Sad     |
| [+] Log Mood    |     | (mood buttons)  |     | Oct 12: Happy   |
|                 |     |                 |     |                 |
| [History]       |     | Notes: ______   |     | [Filter] [Sort] |
| [Settings]      |     |                 |     |                 |
|                 |     | [Save]          |     |                 |
+-----------------+     +-----------------+     +-----------------+
      |                       |                       |
      +--- tab bar -----------+--- tab bar -----------+
```

Even this rough sketch tells you a lot: the app needs at least three screens, a tab-based navigation, a mood selection widget, a text input for notes, and a scrollable list for history.

> PRESENTER NOTE: Show 2-3 example wireframes on the whiteboard or prepared slides.
> Sketch them live if possible -- this demonstrates that wireframes should be rough
> and fast. Emphasize that the goal is to plan screens and navigation flow, not to
> create pixel-perfect designs. If you have example wireframes from previous semesters
> (anonymized), those are even better.

### Step 2: Architecture Decisions

Before writing code, your team should agree on a few key decisions:

**How many screens will the app have?**
List them. Name them. For each screen, write one sentence describing its purpose. This becomes your navigation map.

**What data do you need to store?**
What are the core data types in your app? A mood entry with a date, mood level, and optional notes? A medication with a name, dosage, and schedule? These become your data models.

**Do you need an API?**
Yes -- it is a course requirement. Your app must communicate with a backend. Think about what data needs to be synced between the app and the server.

**What is your authentication strategy?**
Will users log in with email and password? Will there be anonymous usage? This affects both the backend and the app's navigation flow (login screen, registration screen, protected routes).

### Step 3: The Proposal

Your project proposal is due in **Week 5**. It is a short document that covers:

- **Project title and team members**
- **Problem statement** -- what problem does your app solve?
- **Target users** -- who will use this app?
- **Key features** -- what will the app do? (Prioritize: what is essential vs. nice-to-have)
- **Screen list and navigation flow** -- your wireframes
- **Data model** -- what data types does the app manage?
- **API endpoints** -- what does the backend need to provide?
- **Tech stack** -- Flutter + Dart for the frontend, what for the backend?

This is not a 20-page document. Two to three pages with clear wireframes is enough. The goal is to force your team to make decisions *before* you start coding, not *while* you are coding.

### Sprint 1: Weeks 5--7

After the proposal is approved, your first sprint begins. The goal for Sprint 1 is modest:

- **App skeleton** -- project created, folder structure set up, basic dependencies added
- **Navigation** -- all screens exist (even if they are mostly empty), and you can navigate between them
- **Basic screens** -- each screen has its layout roughed out with placeholder data
- **Version control** -- the project is in a GitHub repository, all team members can contribute

Do not try to build everything at once. A working skeleton with navigation is more valuable than one beautifully polished screen with no way to reach the others.

> PRESENTER NOTE: If previous semesters' proposals are available (anonymized), show one
> or two as examples. Point out what makes a good proposal: clear scope, realistic
> feature list, and actual wireframes (not just text descriptions). Warn against the
> two common mistakes: (1) proposing too many features ("we'll build Uber for hospitals")
> and (2) being too vague ("we'll make a health app").

---

## 5. From Prototype to Product -- The Healthcare Path (10 min)

### The Journey From Class Project to Real-World App

Your semester project is a prototype. It proves a concept works: "yes, a mobile app can track mood entries, store them on a server, and display trends over time." That is valuable and real.

But if you wanted to turn that prototype into a product that actual patients or clinicians use, the journey is much longer. Understanding this journey helps you appreciate both what you are learning and what lies beyond the scope of this course.

### Levels of Maturity

```d2
direction: down

l1: "Level 1: PROTOTYPE (this course)" {
  style.fill: "#E3F2FD"
  d1: "Proves the concept works"
  d2: "Runs on your device"
  d3: "May have hardcoded data, rough UI, no security"
}

l2: "Level 2: MINIMUM VIABLE PRODUCT (MVP)" {
  style.fill: "#BBDEFB"
  d1: "Works reliably on multiple devices"
  d2: "Has real authentication and basic security"
  d3: "Handles errors gracefully"
  d4: "Can be tested by real users (internal beta)"
}

l3: "Level 3: CLINICAL VALIDATION" {
  style.fill: "#FFF9C4"
  d1: "Tested with real patients or clinicians"
  d2: "Usability studies conducted"
  d3: "Data accuracy verified against established methods"
  d4: "Ethics committee / IRB approval for studies"
}

l4: "Level 4: REGULATORY APPROVAL" {
  style.fill: "#FFE0B2"
  d1: "Meets applicable standards (MDR in EU, FDA in US)"
  d2: "IEC 62304 compliant software lifecycle"
  d3: "Risk management (ISO 14971)"
  d4: "Clinical evidence documentation"
}

l5: "Level 5: PRODUCTION" {
  style.fill: "#C8E6C9"
  d1: "Deployed to app stores"
  d2: "Monitored, maintained, and updated"
  d3: "User support and incident response"
  d4: "Ongoing regulatory compliance"
}

l1 -> l2 -> l3 -> l4 -> l5
```

You are at Level 1. But the practices you are learning right now -- version control, code review, testing, clean architecture, API design -- are the foundation for *every* subsequent level. A team that skips these fundamentals at Level 1 will struggle enormously at Level 3 or 4.

### IEC 62304: Software Lifecycle for Medical Devices

If your app qualifies as a medical device (it provides diagnosis, monitors a condition, or recommends treatment), it falls under IEC 62304 in Europe and similar FDA guidance in the United States. This standard requires:

- **Documented software development plan** -- you cannot just "wing it"
- **Requirements traceability** -- every feature must trace back to a requirement, and every requirement must trace to a test
- **Change control** -- every code change must be reviewed and approved (sound familiar? That is pull requests and code review)
- **Risk management** -- every feature must be assessed for potential harm
- **Verification and validation** -- testing that the software does what it should and does not do what it should not

Notice how many of these overlap with what you are already learning. Git history provides traceability. Pull requests provide change control. Automated tests provide verification. You are not just learning "how to code" -- you are learning the practices that regulated industries depend on.

### Even If Your App Never Becomes a Medical Device

Not every health-related app is a medical device. A mood journal that simply records entries is likely not regulated. A medication reminder might or might not be, depending on jurisdiction.

But the practices still matter. Every professional software team -- healthcare or not -- uses version control, code review, testing, and structured project management. Learning these now, in the context of a course where you have guidance and can make mistakes safely, is far better than learning them on the job under pressure.

The difference between a computer science graduate who "knows how to code" and one who "knows how to build software" is exactly these practices.

> PRESENTER NOTE: Keep this section brief and inspirational rather than detailed.
> The goal is to plant a seed: "what you are learning has real-world significance
> beyond getting a grade." Do not go deep into regulatory details -- that is a
> separate course. Just make students aware that the path exists and that they are
> already on the first step.

---

## 6. Key Takeaways (5 min)

1. **StatefulWidget has a lifecycle: `initState()` -> `build()` -> (`setState()` -> `build()`)* -> `dispose()`.** Always clean up resources in `dispose()` -- controllers, streams, subscriptions. Forgetting to dispose is a memory leak, and in healthcare apps, it can mean a drained device during a critical shift.

2. **State is either ephemeral (local to one widget) or app-wide (shared across the app).** `setState()` handles ephemeral state. App state requires a state management solution like Riverpod, which we will introduce in Week 6.

3. **Flutter maintains three trees -- Widget, Element, and RenderObject -- for efficient rendering.** Widgets are cheap descriptions rebuilt often. Elements provide continuity. Render objects do the expensive layout and painting work.

4. **`build()` is called many times and must be fast and pure.** No side effects, no expensive computations, no network calls inside `build()`. Set things up in `initState()`, clean up in `dispose()`, and let `build()` just describe the UI.

5. **Good app development starts with planning: wireframes, architecture, then code.** An hour of sketching screens on paper saves many hours of rewriting code. Your project proposal (due Week 5) forces this planning step.

6. **Healthcare apps follow the same development practices as all software, but with higher stakes and regulatory requirements.** The skills you are learning -- version control, code review, testing, structured development -- are the foundation for building software that can eventually serve real patients.

---

## Further Reading

If you want to go deeper on any topic covered today:

- **Flutter State class lifecycle:** [State class documentation](https://api.flutter.dev/flutter/widgets/State-class.html) -- the official reference for all lifecycle methods
- **State management introduction:** [Flutter state management guide](https://docs.flutter.dev/data-and-backend/state-mgmt/intro) -- Flutter's own explanation of ephemeral vs app state
- **Flutter architectural overview:** [Inside Flutter](https://docs.flutter.dev/resources/architectural-overview) -- how the three trees work under the hood
- **IEC 62304 overview:** [Wikipedia: IEC 62304](https://en.wikipedia.org/wiki/IEC_62304) -- a brief introduction to the medical device software lifecycle standard
- **Flutter performance best practices:** [Performance best practices](https://docs.flutter.dev/perf/best-practices) -- tips for keeping your app fast, including effective use of `const`

---

## Lecture Demo: Mood Tracker Project

Per the course roadmap, the Week 4 demo adds the main screen and basic widget tree to the Mood Tracker reference implementation.

> PRESENTER NOTE: If time allows after Q&A, start the Mood Tracker demo project live.
> Create a new Flutter project (or open the pre-created starter), set up the main screen
> with an AppBar titled "Mood Tracker," a placeholder ListView for mood entries, and a
> FloatingActionButton for adding new entries. Keep it deliberately simple -- Scaffold,
> AppBar, body with a Center widget and a "Coming soon" message. This gives students a
> reference implementation to study alongside their own projects. Point out how the
> widget tree maps to what you discussed in Section 3: MaterialApp -> Scaffold -> Column
> -> [AppBar, ListView, FAB]. Relate back to the lifecycle: "This screen is a
> StatefulWidget. When we add Riverpod in Week 6, the mood entries will come from a
> provider instead of local state."
