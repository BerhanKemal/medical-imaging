//1. Native development - Google/Apple based frameworks
// 2. Multiplatform - React Native / Flutter / Xamarin
// We will use Flutter -> Dart
// Dart -> two different compilation modes: AOT and JIT
//
//
// Explicit types

int age = 35;

double temperature = 36.6;
String name = "mateusz";

// Type inference

var heartRate = 72;
var bmi = 22.5;
var diagnosis = "Healthy";

bool isAdult(int age) => age >= 18;

String getDataFromAPI() {
  return "0";
}

String? greet(String name) {
  // will return null -> no value

  if (name == "Mateusz") {
    return null;
  } else {
    return "Hello, $name";
  }
}

String calculateBMI({required double weight, double? height}) {
  if (height == null) {
    throw ArgumentError("Height needs to be defined in meters in the range 0.5 - 3");
  } else {
    double bmi = weight / (height * height);
    return "BMI = ${bmi.toString()}";
  }
}

void main() {
  // Constants
  const double PI = 3.141; // <- compile-time constant
  final String id = getDataFromAPI(); // <- runtime constant ()

  //bool isAdult(int age) => age >= 18;

  print("Hello World");
  print("PI = $PI, id = $id");

  print("=== function tests ===");
  print(greet("Mateusz"));
  print(greet("Bob"));
  print(isAdult(28));

  try {
    print(calculateBMI(weight: 80));
  } catch (error) {
    print("ERROR: $error");
  }

  var person_1 = Person(name: "Mateusz", age: 35);
  print(person_1.describe());
}

class Person {
  String name;
  int age;

  Person({required this.name, required this.age});

  String describe() => "$name (age: $age)";
}

// AOT compilation
//
// source code => dart compiler => native machine code (.so/ .exe) => runs directly on CPU
//
// JIT compilation
// Designed for development purposes
// Source code => Dart Parses => VM Syntax Code => VM bytecode => Dart VM => Machine code
