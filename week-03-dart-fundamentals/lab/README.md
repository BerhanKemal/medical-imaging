# Week 3 Lab -- Dart Fundamentals

> **Course:** Mobile Apps for Healthcare
> **Duration:** ~2 hours
> **Prerequisites:** Basic programming experience (Python, C/C++, or similar), basic terminal skills
> **AI Policy:** No AI tools (ChatGPT, Copilot, etc.) allowed in Weeks 1–3. Write all code yourself.

---

## Environment Setup

Before you begin, make sure you have the Dart SDK installed and available in your terminal.

!!! note "Already installed Flutter?"
    If you installed the Flutter SDK in Week 0, **Dart is already included** — you can skip the installation below. Verify by running `dart --version`. If it works, jump straight to "Running Dart files."

### Install Dart SDK

=== "macOS"

    ```bash
    brew tap dart-lang/dart
    brew install dart
    ```

=== "Linux"

    ```bash
    sudo apt-get update
    sudo apt-get install apt-transport-https
    sudo sh -c 'wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'
    sudo sh -c 'wget -qO- https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'
    sudo apt-get update
    sudo apt-get install dart
    ```

=== "Windows"

    ```powershell
    choco install dart-sdk
    ```

    If you don't have Chocolatey, you can install Dart via the [official installer](https://dart.dev/get-dart) or use `winget install Dart.Dart-SDK`.

**Verify installation:**

```bash
dart --version
```

You should see output like `Dart SDK version: 3.x.x`. Any 3.x version is fine.

### Running Dart files

```bash
dart run my_file.dart
```

> **Note:** You can also use the shorthand `dart my_file.dart` (without `run`), which works identically. This course uses `dart run` for clarity.

### Lab files

The exercise files are provided in the course materials at:

```
week-03-dart-fundamentals/lab/
├── exercises.dart              # All exercises for Parts 1-6
└── mood_logger_template.dart   # Starter template for the assignment
```

