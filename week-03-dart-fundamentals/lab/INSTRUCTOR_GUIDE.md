# Week 3 Lab: Instructor Guide

**Course:** Multiplatform Mobile Software Engineering in Practice
**Lab Duration:** 2 hours
**Topic:** Dart Language Fundamentals
**Audience:** Familiar with C/C++ and Python, comfortable with terminal and Git from Weeks 1--2

> This document is for the **instructor only**. Students use the separate `README.md` workbook.

---

## Pre-Lab Checklist

Complete these **before students arrive**:

- [ ] Verify Dart SDK installed on all lab machines (`dart --version` -- any 3.x is fine)
- [ ] Test that `exercises.dart` file runs without errors when solutions are filled in
- [ ] Have [DartPad](https://dartpad.dev/) open as a fallback if local Dart SDK fails
- [ ] Open the student workbook (`README.md`) on the projector
- [ ] Open `exercises.dart` in your IDE for live coding demos
- [ ] Have `exercises_solution.dart` ready (do NOT show to students)
- [ ] Increase editor font size to at least 18pt for projector
- [ ] Reminder: AI tools are NOT allowed in Weeks 1--3

### Room Setup

- Projector showing your IDE with `exercises.dart` open (large font, light or dark theme -- your preference)
- Students should have `exercises.dart` open in their own editor before you begin
- If students do not have the lab files, they can copy them from the course repository or a shared drive

### If Dart SDK Is Not Installed

If `dart --version` fails on a student machine:

1. **macOS:** `brew tap dart-lang/dart && brew install dart` -- takes 2--3 min
2. **Windows:** `choco install dart-sdk` (requires Chocolatey) or download from [dart.dev](https://dart.dev/get-dart)
3. **Fallback:** Have students use [DartPad](https://dartpad.dev/) in the browser. They can copy exercises one at a time. DartPad does not support `dart:io`, so the Mood Logger assignment cannot be tested there -- but all 12 lab exercises work fine.
4. If download is slow on lab WiFi, have USB drives with the Dart SDK installer ready.

---

## Timing Overview

| Time | Duration | Activity | Type |
|------|----------|----------|------|
| 0:00--0:05 | 5 min | Welcome & Dart overview | Instructor talk |
| 0:05--0:25 | 20 min | Part 1: Variables, Types & Basics (Ex 1--2) | Demo + student work |
| 0:25--0:40 | 15 min | Part 2: Functions (Ex 3--4) | Demo + student work |
| 0:40--0:45 | 5 min | Break / catch-up buffer | --- |
| 0:45--1:00 | 15 min | Part 3: Collections (Ex 5--6) | Demo + student work |
| 1:00--1:20 | 20 min | Part 4: Null Safety (Ex 7--8) | Demo + student work |
| 1:20--1:25 | 5 min | Break / catch-up buffer | --- |
| 1:25--1:50 | 25 min | Part 5: OOP (Ex 9--10) | Demo + student work |
| 1:50--2:00 | 10 min | Part 6: Async (Ex 11--12) + Assignment intro | Demo + wrap-up |

**Total:** 120 minutes (2 hours)

> **Pacing note:** This lab is very content-heavy -- 12 exercises across 6 conceptual topics. The two 5-minute buffers are critical. Prioritize Exercises 1--8 (Parts 1--4). Parts 5--6 can be shortened if you are behind. The exercises build on each other in complexity, so falling behind early compounds quickly. Never skip the buffers -- someone always needs them.

---

## Detailed Facilitation Guide

### 0:00--0:05 --- Welcome & Dart Overview (5 min)

**Type:** Instructor talk

**What to say (talking points, not a script):**

- "Today we learn Dart -- the language behind Flutter and every app we will build for the rest of the course"
- "Dart will feel familiar. It borrows from C++ (static types, classes) and Python (clean syntax, named parameters, async/await). Think of it as a modern blend of both."
- "We have 12 exercises across 6 topics. That is a lot. Do not panic if you do not finish everything -- the first 8 exercises are the priority."
- "The exercises use a healthcare context: patient data, heart rates, allergies, medical records. This is the domain you will work in for the rest of the semester."
- AI tools are NOT allowed in Weeks 1--3 -- write every line yourself
- The workbook (`README.md`) has explanations and examples. The exercises are in `exercises.dart`. Read the workbook, then code the exercises.

**What students should be doing:**

- Opening their terminal and verifying `dart --version`
- Opening `exercises.dart` in their editor
- Having the workbook open (on projector or their own screen)

**Checkpoint:** Before moving on, verify that **every student can run** `dart --version` and sees a 3.x version number. Walk around the room if necessary.

**Common pitfall:** Students who installed Flutter but not standalone Dart may have `dart` available through the Flutter SDK path. That is fine -- any working `dart` command is acceptable. If a student has neither, point them to DartPad as an immediate fallback while the SDK downloads in the background.

---

### 0:05--0:25 --- Part 1: Variables, Types & Basics (20 min)

**Type:** Demo (first half) + student work (second half)

**Pacing:** 10 minutes of demo, 10 minutes of student work on Exercises 1--2.

#### 0:05--0:10 --- Core Types Demo (5 min)

**Demo on projector -- write these live, do not just show slides:**

```dart
// Core types
int heartRate = 72;
double temperature = 36.6;
String patientName = 'Alice';
bool isAdmitted = true;

// Type inference with var
var age = 25;        // Dart infers int
var weight = 70.5;   // Dart infers double
// age = 'hello';    // ERROR -- var locks the type
```

**Talking point:** "Dart is statically typed like C++, but with type inference like `auto`. Once Dart decides a `var` is an `int`, it stays an `int`. This is different from Python where `x = 5` and then `x = 'hello'` is perfectly legal."

**What to watch for:**

- Students confused by the semicolons (Python programmers forget them)
- Students trying to use `print` without parentheses (Python 2 habit, rare but possible)

#### 0:10--0:15 --- `final` vs `const` + String Interpolation (5 min)

**Demo on projector:**

```dart
// final = set once at runtime
final now = DateTime.now();
// now = DateTime.now();  // ERROR: cannot reassign

// const = known at compile time
const maxDose = 500;
// const now2 = DateTime.now();  // ERROR: not a compile-time constant

// String interpolation
String name = 'Alice';
int age = 30;
print('Hello, $name!');
print('Next year: ${age + 1}');
```

**Talking point:** "Think of `final` as 'set once, never change' and `const` as 'known before the program even runs.' The key question is: can you know the value at compile time? If yes, use `const`. If it depends on runtime information like the current time, use `final`."

**Key emphasis:** The `$variable` vs `${expression}` distinction. Simple variables use `$`, expressions need curly braces. This trips students up in every exercise.

#### 0:15--0:25 --- Student Work on Exercises 1--2 (10 min)

**Say:** "Open `exercises.dart`. Complete Exercise 1 (Patient Greeting) and Exercise 2 (Variable Declarations). You have 10 minutes. Run the file with `dart run exercises.dart` to test. Raise your hand if you get stuck."

**Walk around the room.** Common issues:

- Forgetting the `$` in string interpolation
- Using `+` to concatenate strings instead of interpolation (works but not idiomatic Dart)
- Not knowing how to run the file -- remind them: `dart run exercises.dart` or `dart exercises.dart`
- Exercise 2: confusing `final` and `const` -- ask them "Can you know this value before the program runs?"

**Checkpoint:** "Who can tell me the output of `greetPatient('Alice', 30)`? What type did Dart assign to the `pi` variable in Exercise 2?" Pick a student to answer.

#### Exercise 1 Solution

```dart
String greetPatient(String name, int age) {
  return 'Hello, $name! You are $age years old. Next year you will be ${age + 1}.';
}
```

**Key teaching moment:** `${age + 1}` requires curly braces because it is an expression, not a simple variable reference. `$age` alone works fine. This is the single most common mistake in this exercise.

#### Exercise 2 Solution

```dart
Map<String, dynamic> declareVariables() {
  String name = 'Jan Kowalski';
  int age = 21;
  double height = 1.78;
  bool isStudent = true;
  final String university = 'AGH';
  const double pi = 3.14159;

  return {
    'name': name,
    'age': age,
    'height': height,
    'isStudent': isStudent,
    'university': university,
    'pi': pi,
  };
}
```

**Common pitfall:** Students may try `const university = 'AGH';` -- that actually works for a string literal (it is a compile-time constant). The point of the exercise is to demonstrate `final`, so redirect them: "Both work here, but the exercise asks you to use `final` for `university` and `const` for `pi`. In practice, `final` is far more common because most values are determined at runtime."

**Recovery if behind:** If many students are stuck, live-code Exercise 1 together and let them do Exercise 2 independently in the remaining time.

---

### 0:25--0:40 --- Part 2: Functions (15 min)

**Type:** Demo (first half) + student work (second half)

**Pacing:** 7 minutes of demo, 8 minutes of student work on Exercises 3--4.

#### 0:25--0:32 --- Functions Demo (7 min)

**Demo on projector:**

```dart
// Basic function (familiar from C++)
double calculateArea(double width, double height) {
  return width * height;
}

// Arrow syntax -- same thing, one line
double calculateArea2(double w, double h) => w * h;

// Named parameters (like Python kwargs, but with {} syntax)
void logVitals({required String patientId, required int heartRate, double? temp}) {
  print('Patient $patientId: HR=$heartRate, Temp=${temp ?? "N/A"}');
}

// Calling with named parameters
logVitals(patientId: 'P001', heartRate: 72, temp: 36.6);
logVitals(patientId: 'P002', heartRate: 80);  // temp is optional

// Optional positional parameters
String greet(String name, [String? title]) {
  if (title != null) return '$title $name';
  return name;
}
```

**Talking points:**

- "Arrow syntax is for single-expression functions. If your function body is one `return` statement, you can use `=>`."
- "Named parameters go inside `{}` in the signature. Mark required ones with `required`. This is like Python's `def f(*, param=...)` but with explicit syntax."
- "Optional positional parameters go inside `[]`. You can give them default values."
- "Notice the `??` operator in the `logVitals` function -- that is a preview of null safety, which we cover in Part 4."

**What to watch for:**

- Students confusing `{}` (named parameters) with `[]` (optional positional parameters)
- Students forgetting `required` on named parameters -- Dart will allow it but the parameter becomes optional with a default of `null`

#### 0:32--0:40 --- Student Work on Exercises 3--4 (8 min)

**Say:** "Complete Exercises 3 and 4. Exercise 3 uses named parameters. Exercise 4 asks for arrow syntax. You have 8 minutes."

**Walk around the room.** Common issues:

- Exercise 3: Students forget to round the BMI result. Hint: `double.parse(bmi.toStringAsFixed(1))` -- this converts to string with 1 decimal, then back to double.
- Exercise 4: Students write a full function body instead of arrow syntax. Remind them: replace the `{ return ...; }` with `=> ...;`

**Checkpoint:** "What is `calculateBMI(weightKg: 70.0, heightM: 1.75)`? It should be `22.9`."

#### Exercise 3 Solution

```dart
double calculateBMI({required double weightKg, required double heightM}) {
  double bmi = weightKg / (heightM * heightM);
  return double.parse(bmi.toStringAsFixed(1));
}
```

**Teaching moment:** The rounding approach `toStringAsFixed(1)` then `double.parse()` is a common Dart idiom. Students from C++ may want to use `round()` or manual math -- that is also acceptable, but this approach is cleaner.

#### Exercise 4 Solution

```dart
String formatVitals(int heartRate, [double temperature = 36.6]) =>
    'HR: $heartRate bpm, Temp: $temperature C';
```

**Common pitfall:** Students may try to keep the curly braces AND use `=>`. Arrow syntax replaces the entire body. The signature already has `[double temperature = 36.6]` -- students just need to replace the body.

---

### 0:40--0:45 --- Break / Catch-Up Buffer (5 min)

- Students who finished Exercises 1--4: take a real break
- Students who are behind: use this time to catch up on any unfinished exercises
- Walk around and verify everyone has at least Exercises 1--2 working
- If everyone is done, use this time for Q&A: "What is the difference between `final` and `const`? When do you use named vs positional parameters?"
- Answer individual questions about syntax or tooling

---

### 0:45--1:00 --- Part 3: Collections (15 min)

**Type:** Demo (first half) + student work (second half)

**Pacing:** 7 minutes of demo, 8 minutes of student work on Exercises 5--6.

#### 0:45--0:52 --- Collections Demo (7 min)

**Demo on projector:**

```dart
// List (like Python list / C++ vector)
List<int> heartRates = [72, 85, 110, 65, 95];

// Functional operations
var elevated = heartRates.where((hr) => hr > 100).toList();  // [110]
var doubled = heartRates.map((hr) => hr * 2).toList();       // [144, 170, ...]
var total = heartRates.fold(0, (sum, hr) => sum + hr);       // 427

// Map (like Python dict)
Map<String, int> vitals = {'heartRate': 72, 'systolic': 120};
vitals['spO2'] = 98;  // add entry

// Set (like Python set)
Set<String> allergies = {'penicillin', 'aspirin'};
Set<String> drugs = {'aspirin', 'ibuprofen'};
var common = allergies.intersection(drugs);  // {'aspirin'}
var safe = drugs.difference(allergies);      // {'ibuprofen'}
```

**Key emphasis: The `fold` method.** This is the one that confuses students most. Walk through it step by step:

Draw on the whiteboard or type as comments:

```
heartRates.fold(0, (sum, hr) => sum + hr)
  Start:  sum = 0
  Step 1: sum = 0 + 72 = 72
  Step 2: sum = 72 + 85 = 157
  Step 3: sum = 157 + 110 = 267
  Step 4: sum = 267 + 65 = 332
  Step 5: sum = 332 + 95 = 427
```

**Talking point:** "`fold` is like Python's `reduce` or `functools.reduce`. The first argument is the initial value, and the function combines the accumulator with each element. In healthcare apps, you will use this for computing averages, totals, and aggregations over patient data."

**What to watch for:**

- Students not calling `.toList()` after `.where()` or `.map()` -- these return lazy iterables, not lists
- Confusion about the `=>` inside the callbacks -- it is just the arrow syntax for anonymous functions

#### 0:52--1:00 --- Student Work on Exercises 5--6 (8 min)

**Say:** "Exercises 5 and 6. Exercise 5 uses List operations -- `where`, `fold`, `toList`. Exercise 6 uses Set operations -- `intersection`, `difference`, `union`. You have 8 minutes."

**Walk around the room.** Common issues:

- Exercise 5: The `fold` call is the hardest part. If a student is stuck, point them to the whiteboard walkthrough. An alternative is `readings.reduce((a, b) => a + b)` for sum, but `fold` works for empty lists too (reduce throws on empty lists).
- Exercise 5: Forgetting to round the average to 1 decimal place (same pattern as Exercise 3)
- Exercise 6: Students may try to implement set operations manually with loops. Redirect them: "Dart has built-in methods for this. Check `intersection`, `difference`, and `union`."

**Checkpoint:** "What are the elevated heart rates from `[72, 85, 110, 65, 95, 130, 58]`? They should be `[110, 130]`."

#### Exercise 5 Solution

```dart
Map<String, dynamic> analyzeHeartRates(List<int> readings) {
  int count = readings.length;
  double average = double.parse(
      (readings.fold(0, (sum, hr) => sum + hr) / count).toStringAsFixed(1));
  List<int> elevated = readings.where((hr) => hr > 100).toList();
  List<int> normal = readings.where((hr) => hr >= 60 && hr <= 100).toList();

  return {
    'count': count,
    'average': average,
    'elevated': elevated,
    'normal': normal,
  };
}
```

**Teaching moment:** The `.where()` method is Dart's equivalent of Python's `filter()` or a list comprehension with an `if` clause. The lambda `(hr) => hr > 100` is the predicate. Students from C++ will recognize this pattern from `std::copy_if` or `std::remove_if`, but Dart's syntax is much cleaner.

#### Exercise 6 Solution

```dart
Map<String, Set<String>> checkAllergies(
    Set<String> patientAllergies, Set<String> prescribedDrugs) {
  Set<String> dangerous = patientAllergies.intersection(prescribedDrugs);
  Set<String> safe = prescribedDrugs.difference(patientAllergies);
  Set<String> allKnown = patientAllergies.union(prescribedDrugs);

  return {
    'safe': safe,
    'dangerous': dangerous,
    'allKnown': allKnown,
  };
}
```

**Healthcare context:** "This is a real pattern in clinical decision support systems. Before prescribing a drug, the system checks the patient's known allergies against the prescription. The `intersection` gives you the dangerous conflicts. In a real app, this check would trigger a warning dialog."

---

### 1:00--1:20 --- Part 4: Null Safety (20 min)

**Type:** Demo (first half) + student work (second half)

**This is the biggest conceptual hurdle for most students.** Budget extra time here.

**Pacing:** 10 minutes of demo and explanation, 10 minutes of student work on Exercises 7--8.

#### 1:00--1:10 --- Null Safety Demo (10 min)

**Demo on projector:**

```dart
// Non-nullable by default
String name = 'Alice';
// name = null;  // COMPILE ERROR

// Nullable with ?
String? diagnosis;
print(diagnosis);  // prints: null

// You cannot call methods on nullable types
// print(diagnosis.length);  // COMPILE ERROR

// Null-aware operators
String label = diagnosis ?? 'No diagnosis';
int? length = diagnosis?.length;

// The dangerous ! operator
// String sure = diagnosis!;  // Throws at runtime if null!
```

**Key talking points:**

- "In C++, a null pointer dereference crashes your program at runtime. In Python, `None.something` throws an `AttributeError` at runtime. In Dart, the compiler catches this at compile time. This is a massive safety improvement."
- "The `?` after a type means 'this can be null.' Without `?`, the compiler guarantees it is never null."
- "There are four null-aware operators. Today we focus on `??` (if-null) and `?.` (conditional access). Avoid `!` unless you are absolutely certain the value is not null."

**Draw on the whiteboard:**

```
Non-nullable:   String name    -- NEVER null, compiler enforces
Nullable:       String? name   -- MIGHT be null, compiler forces you to handle it

Operators:
  ??   ->  "use this default if null"
  ?.   ->  "call this method only if non-null"
  !    ->  "I PROMISE this is not null" (dangerous -- avoid)
  ??=  ->  "assign only if currently null"
```

**What to watch for:**

- Students who want to use `!` everywhere -- strongly discourage this. "Every `!` is a potential crash waiting to happen. Use `??` instead."
- Students confused about when Map lookups return nullable values: `map[key]` always returns `T?` because the key might not exist

#### 1:10--1:20 --- Student Work on Exercises 7--8 (10 min)

**Say:** "Exercises 7 and 8. Exercise 7 is a patient lookup from a Map -- notice that `database[patientId]` returns `String?` because the ID might not exist. Exercise 8 asks you to handle three nullable parameters using `??`. You have 10 minutes."

**Walk around the room.** Common issues:

- Exercise 7: Students want to use `if/else`. The exercise specifically says to use null-aware operators. Point them to the ternary operator with null check: `name != null ? ... : ...` or a creative use of `??`.
- Exercise 8: Students overthink this. Each nullable parameter just needs a `?? defaultValue`.
- Some students may try `name!` or `age!` -- redirect them to `??` instead.

**Checkpoint:** "What does `fixNullSafety(null, null, null)` return? It should be `'Unknown (age 0) - Diagnosis: Not diagnosed'`."

#### Exercise 7 Solution

```dart
String safePatientLookup(Map<String, String> database, String patientId) {
  String? name = database[patientId];
  return name != null ? 'Patient found: $name' : 'Patient not found';
}
```

**Note:** An alternative approach using `??` is also acceptable:

```dart
return 'Patient: ${database[patientId] ?? "not found"}';
```

The first version matches the required output format more precisely. Accept either approach.

#### Exercise 8 Solution

```dart
String fixNullSafety(String? name, int? age, String? diagnosis) {
  String safeName = name ?? 'Unknown';
  int safeAge = age ?? 0;
  String safeDiagnosis = diagnosis ?? 'Not diagnosed';
  return '$safeName (age $safeAge) - Diagnosis: $safeDiagnosis';
}
```

**Teaching moment:** "This pattern -- receiving nullable data and immediately providing defaults with `??` -- is extremely common in healthcare apps. Patient records often have missing fields. Null safety forces you to handle every missing value explicitly, which prevents the 'NullPointerException' crashes you may have experienced in other languages."

**Common pitfall:** Students who inline everything: `return '${name ?? "Unknown"} (age ${age ?? 0}) - Diagnosis: ${diagnosis ?? "Not diagnosed"}'`. This works but is harder to read. Encourage them to use intermediate variables for clarity.

---

### 1:20--1:25 --- Break / Catch-Up Buffer (5 min)

- Students who finished Exercises 1--8: take a real break. They are in great shape.
- Students who are behind: use this time to catch up. Exercises 7--8 are the minimum from Part 4.
- Walk around and verify everyone has at least Exercises 1--6 working
- Quick check: "How many of you have all 8 exercises done? How many have at least 6? How many have at least 4?"
- If less than 60% have 6+ done, consider shortening Part 5 and focusing on Exercise 9 only

---

### 1:25--1:50 --- Part 5: OOP (25 min)

**Type:** Demo (first half) + student work (second half)

**Pacing:** 12 minutes of demo, 13 minutes of student work on Exercises 9--10.

#### 1:25--1:30 --- Basic Class Demo (5 min)

**Demo on projector:**

```dart
class Patient {
  String name;
  int age;
  String? diagnosis;

  // Constructor shorthand -- Dart auto-assigns fields
  Patient(this.name, this.age, {this.diagnosis});

  String summary() => '$name, age $age, diagnosis: ${diagnosis ?? "pending"}';
}

var p = Patient('Alice', 30, diagnosis: 'Hypertension');
print(p.summary());
```

**Talking point:** "Compare this to C++: no header file, no `new` keyword (optional in Dart), and `this.name` in the constructor parameter list auto-assigns the field. In C++ you would need a separate initialization list or assignments in the constructor body. Dart handles all of that with `this.name`."

**What to watch for:**

- Students who try to write C++-style constructors with explicit assignment in the body. That works but is not idiomatic Dart.
- Confusion about `{this.diagnosis}` -- the curly braces make it a named parameter. Without braces, it would be a required positional parameter.

#### 1:30--1:35 --- Inheritance Demo (5 min)

**Demo on projector:**

```dart
class Person {
  String name;
  int age;
  Person(this.name, this.age);
  String introduce() => 'I am $name, age $age.';
}

class Doctor extends Person {
  String specialization;
  Doctor(super.name, super.age, this.specialization);

  @override
  String introduce() => 'I am $name, age $age. Specialization: $specialization.';
}
```

**Key emphasis:** The `super.name, super.age` syntax in the constructor. "This tells Dart to pass these parameters up to the parent constructor. The `super.` prefix is Dart 3 syntax -- you may see older code using `: super(name, age)` in an initializer list. Both work."

#### 1:35--1:37 --- Mixin Preview (2 min)

**Brief demo on projector:**

```dart
mixin Loggable {
  void log(String msg) => print('[LOG] $msg');
}

class Doctor extends Person with Loggable {
  // ... now Doctor has a log() method
}
```

**Talking point:** "Mixins are like pluggable behaviors. You can add them to any class with the `with` keyword. Unlike multiple inheritance in C++, Dart's mixins have a clear linear ordering, which avoids the diamond problem. Think of them as interfaces with implementations."

#### 1:37--1:50 --- Student Work on Exercises 9--10 (13 min)

**Say:** "Exercises 9 and 10. Exercise 9 is a class hierarchy: Person, Patient, Doctor. Exercise 10 is a mixin called Timestamped plus a MedicalRecord class. Start with Exercise 9. If you finish it, move to Exercise 10. You have 13 minutes."

**Important:** Tell students to uncomment the test code in `main()` for Exercises 9 and 10 after implementing the classes. The test code is commented out because the placeholder classes would produce empty output.

**Walk around the room.** Common issues:

- Exercise 9: Students forget `super.name, super.age` in the child constructor. They may try `Patient(this.name, this.age)` which conflicts with the parent.
- Exercise 9: Students forget `@override` on the `introduce()` method. It will work without it, but the linter will warn.
- Exercise 10: The `createdAt` field in the mixin needs to be `final DateTime createdAt = DateTime.now();`. Students may try to put it in a constructor -- mixins cannot have constructors.
- Exercise 10: The `padLeft(2, '0')` pattern for formatting dates is new. Walk a struggling student through it: "`.toString()` gives you `'3'`, and `.padLeft(2, '0')` turns it into `'03'`."

**Checkpoint:** "What does `Patient('Alice', 30, diagnosis: 'Hypertension').introduce()` return? It should be `'I am Alice, age 30. Diagnosis: Hypertension.'`"

#### Exercise 9 Solution

```dart
class Person {
  String name;
  int age;

  Person(this.name, this.age);

  String introduce() => 'I am $name, age $age.';
}

class Patient extends Person {
  String? diagnosis;

  Patient(super.name, super.age, {this.diagnosis});

  @override
  String introduce() =>
      'I am $name, age $age. Diagnosis: ${diagnosis ?? "pending"}.';
}

class Doctor extends Person {
  String specialization;

  Doctor(super.name, super.age, this.specialization);

  @override
  String introduce() =>
      'I am $name, age $age. Specialization: $specialization.';
}
```

**Teaching moment:** "Notice how the Patient class uses null safety naturally. The `diagnosis` field is `String?` because a patient may not have a diagnosis yet. The `introduce()` method handles this with `?? "pending"`. This is the kind of design thinking that null safety encourages -- you explicitly model the possibility of missing data."

#### Exercise 10 Solution

```dart
mixin Timestamped {
  final DateTime createdAt = DateTime.now();

  String timeStamp() {
    String year = createdAt.year.toString();
    String month = createdAt.month.toString().padLeft(2, '0');
    String day = createdAt.day.toString().padLeft(2, '0');
    String hour = createdAt.hour.toString().padLeft(2, '0');
    String minute = createdAt.minute.toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$minute';
  }
}

class MedicalRecord with Timestamped {
  String patientName;
  String description;

  MedicalRecord(this.patientName, this.description);

  String summary() => '[${timeStamp()}] $patientName: $description';
}
```

**Common pitfall:** Students may try to use `DateTime.now().toString()` and substring it. That works but produces a less clean format and breaks if the format changes between Dart versions. The manual approach with `padLeft` is more explicit and reliable.

**Recovery if behind:** If time is tight, show the Exercise 9 solution on the projector and have students type it in. Skip Exercise 10 entirely -- it can be homework. Exercise 9 (class hierarchy) is more important for understanding Flutter widgets later.

---

### 1:50--2:00 --- Part 6: Async Programming + Assignment Intro (10 min)

**Type:** Demo (5 min) + assignment intro (5 min)

**This section is intentionally brief.** Async programming is a preview for later weeks when students build apps that make network calls. The goal is exposure, not mastery.

#### 1:50--1:55 --- Async Demo (5 min)

**Demo on projector:**

```dart
Future<Map<String, dynamic>> fetchPatientData(String id) async {
  print('Fetching data for patient $id...');
  await Future.delayed(Duration(seconds: 1));
  return {'id': id, 'name': 'Patient $id', 'heartRate': 72};
}

// In main():
var data = await fetchPatientData('P001');
print(data);
```

**Talking points:**

- "`async` marks a function that does work over time. `await` pauses until the result is ready."
- "`Future<T>` is like a promise -- it will eventually contain a value of type `T`."
- "In a real health app, this is how you fetch patient records from a server, retrieve sensor data from a device, or call a machine learning API."
- "`Future.delayed` simulates a network call. In real code, this would be an HTTP request."

**If students have time, they should complete Exercises 11 and 12.** If not, these can be homework.

#### Exercise 11 Solution

```dart
Future<Map<String, dynamic>> fetchPatientData(String id) async {
  print('Fetching data for patient $id...');
  await Future.delayed(Duration(seconds: 1));
  return {'id': id, 'name': 'Patient $id', 'heartRate': 72};
}
```

#### Exercise 12 Solution

```dart
Future<List<Map<String, dynamic>>> fetchMultiplePatients() async {
  List<Map<String, dynamic>> results = await Future.wait([
    fetchPatientData('P001'),
    fetchPatientData('P002'),
    fetchPatientData('P003'),
  ]);
  return results;
}
```

**Teaching moment for Exercise 12:** "Notice that `Future.wait` runs all three calls in parallel, not sequentially. If each call takes 1 second, `Future.wait` finishes in ~1 second total, not 3. This is critical for performance in health apps -- imagine loading a patient's vitals, medications, and appointments all at once instead of one after another."

#### 1:55--2:00 --- Assignment Introduction (5 min)

**Talking points:**

- Walk through the Mood Logger assignment in the workbook
- "You will build a command-line mood tracking app. It uses everything from today: classes, collections, null safety, string formatting."
- Show the starter template: `mood_logger_template.dart`. "The template has the structure laid out. Your job is to fill in the TODOs."
- Emphasize the interactive CLI requirement: "The app should loop, display a menu, and respond to user input. Use `stdin.readLineSync()` to read input."
- Deadline: before the next lab session
- "This is individual work. No AI tools. The point is to practice what you learned today."
- Show the grading rubric briefly (in the workbook)

**Final words:**

- "You just learned the core of Dart in 2 hours. That is a lot. It will not all stick immediately -- that is normal."
- "The most important concepts from today: types and type inference, null safety with `??`, and basic classes. You will use these every day in Flutter."
- "If you did not finish all 12 exercises, finish them at home before starting the assignment. They build the foundation."
- "Next week we start Flutter. Everything you learned today will be used immediately."

---

## Instructor Notes: Pacing & Common Issues

### Where Students Typically Get Stuck

1. **Running Dart files.** Students try `dart run exercises.dart` vs `dart exercises.dart`. Both work, but some students type random variations. If they are in the wrong directory, they get "file not found." Remind them to `pwd` and `ls` first.

2. **String interpolation syntax.** Forgetting `$` or confusing `$variable` with `${expression}`. This error shows up in almost every exercise. Repeat the rule: "Simple variable? Dollar sign. Expression with operators or method calls? Dollar sign plus curly braces."

3. **The `.where()` / `.map()` / `.fold()` chain in Exercise 5.** Students from C++ backgrounds have not seen functional-style collection operations. Walk through `fold` step by step on the whiteboard. Compare to a `for` loop that does the same thing.

4. **Null-aware operators (`??`, `?.`, `!`).** Students overuse `!` because it is the simplest way to "make the error go away." Strongly discourage this. Every `!` is a potential runtime crash. Teach them to reach for `??` first.

5. **Mixin syntax.** The `with` keyword is unique to Dart. Students may confuse it with `extends` or `implements`. Quick rule: "`extends` for inheritance (one parent), `implements` for interfaces (must override everything), `with` for mixins (plug-in behavior)."

6. **`Future.wait()` in Exercise 12.** The concept of running async operations in parallel is new. Students may try to `await` each call sequentially, which works but defeats the purpose.

### Where to Slow Down

- **Part 1:** The `final` vs `const` distinction. Spend an extra minute on this if students are confused. Use concrete examples: "Can you know this value at compile time?"
- **Part 3:** The `fold` method. Do the step-by-step walkthrough on the whiteboard. Do not skip this.
- **Part 4:** Null safety overall. This is the biggest conceptual shift from C++/Python. Spend the full 20 minutes here if needed.

### Where You Can Speed Up

- **Part 2:** If students already understand Python kwargs, named parameters in Dart will click quickly. The arrow syntax is straightforward.
- **Part 5:** If time is short, demo Exercise 9 live and skip Exercise 10 (mixins). Mixins are a nice-to-have but not critical for next week.
- **Part 6:** This is a preview. If time is very tight, show the Exercise 11 solution on the projector, briefly mention `Future.wait`, and move to the assignment intro.

### If You Are Running Out of Time

Priority order (must complete):

1. **Parts 1--4 (Exercises 1--8)** -- core language features. These are non-negotiable. Every Flutter app uses types, functions, collections, and null safety.
2. **Part 5, Exercise 9** (basic class hierarchy) -- needed for understanding Flutter widgets, which are all classes.
3. **Part 6, Exercise 11** (single async call) -- needed for API work in later weeks.
4. **Exercise 10** (mixins) and **Exercise 12** (`Future.wait`) -- can be assigned as homework.

Can be shortened:

- Part 2 demo (reduce from 7 to 4 min if students grasp named parameters quickly)
- Part 5 demo (skip the mixin preview, go straight to student work on Exercise 9)
- Part 6 demo (show the solution, explain briefly, skip student work time)

### If You Have Extra Time

- Show Dart's `enum` type with a healthcare example (e.g., `enum BloodType { A, B, AB, O }`)
- Explore `switch` expressions (Dart 3 feature) with pattern matching
- Demo `toString()` override on the Person class
- Have students extend Exercise 5 to also compute min and max heart rates
- Discuss how Exercise 6 (allergy checker) would work in a real clinical decision support system
- Preview Flutter: "Next week, every widget you build will be a Dart class with a `build()` method. The OOP from today is the foundation."

---

## Complete Mood Logger Assignment Solution

Below is the full working solution for the CLI Mood Logger assignment. Use this if you need to verify a student's submission or quickly demonstrate the expected behavior.

**File:** `mood_logger_solution.dart`

```dart
import 'dart:io';

// ============================================================================
// MoodEntry Class
// ============================================================================

class MoodEntry {
  final DateTime timestamp;
  final int score;
  final String note;

  MoodEntry(this.score, this.note) : timestamp = DateTime.now();

  @override
  String toString() {
    String year = timestamp.year.toString();
    String month = timestamp.month.toString().padLeft(2, '0');
    String day = timestamp.day.toString().padLeft(2, '0');
    String hour = timestamp.hour.toString().padLeft(2, '0');
    String minute = timestamp.minute.toString().padLeft(2, '0');
    return '[$year-$month-$day $hour:$minute] Score: $score/10 - $note';
  }
}

// ============================================================================
// MoodLogger Class
// ============================================================================

class MoodLogger {
  final List<MoodEntry> _entries = [];

  void addEntry(int score, String note) {
    if (score < 1 || score > 10) {
      print('Error: Score must be between 1 and 10.');
      return;
    }
    _entries.add(MoodEntry(score, note));
    print('Entry added!');
  }

  List<MoodEntry> getAllEntries() {
    return List.from(_entries);
  }

  double getAverageScore() {
    if (_entries.isEmpty) return 0.0;
    int total = _entries.fold(0, (sum, entry) => sum + entry.score);
    return total / _entries.length;
  }

  List<MoodEntry> getEntriesAbove(int threshold) {
    return _entries.where((entry) => entry.score >= threshold).toList();
  }

  int get entryCount => _entries.length;
}

// ============================================================================
// Main -- Interactive CLI
// ============================================================================

void main() {
  final logger = MoodLogger();

  print('=== Mood Logger ===');
  print('Track your daily mood on a scale of 1-10.\n');

  bool running = true;
  while (running) {
    print('1. Add mood entry');
    print('2. View all entries');
    print('3. View average mood');
    print('4. Filter by minimum score');
    print('5. Quit');
    stdout.write('\nChoose an option: ');

    String? input = stdin.readLineSync();
    int? choice = int.tryParse(input ?? '');

    switch (choice) {
      case 1:
        stdout.write('Enter mood score (1-10): ');
        String? scoreInput = stdin.readLineSync();
        int? score = int.tryParse(scoreInput ?? '');

        if (score == null) {
          print('Invalid score. Please enter a number.');
          break;
        }

        stdout.write('Enter a note: ');
        String note = stdin.readLineSync() ?? '';

        logger.addEntry(score, note);
        break;

      case 2:
        var entries = logger.getAllEntries();
        if (entries.isEmpty) {
          print('No entries yet. Add your first mood entry!');
        } else {
          print('\n--- All Entries (${entries.length}) ---');
          for (var entry in entries) {
            print(entry);
          }
        }
        break;

      case 3:
        if (logger.entryCount == 0) {
          print('No entries yet. Add some entries first!');
        } else {
          double avg = logger.getAverageScore();
          print('Average mood score: ${avg.toStringAsFixed(1)} '
              '(based on ${logger.entryCount} entries)');
        }
        break;

      case 4:
        stdout.write('Enter minimum score threshold: ');
        String? thresholdInput = stdin.readLineSync();
        int? threshold = int.tryParse(thresholdInput ?? '');

        if (threshold == null) {
          print('Invalid threshold. Please enter a number.');
          break;
        }

        var filtered = logger.getEntriesAbove(threshold);
        if (filtered.isEmpty) {
          print('No entries with score >= $threshold.');
        } else {
          print('\n--- Entries with score >= $threshold (${filtered.length}) ---');
          for (var entry in filtered) {
            print(entry);
          }
        }
        break;

      case 5:
        running = false;
        print('Goodbye!');
        break;

      default:
        print('Invalid option. Please choose 1-5.');
    }
    print('');
  }
}
```

### Mood Logger Grading Notes

When grading student submissions, look for:

| Criterion | What to check | Common deductions |
|-----------|---------------|-------------------|
| MoodEntry class (2 pts) | Fields, constructor with `DateTime.now()`, `toString()` formatting | Missing timestamp, no `padLeft` formatting (minor), wrong field types |
| MoodLogger class (3 pts) | Private `_entries` list, all 4 methods + getter, validation in `addEntry`, `fold` in `getAverageScore` | Public list instead of private (-0.5), no score validation (-0.5), empty list not handled in average (-0.5) |
| Interactive CLI (3 pts) | Menu loop, `stdin.readLineSync()`, `int.tryParse()`, all 5 options working | No loop (-1), no input validation (-0.5), missing menu options (-0.5 each) |
| Code quality (2 pts) | Clear naming, proper null safety, no unnecessary `!` operators, consistent formatting | Using `!` instead of `??` (-0.5), poor naming (-0.5), no comments at all (-0.5) |

**Accept alternative implementations** as long as they meet the requirements. For example:

- Using `reduce` instead of `fold` for the average (fine, but does not handle empty lists safely)
- Using `DateFormat` from `intl` package instead of manual padding (fine, shows initiative)
- Adding extra features like editing or deleting entries (great, give bonus consideration)
- Different menu formatting (fine, as long as all options are present)

---

## End-of-Lab Assessment

### Minimum Completion Checklist

Every student should leave the lab with:

- [ ] Dart SDK working (`dart --version`)
- [ ] Exercises 1--8 completed (Parts 1--4 -- the core language features)
- [ ] At least attempted Exercises 9--10 (OOP)
- [ ] Understands the Mood Logger assignment requirements
- [ ] Can run a Dart file from the terminal

### Quick Verification Method

In the last 2 minutes, ask students to run:

```bash
dart run exercises.dart
```

Students who see output for Exercises 1--8 (no empty strings, no zeros where values should be) are in good shape. The Exercises 9--10 test output will say "(Uncomment the test code...)" if they have not yet uncommented it -- that is acceptable as long as they implemented the classes.

### For Students Who Did Not Finish

- Reassure them: "The workbook has all the explanations. The exercises build on each other. Finish at home before starting the Mood Logger assignment."
- Minimum viable: Exercises 1--8. If they have those, they have enough Dart knowledge to start Flutter next week.
- Exercises 9--12 should be completed at home before the next lab.
- Remind them the assignment deadline is before the next lab session.
- Point them to [dart.dev/language](https://dart.dev/language) for the official Dart language tour.
- "The lecture will reinforce what you practiced today. See you there."
