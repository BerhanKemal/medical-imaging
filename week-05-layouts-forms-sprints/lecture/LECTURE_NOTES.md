# Week 5 Lecture: Layouts, Forms, Material Design & Industry Context

**Course:** Multiplatform Mobile Software Engineering in Practice
**Duration:** ~2 hours (including Q&A)
**Format:** Student-facing notes with presenter cues

> Lines marked with `> PRESENTER NOTE:` are for the instructor only. Students can
> ignore these or treat them as bonus context.

---

## Table of Contents

1. [Flutter Layout System -- How Widgets Arrange Themselves](#1-flutter-layout-system-how-widgets-arrange-themselves-25-min) (25 min)
2. [Forms and Validation -- Getting Data from Users](#2-forms-and-validation-getting-data-from-users-20-min) (20 min)
3. [Material Design 3 -- A Design Language for Mobile Apps](#3-material-design-3-a-design-language-for-mobile-apps-15-min) (15 min)
4. [Industry Regulatory Context -- Mobile Health as a Case Study](#4-industry-regulatory-context-mobile-health-as-a-case-study-20-min) (20 min)
5. [Agile and Scrum in a Nutshell](#5-agile-and-scrum-in-a-nutshell-10-min) (10 min)
6. [Key Takeaways](#6-key-takeaways-5-min) (5 min)

---

## 1. Flutter Layout System -- How Widgets Arrange Themselves (25 min)

### From Using Widgets to Understanding Them

In Week 4, you used Column, Padding, and SizedBox to arrange widgets on screen. You wrote code like `Column(children: [...])` and things appeared vertically. It worked. But you probably also ran into a confusing overflow error at some point -- a yellow-and-black striped warning telling you that your widgets did not fit.

To prevent those errors and to build layouts that work across different screen sizes, you need to understand **how Flutter decides where to place things on screen**. This is the layout algorithm, and once you understand it, layouts stop being mysterious.

### The Constraint Model

Flutter's layout system follows three simple rules:

1. **Constraints go down.** A parent widget tells each child: "Here is how much space you have."
2. **Sizes go up.** Each child widget decides its own size within those constraints and reports back.
3. **Parent sets position.** The parent decides where to place each child on screen.

That is it. Every layout in Flutter -- from a simple centered text to a complex medical dashboard -- follows these three rules.

```d2
direction: down

screen: "Screen (400 x 800)" {
  style.fill: "#F5F5F5"
  style.font-size: 18

  constraint_msg: 'Constraints: "You can be 0-400 wide, 0-800 tall"' {
    style.fill: "transparent"
    style.stroke: "transparent"
  }

  column: "Column" {
    style.fill: "#E3F2FD"

    constraint_children: 'Constraints to children:\n"You can be 0-400 wide,\nas tall as you want"' {
      style.fill: "transparent"
      style.stroke: "transparent"
    }

    text: "Text\n200 x 24" {style.fill: "#BBDEFB"}
    button: "Button\n150 x 48" {style.fill: "#BBDEFB"}

    size: "Size: 400 x 72" {
      style.fill: "transparent"
      style.stroke: "transparent"
      style.bold: true
    }
  }

  constraint_msg -> column: "constraints go down" {style.stroke-dash: 3}
}
```

Read this diagram from top to bottom. The screen says to Column: "You can be up to 400 pixels wide and 800 pixels tall." Column then tells each of its children: "You can be up to 400 pixels wide, and as tall as you want." The Text widget decides it needs 200x24 pixels. The Button decides it needs 150x48 pixels. Column adds up the heights (24 + 48 = 72), takes the maximum width (200), and reports its own size back up. Finally, Column positions the Text at the top and the Button below it.

**Analogy:** Think of it like packing a suitcase. The suitcase (parent) tells you its dimensions. You (child) choose items that fit. The suitcase does not decide how big your shirts are -- but it does decide the maximum size you can bring.

### The Overflow Error -- Demystified

When you see `A RenderFlex overflowed by 42 pixels on the bottom`, it means a child widget wanted to be bigger than its parent's constraints allowed. The child said "I need 842 pixels tall" but the parent said "You can only have 800." Flutter does not silently clip -- it paints the warning stripes so you know something is wrong.

The fix is always the same: either make the child smaller, or give it a scrollable container (like `ListView` or `SingleChildScrollView`) so it can exceed the visible area.

### Row vs Column

The most common layout widgets are `Row` (horizontal) and `Column` (vertical). They work identically -- just in different directions:

```d2
direction: right

col: "Column (vertical)" {
  style.fill: "#E3F2FD"
  direction: down
  a: "Widget A" {style.fill: "#BBDEFB"}
  b: "Widget B" {style.fill: "#BBDEFB"}
  c: "Widget C" {style.fill: "#BBDEFB"}
  a -> b -> c: "" {style.stroke: "#90CAF9"}
}

row: "Row (horizontal)" {
  style.fill: "#E8F5E9"
  direction: right
  a: "Widget A" {style.fill: "#C8E6C9"}
  b: "Widget B" {style.fill: "#C8E6C9"}
  c: "Widget C" {style.fill: "#C8E6C9"}
  a -> b -> c: "" {style.stroke: "#A5D6A7"}
}
```

Both take a `children` list and lay them out one after another. Both support `mainAxisAlignment` (how children are distributed along the main axis) and `crossAxisAlignment` (how children are aligned perpendicular to the main axis).

### Expanded and Flexible

When a Column has leftover space, how do you tell a child to fill it? That is what `Expanded` and `Flexible` do:

- **Expanded:** "Take up all remaining space." If multiple children are `Expanded`, they share it equally (or by `flex` ratio).
- **Flexible:** "You can take up remaining space, but you do not have to." The child can be smaller than the available space.

A common pattern in health apps: a list of records takes up most of the screen, with a fixed toolbar at the bottom.

```dart
Column(
  children: [
    Expanded(child: ListView(...)),   // Takes all remaining space
    BottomToolbar(),                  // Fixed height at bottom
  ],
)
```

### Stack -- Layering Widgets

`Stack` places widgets on top of each other, like layers in a graphics editor. The first child is at the bottom, the last child is on top. This is useful for overlaying badges, status indicators, or gradient overlays on images.

In health apps, you might overlay a warning icon on a vital sign card when a value is out of range.

### ListView -- Scrollable Lists

When you have more items than fit on screen, `ListView` makes them scrollable. Unlike `Column`, `ListView` does not try to fit everything at once -- it only builds the widgets that are currently visible on screen.

For lists with many items (hundreds of medication records, thousands of data points), always use `ListView.builder`. It creates items lazily, which means your app stays fast even with large datasets.

### Common Layout Patterns for Health Apps

Three patterns appear in nearly every health app:

**Dashboard with cards.** A grid or column of cards showing vital signs at a glance -- heart rate, blood pressure, temperature, oxygen saturation. Each card is a compact summary. The clinician's eye should be drawn to abnormal values instantly.

**List of records.** A scrollable list of entries -- medication history, mood entries, appointment logs. Each item shows a summary; tapping opens the detail view.

**Detail view.** A single record shown in full -- a patient encounter, a lab result, a mood entry with notes. Typically uses a Column inside a SingleChildScrollView.

> PRESENTER NOTE: Show the "Understanding Constraints" page from flutter.dev. The
> interactive examples are excellent for driving home the constraint model. If time
> allows, build a simple dashboard layout live -- a Column with three Cards, each
> showing a vital sign name and value. Keep it to 5 minutes max.

### Healthcare Connection: Layout is Patient Safety

Medical dashboards need careful layout design. A clinician glancing at a patient's vital signs display must find the critical value -- the heart rate that just spiked, the oxygen level that dropped -- instantly. If the layout is cluttered or poorly organized, the clinician might miss the alarm. Layout is not just aesthetics -- it is patient safety.

The same applies to patient-facing apps. If a diabetic patient cannot quickly find today's glucose reading because the layout buries it beneath three scroll-lengths of other data, they will stop using the app. An unused health app helps nobody.

---

## 2. Forms and Validation -- Getting Data from Users (20 min)

### Why Forms Matter in Health Apps

Forms are the primary way users input data in health apps. A patient logging their blood pressure. A nurse entering medication dosages. A researcher recording clinical observations. Every piece of health data enters the system through some kind of form.

In Exercise 4 last week, you built a health check-in form. But it had no validation -- a user could submit with an empty name or a pain level of -5. In a real health app, that could corrupt a patient's record or, worse, feed incorrect data into a clinical decision.

### TextFormField vs TextField

Flutter gives you two text input widgets:

- **TextField:** Basic text input. No built-in connection to a validation system.
- **TextFormField:** A TextField wrapped with `Form` integration. It supports a `validator` function that runs when the form is submitted.

For health apps, always use `TextFormField` inside a `Form`. The extra validation infrastructure is worth it.

### The Form Widget and GlobalKey

The `Form` widget groups multiple `TextFormField` widgets together. A `GlobalKey<FormState>` gives you a handle to call `validate()` on all fields at once:

```dart
final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: Column(
    children: [
      TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Patient name is required';
          }
          return null;  // null means valid
        },
      ),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // All fields passed validation -- safe to submit
          }
        },
        child: Text('Submit'),
      ),
    ],
  ),
)
```

When `validate()` is called, every `TextFormField` runs its `validator` function. If any returns a non-null string, that string appears as an error message below the field. The form is only valid when all validators return `null`.

### Validation Patterns for Healthcare

Healthcare data has stricter validation requirements than most domains. Here are the common patterns:

**Required fields.** Patient name, date of birth, medical record number. These must never be empty.

```dart
validator: (value) {
  if (value == null || value.isEmpty) {
    return 'This field is required';
  }
  return null;
}
```

**Range checks.** Physiological values have known limits. A heart rate of 720 is not a valid heart rate -- it is a typo for 72. A body temperature of 342 is not Celsius -- someone forgot the decimal point.

```dart
validator: (value) {
  final rate = int.tryParse(value ?? '');
  if (rate == null || rate < 30 || rate > 250) {
    return 'Heart rate must be between 30 and 250 bpm';
  }
  return null;
}
```

**Format validation.** Email addresses, phone numbers, national ID numbers. These follow specific patterns.

**Cross-field validation.** Blood pressure has two values -- systolic and diastolic. Systolic must always be greater than diastolic. A reading of 80/120 is entered backwards. Cross-field validation catches this.

### Showing Errors

Flutter supports three approaches to surfacing validation errors:

- **Inline errors:** The default behavior of `TextFormField`. The error message appears directly below the field. This is the best approach for most cases because the user sees exactly which field has the problem.
- **Snackbar:** A brief message at the bottom of the screen. Good for general messages ("Please fix the errors above") but does not point to specific fields.
- **Dialog:** A modal popup that blocks interaction until dismissed. Use sparingly -- only for critical confirmations like "Are you sure you want to delete this patient record?"

For health apps, prefer inline errors. A nurse entering data quickly needs to see at a glance which field is wrong, fix it, and move on.

> PRESENTER NOTE: Demo adding validation to the Exercise 4 Health Check-In form from
> Week 4. Add a validator for patient name (required) and pain level range (0-10).
> Show what happens when validation fails -- the red error text, the form refusing to
> submit. Then show what happens when values are valid. This should take about 5
> minutes and gives students a concrete before/after comparison.

### Healthcare Connection: Validation as a Safety Layer

Invalid data in healthcare is not just annoying -- it is dangerous. If a nurse enters a heart rate of 720 instead of 72 (a mistyped extra zero), the system should catch that immediately. If it does not, downstream systems -- alerts, trend analysis, clinical decision support -- all operate on garbage data.

Good form validation is the first line of defense. It does not replace server-side validation (which you will learn in Week 8), but it catches the obvious mistakes before the data ever leaves the device. Think of it as the guardrail on a mountain road: it will not prevent all accidents, but it stops the most common ones.

---

## 3. Material Design 3 -- A Design Language for Mobile Apps (15 min)

### What is Material Design?

Material Design is Google's design system. It is a set of guidelines, components, and tools for building user interfaces. It is not Android-specific -- Material Design works on iOS, web, and desktop too. Flutter uses Material Design as its default component library.

You have been using it since Week 4. Every `Scaffold`, `AppBar`, `ElevatedButton`, and `Card` in your Flutter apps is a Material Design component.

### Material Design 3 (Material You)

Material Design 3 is the latest version. Its major improvements include:

- **Dynamic color.** Generate an entire color palette from a single seed color. You used this in Week 4 with `ColorScheme.fromSeed` -- a single line of code gave you a complete, harmonious, accessible color scheme.
- **Updated components.** Buttons, cards, navigation bars, and dialogs all received visual refreshes with softer shapes and more consistent spacing.
- **Accessibility by default.** Components are designed to meet WCAG contrast requirements, have minimum touch targets of 48x48 dp, and support screen readers out of the box.

### Why Use a Design System?

You could design every button, card, and dialog from scratch. But there are three reasons not to:

**Consistency.** A design system ensures that every part of your app looks and behaves the same way. A button in the settings screen works exactly like a button in the data entry screen. Users do not have to relearn your interface on every screen.

**Accessibility.** Material Design components have been tested against WCAG accessibility guidelines. They have proper contrast ratios, sufficient touch target sizes, and correct semantic labels for screen readers. Building this from scratch is hundreds of hours of work.

**Familiarity.** Billions of people use Material Design apps daily (Gmail, Google Maps, YouTube). When your health app uses standard Material components, users already know how to interact with them. They know a floating action button means "create something new." They know swiping a list item might reveal delete or archive actions.

### Key Material 3 Components for Health Apps

**Cards.** Use cards for patient summaries, vital sign displays, and any self-contained piece of information. A card has elevation (subtle shadow), rounded corners, and can contain any combination of text, images, and buttons.

**Navigation.** `BottomNavigationBar` for 3-5 top-level destinations (Home, History, Settings). `NavigationRail` for tablet layouts. `Drawer` for less frequent destinations.

**Lists and ListTiles.** Perfect for medication lists, appointment schedules, mood entry history. `ListTile` gives you a consistent layout with leading icon, title, subtitle, and trailing widget.

**Dialogs.** Use `AlertDialog` for confirmations before destructive actions. "Are you sure you want to delete this blood pressure reading?" In health apps, accidental data deletion can have real consequences.

**Chips.** Small, interactive elements for tags and categories. Useful for tagging symptoms ("headache", "nausea", "fatigue") or conditions ("type 2 diabetes", "hypertension").

### Theming: ColorScheme and TextTheme

Two things make your app feel polished and consistent:

**ColorScheme.** Instead of hardcoding colors (`Color(0xFF2196F3)`), use semantic color roles: `Theme.of(context).colorScheme.primary`, `.secondary`, `.error`, `.surface`. This means you define your colors once in the theme, and every widget pulls from the same palette. Changing the theme changes the entire app.

**TextTheme.** Instead of specifying font sizes everywhere (`fontSize: 24`), use semantic text styles: `Theme.of(context).textTheme.headlineMedium`, `.bodyLarge`, `.labelSmall`. This ensures consistent typography and makes it trivial to support dynamic type sizes for accessibility.

Light and dark mode support comes almost for free when you use `ColorScheme` and `TextTheme`. Define a light scheme and a dark scheme, and Flutter handles the rest.

> PRESENTER NOTE: Show the material.io design gallery at m3.material.io. Point out
> accessibility features like minimum touch target size (48x48 dp) and contrast
> requirements. Mention: "Your app will be graded partly on UX -- using Material
> Design properly gets you most of the way there without needing a designer on
> your team."

### Healthcare Connection: Accessibility is Not Optional

In healthcare, accessibility is not a nice-to-have feature -- it is a core requirement. Your users may include:

- **Elderly patients** with reduced vision and motor control
- **Patients with chronic conditions** experiencing fatigue or cognitive fog
- **Clinicians in high-stress environments** who need to read data at a glance under harsh lighting
- **Users with color vision deficiency** -- about 8% of men have some form of color blindness

Material Design's accessibility features -- contrast ratios, touch targets, screen reader support -- help you build inclusive apps. And in many jurisdictions, accessibility in healthcare software is not just good practice but a legal requirement.

!!! tip "Reference: Accessibility Quick Guide"
    For a practical checklist of accessibility implementations you should apply to your team project (semantic labels, contrast ratios, scalable text, touch targets), see the [Accessibility Guide](../../resources/ACCESSIBILITY_GUIDE.md). This guide maps directly to the Industry & Regulatory Awareness rubric criteria in the final project grading.

---

## 4. Industry Regulatory Context -- Mobile Health as a Case Study (20 min)

### What is mHealth?

mHealth -- mobile health -- is the use of mobile devices for health-related purposes. It covers everything from a simple step counter on your phone to a clinically validated app that a doctor prescribes for managing diabetes.

In the lab, you started planning your health app project. Let us understand the broader landscape that your project fits into.

### The mHealth Spectrum

mHealth apps span a wide range of complexity, clinical impact, and regulatory burden:

```d2
direction: right

title: "mHealth Spectrum" {
  style.fill: "#F5F5F5"
  style.font-size: 20

  direction: right

  wellness: "Wellness" {
    style.fill: "#C8E6C9"
    d1: "Step counter"
    d2: "Fitness tracker"
  }

  lifestyle: "Lifestyle Mgmt" {
    style.fill: "#E3F2FD"
    d1: "Medication reminder"
    d2: "Mood tracker"
  }

  disease: "Disease Mgmt" {
    style.fill: "#FFF9C4"
    d1: "Glucose monitor"
    d2: "Blood pressure"
  }

  clinical: "Clinical Decision\nSupport" {
    style.fill: "#FFCDD2"
    d1: "Diagnostics"
  }

  wellness -> lifestyle -> disease -> clinical: "" {style.stroke-dash: 3}

  regulation: "Low Regulation ←——→ High Regulation" {
    style.fill: "transparent"
    style.stroke: "transparent"
    style.bold: true
  }

  your_project: "Your project likely fits here ↑" {
    style.fill: "transparent"
    style.stroke: "transparent"
    style.italic: true
  }
}
```

Moving from left to right, the apps become more clinically significant, more tightly regulated, and more complex to build. Let us look at each category.

### Categories of mHealth Apps

**Wellness and prevention.** Fitness trackers, meditation apps, sleep trackers, nutrition logs. These apps help healthy people stay healthy. They rarely make clinical claims and face minimal regulation. Most commercial health apps on the app stores fall into this category.

**Lifestyle management.** Medication reminders, mood trackers, habit trackers, symptom diaries. These apps help users manage aspects of their health but do not provide diagnosis or treatment recommendations. Your course projects likely fit here.

**Chronic disease management.** Glucose monitors for diabetes, blood pressure trackers for hypertension, inhaler usage trackers for asthma. These apps are used by patients with diagnosed conditions and often integrate with medical devices (glucose meters, blood pressure cuffs). They sit closer to the regulatory boundary.

**Clinical tools.** Point-of-care diagnostics, clinical decision support systems, medical image analysis. These apps directly influence clinical decisions and are typically classified as medical devices under regulatory frameworks.

**Remote patient monitoring.** Post-surgery monitoring, elderly care, telehealth platforms. These apps transmit patient data to healthcare providers and may trigger clinical interventions.

### Evidence-Based mHealth

There is a critical distinction between "health-themed" and "clinically validated."

There are thousands of sleep apps on the app stores. Most have no clinical validation. They track your movement overnight and produce a "sleep quality score" using proprietary algorithms that have never been tested in a clinical study. Users trust these scores, but the scores may be meaningless.

On the other end, apps like CBT-i Coach (for insomnia) are based on Cognitive Behavioral Therapy for Insomnia -- a clinically proven treatment. The app's content was developed by clinical psychologists, and its effectiveness has been demonstrated in randomized controlled trials.

When building health apps, be honest about what your app can and cannot claim. A mood tracker that says "track your mood over time" is fine. A mood tracker that says "this app detects depression" is making a clinical claim that requires evidence.

### Design Principles for mHealth Apps

Building a health app is not the same as building a social media app or a game. Health apps have unique constraints:

**Simplicity.** Your users may not be tech-savvy. An elderly patient managing their medications should not need a tutorial to use your app. Minimize cognitive load: fewer screens, fewer options, clearer labels.

**Trust.** Patients share sensitive data -- their symptoms, their mental state, their body measurements. The app must feel trustworthy. This means professional design, clear privacy policies, and no dark patterns. If the app looks like it was built in a weekend, patients will not trust it with their health data.

**Adherence.** An app is useless if patients stop using it after a week. Studies consistently show that most health apps are abandoned within 30 days. Design for long-term use: gentle reminders (not nagging notifications), visible progress, low-friction data entry.

**Offline capability.** Healthcare happens in places with poor connectivity -- rural clinics, hospital basements, developing countries. A blood pressure tracker that crashes without Wi-Fi is not useful in the real world. Store data locally and sync when connectivity returns.

**Data quality.** Garbage in, garbage out. If your app collects heart rate data but does not validate the input range, your trend charts and averages will be corrupted by typos. This connects directly to Section 2 -- form validation is a data quality tool.

### Regulatory Overview

This is a brief introduction. We will revisit regulations in depth in Week 12.

**EU MDR (Medical Device Regulation).** In the European Union, if your app provides diagnosis or treatment guidance, it may be classified as a medical device and must comply with the MDR. This means clinical evaluation, quality management systems, and CE marking.

**US FDA (Food and Drug Administration).** The FDA uses a risk-based classification for Software as a Medical Device (SaMD). Low-risk apps (wellness, general health) face minimal oversight. High-risk apps (diagnostic algorithms, treatment recommendations) require premarket approval.

**DiGA (Germany).** Germany has a pioneering program where digital health applications can be prescribed by doctors and reimbursed by health insurance. Apps must demonstrate clinical benefit through studies and meet data protection requirements.

Your course project will NOT need regulatory approval. But knowing these frameworks exist prepares you for industry. If you build health apps professionally, you will encounter these regulations.

!!! tip "Reference: mHealth Regulations Quick Guide"
    For a deeper comparison of EU MDR, FDA, IEC 62304, and DiGA — including a flowchart to determine if your app is regulated — see the [mHealth Regulations Guide](../../resources/MHEALTH_REGULATIONS.md). It also contains template sentences you can use in your project proposal's regulatory section.

> PRESENTER NOTE: Ask students: "Where does your team's project fit on the mHealth
> spectrum?" Give each team 30 seconds to answer. This connects the theory to their
> actual Sprint 1 work and helps you understand what they are building. If any team
> is attempting something on the "high regulation" end, gently steer them toward a
> more feasible scope for a course project.

---

## 5. Agile and Scrum in a Nutshell (10 min)

### From Lab to Theory

In the lab, you set up your team's sprint board and wrote user stories. You moved cards from Backlog to Sprint Backlog. You assigned work. Now let us understand the principles behind those activities.

### The Problem with "Plan Everything Upfront"

Traditional software development -- sometimes called the "waterfall" model -- works like this:

```d2
direction: right

r: "Requirements\n(months)" {style.fill: "#E3F2FD"}
d: "Design\n(months)" {style.fill: "#BBDEFB"}
b: "Build\n(months)" {style.fill: "#FFF9C4"}
t: "Test\n(months)" {style.fill: "#FFE0B2"}
dep: "Deploy\n(finally!)" {style.fill: "#C8E6C9"}

r -> d -> b -> t -> dep
```

Problem: by the time you deploy, the requirements have changed, the users want something different, and you've spent a year building the wrong thing.

This approach works for building bridges. Bridges do not change their requirements halfway through construction. But software -- especially health software -- operates in environments where requirements evolve constantly. A clinician uses your prototype and says, "Actually, I need the blood pressure graph on the main screen, not buried in a submenu." If you planned everything upfront, that feedback arrives too late.

### Agile: Iterate in Short Cycles

Agile development flips the model. Instead of one long cycle, you work in short iterations -- typically 1-4 weeks -- where you plan, build, and demonstrate working software:

```d2
direction: right

plan: "Plan" {style.fill: "#E3F2FD"}
build: "Build" {style.fill: "#BBDEFB"}
demo: "Demo" {style.fill: "#FFF9C4"}
feedback: "Feedback" {style.fill: "#E8F5E9"}

plan -> build -> demo -> feedback
feedback -> plan: "Repeat every\n1-4 weeks" {style.stroke-dash: 3}
```

Each cycle produces working software.
Each cycle incorporates feedback from the previous one.

The key insight: you learn more from showing users a rough prototype than from showing them a polished requirements document. Working software generates real feedback. Documents generate theoretical feedback.

### Scrum Basics

Scrum is one specific framework for doing Agile development. It defines a set of roles, events, and artifacts:

**Sprints.** Fixed-length iterations. Yours are 3 weeks (Sprint 1: weeks 5-7, Sprint 2: weeks 8-10, Sprint 3: weeks 11-13). Each sprint produces a working increment of your app.

**Product backlog.** A prioritized list of everything you might build. You created this in the lab as your list of user stories (GitHub Issues).

**Sprint backlog.** The subset of the backlog that you committed to building in this sprint. You selected these during sprint planning.

**Sprint planning.** The ceremony where you select work for the sprint. You did this in Part 4 of the lab.

**Daily standup.** A brief daily sync where each team member answers three questions: What did I do yesterday? What will I do today? Am I blocked? In your case, this can be a quick message in your team chat -- you do not need to meet in person every day.

**Sprint review.** A demo of what you built. You show working software to stakeholders (in your case, the instructor and other teams). Your sprint reviews are at Weeks 7, 10, and 13.

**Retrospective.** A team reflection: What went well? What could be improved? What will we change next sprint? This is arguably the most valuable ceremony because it drives continuous improvement.

### Why Agile Works for Health Apps

Agile is particularly well-suited to health app development for three reasons:

**Requirements change as you learn from users.** You think patients want a detailed medication log. After the first sprint review, you discover they actually want a simple "did I take my meds today?" checkbox. Short iterations let you pivot quickly.

**Early feedback catches UX problems before they are expensive to fix.** Moving a button in Sprint 1 costs minutes. Restructuring the navigation in Sprint 3 costs days. Show your work early and often.

**Regular demos keep stakeholders informed.** In healthcare, stakeholders include not just the development team but also clinicians, patients, and potentially regulators. Regular demos build trust and catch misunderstandings early.

### Your Sprint Board

Your sprint board (Backlog -> Sprint Backlog -> In Progress -> In Review -> Done) is a simplified Kanban board. Real software teams use exactly this pattern -- some with more columns, some with fewer, but the core flow is the same.

The board makes work visible. At any moment, anyone on the team can look at the board and see: What is planned? What is in progress? What is waiting for review? What is done? This transparency prevents the "I thought you were doing that" problem.

> PRESENTER NOTE: Brief mention: "Agile is not a silver bullet. In heavily regulated
> environments like medical device development, you often need a hybrid approach --
> Agile development with waterfall-style documentation for regulatory submissions.
> But for this course, pure Scrum is exactly right. Focus on delivering working
> software every three weeks."

---

## 6. Key Takeaways (5 min)

1. **Flutter's layout system follows three rules:** constraints go down, sizes go up, parent sets position. Understanding this prevents overflow errors and makes complex layouts approachable.

2. **Form validation is a safety layer** -- especially critical in healthcare where invalid data (a heart rate of 720, a blood pressure entered backwards) can mislead clinicians and harm patients.

3. **Material Design 3 gives you consistent, accessible UI components out of the box.** Using semantic colors (`ColorScheme`) and text styles (`TextTheme`) makes theming, dark mode, and accessibility nearly effortless.

4. **mHealth is a growing field** ranging from unregulated wellness apps to prescribed and reimbursed digital therapeutics. Know where your app sits on the spectrum.

5. **Agile and Scrum help teams deliver working software in short iterations.** Your sprints, backlog, and sprint reviews mirror exactly how professional teams work.

6. **Sprint 1 starts now.** Focus on the skeleton first -- navigation, basic screens, app structure -- before adding features. A working app with three simple screens is better than one beautiful screen with no navigation.

---

## Lecture Demo: Mood Tracker -- Form with Validation

> PRESENTER NOTE: Build on the Week 4 mood tracker demo. This week, add a mood entry
> form with the following components:
>
> - A `Slider` for mood score (1-10)
> - A `TextField` for a text note
> - A `Submit` button
>
> Wrap everything in a `Form` with a `GlobalKey<FormState>`. Add validation:
> - Score is required (the slider guarantees a value, so this is inherently valid)
> - Note is optional but limited to 200 characters maximum
>
> Use layout widgets covered in Section 1: wrap the form in a `Column` with `Padding`,
> put the whole thing inside a `Card`, and use `SizedBox` for spacing between fields.
>
> This gives students a concrete example that combines layouts, forms, and Material
> Design -- the three technical topics from this lecture. Walk through the code,
> explaining each widget choice. Total demo time: 10-15 minutes.
>
> Skeleton code for the demo:
>
> ```dart
> class MoodEntryForm extends StatefulWidget {
>   @override
>   State<MoodEntryForm> createState() => _MoodEntryFormState();
> }
>
> class _MoodEntryFormState extends State<MoodEntryForm> {
>   final _formKey = GlobalKey<FormState>();
>   double _moodScore = 5.0;
>   String _note = '';
>
>   @override
>   Widget build(BuildContext context) {
>     return Card(
>       margin: const EdgeInsets.all(16),
>       child: Padding(
>         padding: const EdgeInsets.all(16),
>         child: Form(
>           key: _formKey,
>           child: Column(
>             crossAxisAlignment: CrossAxisAlignment.start,
>             children: [
>               Text('How are you feeling?',
>                 style: Theme.of(context).textTheme.headlineSmall),
>               const SizedBox(height: 16),
>               Slider(
>                 value: _moodScore,
>                 min: 1, max: 10, divisions: 9,
>                 label: _moodScore.round().toString(),
>                 onChanged: (v) => setState(() => _moodScore = v),
>               ),
>               const SizedBox(height: 16),
>               TextFormField(
>                 decoration: const InputDecoration(
>                   labelText: 'Note (optional)',
>                   hintText: 'What is on your mind?',
>                 ),
>                 maxLines: 3,
>                 validator: (value) {
>                   if (value != null && value.length > 200) {
>                     return 'Note must be 200 characters or fewer';
>                   }
>                   return null;
>                 },
>                 onSaved: (v) => _note = v ?? '',
>               ),
>               const SizedBox(height: 24),
>               FilledButton(
>                 onPressed: () {
>                   if (_formKey.currentState!.validate()) {
>                     _formKey.currentState!.save();
>                     // Save the entry (Week 7: local storage)
>                     ScaffoldMessenger.of(context).showSnackBar(
>                       const SnackBar(content: Text('Mood entry saved!')),
>                     );
>                   }
>                 },
>                 child: const Text('Save Entry'),
>               ),
>             ],
>           ),
>         ),
>       ),
>     );
>   }
> }
> ```

---

## Further Reading (Optional)

If you want to go deeper on any topic covered today:

- **Flutter layout tutorial:** [Understanding Constraints](https://docs.flutter.dev/ui/layout/constraints) -- the single most important page for understanding Flutter layouts
- **Flutter layout guide:** [Layouts in Flutter](https://docs.flutter.dev/ui/layout)
- **Flutter forms cookbook:** [Build a Form with Validation](https://docs.flutter.dev/cookbook/forms/validation)
- **Material Design 3:** [Material Design Guidelines](https://m3.material.io/)
- **WHO mHealth evidence review:** [mHealth -- New Horizons for Health through Mobile Technologies](https://www.who.int/publications/i/item/9789241550505)
- **The Scrum Guide:** [Scrum Guide (2020)](https://scrumguides.org/) -- the definitive, concise reference for Scrum
- **EU MDR for software:** [European Commission -- Medical Devices](https://health.ec.europa.eu/medical-devices-sector/new-regulations_en)