These files are in the course materials repository you cloned in Week 0 (see [Getting Ready](../../resources/GETTING_READY.md#step-8-clone-the-course-materials-repository)). Open `exercises.dart` in your editor. Each exercise is a function stub with a `// TODO` marker. Implement the function body, then run the file to test your solutions. The `main()` function at the bottom calls each exercise so you can see the output.

!!! example "Healthcare context"
    Dart's strong type system and null safety are particularly valuable in healthcare apps. When processing a blood glucose reading, you want the compiler to guarantee that a `double glucoseValue` is never accidentally `null` or confused with a `String`. Type safety catches bugs at compile time that could otherwise lead to incorrect health data being displayed to patients.

---

## Part 1: Variables, Types & Basics (~20 min)

Dart is a statically typed language, similar to C++ but with modern conveniences like type inference (similar to `auto` in C++11 or Python's dynamic typing, except the type is still checked at compile time).

### Core types

| Dart type  | C/C++ equivalent    | Python equivalent | Example                |
|------------|----------------------|-------------------|------------------------|
| `int`      | `int` / `long`       | `int`             | `int age = 25;`        |
| `double`   | `double`             | `float`           | `double temp = 36.6;`  |
| `String`   | `std::string`        | `str`             | `String name = 'Ada';` |
| `bool`     | `bool`               | `bool`            | `bool alive = true;`   |
| `var`      | `auto`               | _(default)_       | `var x = 42;`          |

### Type inference with `var`

```dart
var patientName = 'John';   // Dart infers String
var heartRate = 72;          // Dart infers int
// patientName = 42;         // ERROR: patientName is locked to String
```

This is like `auto` in C++, not like Python where you can reassign any type to a variable.

### `final` vs `const`

Both prevent reassignment, but they differ in **when** the value is determined:

| Keyword | When resolved | C++ analogy | Example |
|---------|---------------|-------------|---------|
| `final` | At **runtime** | `const` on a variable you set once at runtime | `final now = DateTime.now();` |
| `const` | At **compile time** | `constexpr` | `const pi = 3.14159;` |

Think of `final` as "set once, never change" and `const` as "known before the program even runs."

```dart
final timestamp = DateTime.now();  // OK: computed at runtime
// const timestamp = DateTime.now();  // ERROR: DateTime.now() is not a compile-time constant

const maxHeartRate = 220;  // OK: literal value, known at compile time
```

### String interpolation

Dart uses `$variable` and `${expression}` inside strings -- similar to Python f-strings but with a `$` instead of `{}`:

```dart
String name = 'Alice';
int age = 23;

// Simple variable:
print('Hello, $name!');

// Expression:
print('Next year you will be ${age + 1}.');

// Multi-line strings (like Python triple quotes):
String report = '''
Patient: $name
Age: $age
Status: stable
''';
```

### Exercises

Complete **Exercises 1 and 2** in `exercises.dart`.

### Self-Check: Part 1

- [ ] You can declare variables with explicit types (`int`, `String`) and with `var`.
- [ ] You can explain the difference between `final` (runtime) and `const` (compile-time).
- [ ] You can use string interpolation with `$variable` and `${expression}`.
- [ ] Exercises 1 and 2 produce the expected output when you run the file.

---

## Part 2: Functions (~15 min)

Dart functions will feel familiar coming from both C++ and Python, but with some unique features.

### Basic functions (like C++)

```dart
double calculateBMI(double weightKg, double heightM) {
  return weightKg / (heightM * heightM);
}
```

### Arrow syntax (for one-expression bodies)

```dart
double calculateBMI(double weightKg, double heightM) => weightKg / (heightM * heightM);
```

This is similar to Python lambdas but can be used for named functions too.

### Named parameters (like Python keyword arguments)

```dart
void logVitals({required String patientId, required int heartRate, double? temperature}) {
  print('Patient $patientId: HR=$heartRate, Temp=${temperature ?? "N/A"}');
}

// Calling:
logVitals(patientId: 'P001', heartRate: 72, temperature: 36.6);
logVitals(patientId: 'P002', heartRate: 80);  // temperature is optional
```

Key differences from Python:

- Named parameters go inside `{}` in the function signature.
- You must mark each required named parameter with `required`.
- Optional named parameters can have default values: `{int heartRate = 60}`.

### Positional optional parameters

```dart
String formatName(String first, String last, [String? title]) {
  if (title != null) return '$title $first $last';
  return '$first $last';
}

print(formatName('Marie', 'Curie'));            // Marie Curie
print(formatName('Marie', 'Curie', 'Dr.'));     // Dr. Marie Curie
```

### Exercises

Complete **Exercises 3 and 4** in `exercises.dart`.

### Self-Check: Part 2

- [ ] You can write functions with explicit return types and arrow syntax (`=>`).
- [ ] You understand the difference between named parameters (`{required String name}`) and positional parameters.
- [ ] Exercises 3 and 4 produce the expected output.

---

## Part 3: Collections (~15 min)

Dart has three core collection types. If you know Python lists, dicts, and sets, these map directly.

### List (like Python `list` / C++ `std::vector`)

```dart
List<int> heartRates = [72, 78, 65, 80, 91];

heartRates.add(85);                             // append
heartRates.length;                              // 6

// Functional-style operations (similar to Python list comprehensions):
var elevated = heartRates.where((hr) => hr > 80).toList();   // filter
var doubled  = heartRates.map((hr) => hr * 2).toList();      // transform
var total    = heartRates.fold(0, (sum, hr) => sum + hr);    // reduce/aggregate
```

The `=>` inside `.where()` and `.map()` is an anonymous function (like a C++ lambda or Python lambda).

### Map (like Python `dict` / C++ `std::map`)

```dart
Map<String, int> vitalSigns = {
  'heartRate': 72,
  'systolic': 120,
  'diastolic': 80,
};

vitalSigns['heartRate'];           // 72
vitalSigns['spO2'] = 98;           // add a new entry

// Iterate:
vitalSigns.forEach((key, value) {
  print('$key: $value');
});
```

### Set (like Python `set` / C++ `std::set`)

```dart
Set<String> allergies1 = {'penicillin', 'aspirin'};
Set<String> allergies2 = {'aspirin', 'ibuprofen'};

var common = allergies1.intersection(allergies2);  // {'aspirin'}
var all    = allergies1.union(allergies2);          // {'penicillin', 'aspirin', 'ibuprofen'}
```

### Exercises

Complete **Exercises 5 and 6** in `exercises.dart`.

### Self-Check: Part 3

- [ ] You can create and manipulate `List`, `Map`, and `Set` collections.
- [ ] You can use `.where()`, `.map()`, and `.fold()` for functional-style operations.
- [ ] You understand that `List<int>` means a list that can only contain integers (generic types).

---

## Part 4: Null Safety (~20 min)

This is one of Dart's most important features and one of the biggest differences from C++ and Python. Dart's type system **guarantees** that a non-nullable variable can never be `null` -- this eliminates an entire class of bugs.

### The problem (from your experience)

- **C/C++:** Dereferencing a null pointer causes a segfault. The compiler does not prevent it.
- **Python:** Accessing an attribute on `None` causes `AttributeError` at runtime. No static check.
- **Dart:** The compiler **refuses to compile** code that might use a null value unsafely.

### Non-nullable by default

```dart
String name = 'Alice';  // Can NEVER be null
// name = null;          // COMPILE ERROR
```

### Nullable types with `?`

```dart
String? middleName;       // Can be null (defaults to null)
print(middleName);        // prints: null

// You CANNOT call methods on a nullable type without checking first:
// print(middleName.length);  // COMPILE ERROR
```

### Null-aware operators

| Operator | Name | Example | Meaning |
|----------|------|---------|---------|
| `??` | If-null | `name ?? 'Unknown'` | Use `name` if non-null, otherwise `'Unknown'` |
| `?.` | Conditional access | `name?.length` | Access `length` only if `name` is non-null, otherwise `null` |
| `!` | Null assertion | `name!` | "I promise this is not null" (throws if it is) |
| `??=` | If-null assignment | `name ??= 'Default'` | Assign only if currently null |

```dart
String? diagnosis;

// Safe: use ?? to provide a default
String label = diagnosis ?? 'No diagnosis';

// Safe: use ?. for conditional access
int? length = diagnosis?.length;  // null (no crash)

// Dangerous: use ! only when you are CERTAIN it is not null
// String sure = diagnosis!;  // Would throw at runtime!
```

### The `late` keyword

Use `late` when you know a variable will be initialized before it is used, but you cannot initialize it at declaration time:

```dart
late String patientId;

void loadPatient() {
  patientId = 'P-12345';  // Initialized later
}

void printPatient() {
  print(patientId);  // OK if loadPatient() was called first
}
```

Use `late` sparingly -- if you get it wrong, you get a runtime error instead of a compile-time error.

### Exercises

Complete **Exercises 7 and 8** in `exercises.dart`.

### Self-Check: Part 4

- [ ] You can explain why `String` cannot be `null` but `String?` can.
- [ ] You know when to use `??` (default), `?.` (conditional access), and `!` (assertion) — and why `!` is dangerous.
- [ ] You understand that Dart catches null errors **at compile time**, unlike C++ (segfault) or Python (runtime AttributeError).

---

## Part 5: Object-Oriented Programming (~25 min)

Dart is a fully object-oriented language. If you know C++ classes, you will find Dart familiar but more concise.

### Basic class

```dart
class Patient {
  String name;
  int age;
  String? diagnosis;  // nullable -- patient may not have a diagnosis yet

  // Constructor (shorthand -- Dart assigns fields automatically)
  Patient(this.name, this.age, {this.diagnosis});

  // Method
  String summary() => '$name, age $age, diagnosis: ${diagnosis ?? "pending"}';
}

// Usage:
var p = Patient('Alice', 30, diagnosis: 'Hypertension');
print(p.summary());
```

Compare to C++: no header file, no `new` keyword needed, `this.name` in the constructor parameter list auto-assigns the field.

### Named constructors

```dart
class Temperature {
  double celsius;

  Temperature(this.celsius);

  // Named constructor
  Temperature.fromFahrenheit(double f) : celsius = (f - 32) * 5 / 9;

  // Factory constructor (can return cached instances, subtypes, etc.)
  factory Temperature.normal() => Temperature(36.6);
}

var t1 = Temperature(37.0);
var t2 = Temperature.fromFahrenheit(98.6);
var t3 = Temperature.normal();
```

### Getters and setters

```dart
class BloodPressure {
  int systolic;
  int diastolic;

  BloodPressure(this.systolic, this.diastolic);

  // Getter (computed property)
  String get category {
    if (systolic < 120 && diastolic < 80) return 'Normal';
    if (systolic < 130 && diastolic < 80) return 'Elevated';
    return 'High';
  }
}
```

### Inheritance

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
  String introduce() => '${super.introduce()} Specialization: $specialization.';
}
```

### Abstract classes

```dart
abstract class Shape {
  double area();      // No body -- subclasses MUST implement this
  String describe();  // Same
}

class Circle extends Shape {
  double radius;
  Circle(this.radius);

  @override
  double area() => 3.14159 * radius * radius;

  @override
  String describe() => 'Circle with radius $radius';
}
```

### Mixins

Mixins are Dart's way of sharing behavior across unrelated classes -- something C++ achieves with multiple inheritance and Python with mixins/multiple inheritance. In Dart, you use the `with` keyword:

```dart
mixin Loggable {
  void log(String message) {
    print('[${DateTime.now()}] $message');
  }
}

mixin Serializable {
  Map<String, dynamic> toJson();
}

class Patient extends Person with Loggable, Serializable {
  String? diagnosis;

  Patient(super.name, super.age, {this.diagnosis});

  @override
  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
    'diagnosis': diagnosis,
  };
}

// Usage:
var p = Patient('Bob', 45, diagnosis: 'Flu');
p.log('Patient created');   // from Loggable mixin
print(p.toJson());          // from Serializable mixin
```

Mixins solve the diamond problem of multiple inheritance by applying a linear ordering. Think of them as "plug-in behaviors" you can attach to any class.

### Exercises

Complete **Exercises 9 and 10** in `exercises.dart`.

### Self-Check: Part 5

- [ ] You can create a Dart class with a constructor using `this.fieldName` shorthand.
- [ ] You understand inheritance (`extends`) and method overriding (`@override`).
- [ ] You can explain what an abstract class is and why you cannot instantiate one.
- [ ] You know that mixins (`with`) add behavior to a class without inheritance.

---

## Part 6: Async Programming (~15 min)

Healthcare apps frequently make network calls (fetching patient data, sending readings to a server). These operations are slow compared to local computation. Async programming lets your app stay responsive while waiting.

### The problem

```
fetchPatientData();   // Takes 2 seconds (network call)
print('Done!');       // Should this wait or run immediately?
```

### `Future<T>` -- a promise of a value

A `Future` is Dart's version of:
- C++: `std::future<T>` / `std::async`
- Python: `asyncio.Future` / a coroutine

It represents a value that will be available **sometime in the future**.

```dart
Future<String> fetchPatientName(String id) async {
  // Simulate a network delay
  await Future.delayed(Duration(seconds: 2));
  return 'Patient $id';
}
```

### `async` / `await`

Mark a function `async` to use `await` inside it. `await` pauses execution until the `Future` completes.

```dart
Future<void> main() async {
  print('Fetching...');
  String name = await fetchPatientName('P001');
  print('Got: $name');
  print('Done!');
}
// Output:
// Fetching...
// (2-second pause)
// Got: Patient P001
// Done!
```

This is almost identical to Python's `async`/`await`. The key difference: in Dart, `async` functions always return a `Future`, and you must declare the return type accordingly.

### Error handling

```dart
Future<void> loadData() async {
  try {
    var data = await fetchPatientName('P001');
    print(data);
  } catch (e) {
    print('Error: $e');
  }
}
```

### Exercises

Complete **Exercises 11 and 12** in `exercises.dart`.

### Self-Check: Part 6

- [ ] You can explain what `Future<String>` means — a value that will be a String sometime later.
- [ ] You know that `async` marks a function as asynchronous and `await` pauses until a Future completes.
- [ ] You can use `try`/`catch` to handle errors in async code.
- [ ] You see the connection to Python's `async`/`await` — the concept is the same, just different syntax.

---

## Reading User Input

The assignment below requires reading input from the terminal. Dart provides `stdin.readLineSync()` from the `dart:io` library:

```dart
import 'dart:io';

void main() {
  stdout.write('Enter your name: ');  // print without a newline
  String? name = stdin.readLineSync();
  print('Hello, $name!');

  stdout.write('Enter your age: ');
  int age = int.parse(stdin.readLineSync()!);  // ! because we expect non-null input
  print('Next year you will be ${age + 1}.');
}
```

Key points:

- `stdin.readLineSync()` returns `String?` (nullable) because the user might press Ctrl+D (end of input).
- Use `int.parse()` or `double.parse()` to convert string input to numbers.
- Use `stdout.write()` instead of `print()` when you want the cursor to stay on the same line (for a prompt).

---

## Individual Assignment: CLI Mood Logger

Build a command-line mood tracking application in Dart. A starter template is provided in `mood_logger_template.dart`.

### Requirements

1. **MoodEntry class** with:
   - `DateTime timestamp`
   - `int score` (1--10)
   - `String note`
   - A method to return a formatted string representation

2. **MoodLogger class** with:
   - A list to store `MoodEntry` objects
   - `addEntry(int score, String note)` -- adds a new entry with the current timestamp
   - `getAllEntries()` -- returns all entries
   - `getAverageScore()` -- computes and returns the average mood score
   - `getEntriesAbove(int threshold)` -- returns entries with score above the threshold

3. **Interactive CLI** (`main` function):
   - Display a menu: (1) Add entry, (2) View all entries, (3) View average, (4) Filter by score, (5) Quit
   - Read user input and execute the chosen action
   - Loop until the user quits

### Sample interaction

```
=== Mood Logger ===
1. Add mood entry
2. View all entries
3. View average mood
4. Filter by minimum score
5. Quit

Choose an option: 1
Enter mood score (1-10): 7
Enter a note: Productive day at the lab
Entry added!

Choose an option: 1
Enter mood score (1-10): 4
Enter a note: Tired after exams
Entry added!

Choose an option: 3
Average mood score: 5.5

Choose an option: 2
[2026-02-22 10:30] Score: 7/10 - Productive day at the lab
[2026-02-22 11:15] Score: 4/10 - Tired after exams

Choose an option: 5
Goodbye!
```

### Submission

- Push your completed `mood_logger.dart` file to your personal GitHub repository.
- Deadline: before the start of the Week 4 lab session.

### Grading criteria

| Criterion | Points |
|-----------|--------|
| `MoodEntry` class with proper fields and formatting | 2 |
| `MoodLogger` class with all required methods | 3 |
| Interactive CLI with menu loop and input handling | 3 |
| Code quality (naming, structure, null safety) | 2 |
| **Total** | **10** |

---

## Troubleshooting

??? question "`dart: command not found`"
    The Dart SDK is not on your PATH. If you installed Flutter, Dart is bundled inside it — run `flutter doctor` to verify Flutter works, then find the Dart binary at `<flutter-sdk>/bin/cache/dart-sdk/bin/dart`. Alternatively, install Dart separately using the instructions at the top of this lab.

??? question "Type error: `The argument type 'String?' can't be assigned to 'String'`"
    You are assigning a nullable value (`String?`) to a non-nullable variable (`String`). This commonly happens with `stdin.readLineSync()` which returns `String?`. Use the null assertion operator: `stdin.readLineSync()!` — or provide a default: `stdin.readLineSync() ?? ''`.

??? question "`FormatException: Invalid number` when parsing user input"
    The user entered text that cannot be converted to a number. Wrap `int.parse()` in a try-catch block, or use `int.tryParse()` which returns `null` on failure instead of throwing an exception.

??? question "My program runs but produces no output"
    Make sure you are calling the exercise functions from `main()`. Check the bottom of `exercises.dart` — the `main()` function should call each exercise. Also verify you are running the correct file: `dart run exercises.dart`.
