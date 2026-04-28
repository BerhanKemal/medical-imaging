/// Week 3 Lab Exercises -- Dart Fundamentals (SOLUTIONS)
///
/// This file contains complete solutions for all 12 exercises.
/// Do NOT distribute to students before the lab deadline.

// ============================================================================
// PART 1: Variables, Types & Basics
// ============================================================================

// Exercise 1: Patient Greeting
String greetPatient(String name, int age) {
  return 'Hello, $name! You are $age years old. Next year you will be ${age + 1}.';
}

// Exercise 2: Variable Declarations
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

// ============================================================================
// PART 2: Functions
// ============================================================================

// Exercise 3: BMI Calculator with Named Parameters
double calculateBMI({required double weightKg, required double heightM}) {
  double bmi = weightKg / (heightM * heightM);
  return double.parse(bmi.toStringAsFixed(1));
}

// Exercise 4: Vital Signs Formatter (arrow syntax)
String formatVitals(int heartRate, [double temperature = 36.6]) =>
    'HR: $heartRate bpm, Temp: $temperature C';

// ============================================================================
// PART 3: Collections
// ============================================================================

// Exercise 5: Heart Rate Analysis
Map<String, dynamic> analyzeHeartRates(List<int> readings) {
  int count = readings.length;
  double average =
      double.parse((readings.fold(0, (sum, hr) => sum + hr) / count)
          .toStringAsFixed(1));
  List<int> elevated = readings.where((hr) => hr > 100).toList();
  List<int> normal = readings.where((hr) => hr >= 60 && hr <= 100).toList();

  return {
    'count': count,
    'average': average,
    'elevated': elevated,
    'normal': normal,
  };
}

// Exercise 6: Allergy Checker
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

// ============================================================================
// PART 4: Null Safety
// ============================================================================

// Exercise 7: Safe Patient Lookup
// Uses null-aware operator ?? to provide the fallback message.
String safePatientLookup(Map<String, String> database, String patientId) {
  String? name = database[patientId];
  // The ?. operator accesses the value only if name is non-null.
  // The ?? operator provides a fallback when the entire expression is null.
  return name != null
      ? 'Patient found: $name'
      : 'Patient not found';
  // Alternative one-liner using ?? (acceptable solution):
  // return 'Patient: ${database[patientId] ?? "not found"}';
}

// Exercise 8: Fix Null Safety
String fixNullSafety(String? name, int? age, String? diagnosis) {
  String safeName = name ?? 'Unknown';
  int safeAge = age ?? 0;
  String safeDiagnosis = diagnosis ?? 'Not diagnosed';
  return '$safeName (age $safeAge) - Diagnosis: $safeDiagnosis';
}

// ============================================================================
// PART 5: OOP
// ============================================================================

// Exercise 9: Person / Patient / Doctor Class Hierarchy
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

// Exercise 10: Mixin -- Timestamped
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

// ============================================================================
// PART 6: Async Programming
// ============================================================================

// Exercise 11: Simulated API Call
Future<Map<String, dynamic>> fetchPatientData(String id) async {
  print('Fetching data for patient $id...');
  await Future.delayed(Duration(seconds: 1));
  return {'id': id, 'name': 'Patient $id', 'heartRate': 72};
}

// Exercise 12: Multiple Async Calls
Future<List<Map<String, dynamic>>> fetchMultiplePatients() async {
  List<Map<String, dynamic>> results = await Future.wait([
    fetchPatientData('P001'),
    fetchPatientData('P002'),
    fetchPatientData('P003'),
  ]);
  return results;
}

// ============================================================================
// MAIN -- Test all solutions
// ============================================================================

Future<void> main() async {
  print('=' * 60);
  print('EXERCISE 1: Patient Greeting');
  print(greetPatient('Alice', 30));
  print(greetPatient('Bob', 25));
  print('');

  print('=' * 60);
  print('EXERCISE 2: Variable Declarations');
  var vars = declareVariables();
  vars.forEach((key, value) => print('  $key: $value (${value.runtimeType})'));
  print('');

  print('=' * 60);
  print('EXERCISE 3: BMI Calculator');
  print('BMI(70kg, 1.75m): ${calculateBMI(weightKg: 70.0, heightM: 1.75)}');
  print('BMI(90kg, 1.80m): ${calculateBMI(weightKg: 90.0, heightM: 1.80)}');
  print('');

  print('=' * 60);
  print('EXERCISE 4: Vital Signs Formatter');
  print(formatVitals(72));
  print(formatVitals(80, 37.5));
  print('');

  print('=' * 60);
  print('EXERCISE 5: Heart Rate Analysis');
  var hrResult = analyzeHeartRates([72, 85, 110, 65, 95, 130, 58]);
  hrResult.forEach((key, value) => print('  $key: $value'));
  print('');

  print('=' * 60);
  print('EXERCISE 6: Allergy Checker');
  var allergyResult = checkAllergies(
    {'penicillin', 'aspirin'},
    {'aspirin', 'ibuprofen', 'amoxicillin'},
  );
  allergyResult.forEach((key, value) => print('  $key: $value'));
  print('');

  print('=' * 60);
  print('EXERCISE 7: Safe Patient Lookup');
  var db = {'P001': 'Alice', 'P002': 'Bob'};
  print(safePatientLookup(db, 'P001'));
  print(safePatientLookup(db, 'P999'));
  print('');

  print('=' * 60);
  print('EXERCISE 8: Fix Null Safety');
  print(fixNullSafety('Alice', 30, 'Flu'));
  print(fixNullSafety(null, null, null));
  print(fixNullSafety('Bob', 25, null));
  print('');

  print('=' * 60);
  print('EXERCISE 9: Class Hierarchy');
  var patient = Patient('Alice', 30, diagnosis: 'Hypertension');
  var doctor = Doctor('Dr. Smith', 45, 'Cardiology');
  print(patient.introduce());
  print(doctor.introduce());
  print('');

  print('=' * 60);
  print('EXERCISE 10: Mixin -- Timestamped');
  var record = MedicalRecord('Alice', 'Annual checkup - all clear');
  print(record.summary());
  print('Created at: ${record.timeStamp()}');
  print('');

  print('=' * 60);
  print('EXERCISE 11: Simulated API Call');
  var patientData = await fetchPatientData('P001');
  print('Result: $patientData');
  print('');

  print('=' * 60);
  print('EXERCISE 12: Multiple Async Calls');
  var multiplePatients = await fetchMultiplePatients();
  for (var p in multiplePatients) {
    print('  $p');
  }
  print('');

  print('=' * 60);
  print('All exercises complete!');
}
