import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patient Card',
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
      ),
      home: const PatientCardScreen(),
    );
  }
}

class PatientCardScreen extends StatelessWidget {
  const PatientCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Information'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Example card to show the expected result:
            PatientInfoCard(
              name: 'Anna Kowalska',
              age: 34,
              diagnosis: 'Type 2 Diabetes',
            ),
            SizedBox(height: 16),
            // TODO 5: Add more PatientInfoCard widgets here with
            //         different patient data to practice reuse.
            //         For example:
            //         PatientInfoCard(
            //           name: 'Jan Nowak',
            //           age: 58,
            //           diagnosis: 'Hypertension',
            //         ),
          ],
        ),
      ),
    );
  }
}

// TODO 1: Define a StatelessWidget called PatientInfoCard.
//
// It should:
//   - Accept three required parameters via the constructor:
//       * name (String)  — the patient's full name
//       * age  (int)     — the patient's age
//       * diagnosis (String) — the patient's diagnosis
//
//   - Store them as final fields.
//
//   - In the build() method, return a Card widget containing
//     a Padding with some inner spacing (e.g., EdgeInsets.all(16)),
//     which in turn contains a Column of Text widgets displaying
//     the patient's name, age, and diagnosis.
//
// Hints:
//   - Use TextStyle(fontSize: 18, fontWeight: FontWeight.bold) for the name.
//   - Use CrossAxisAlignment.start on the Column so text is left-aligned.
//   - Separate the text rows with SizedBox(height: 8).
//
// Starter structure (fill in the blanks):

class PatientInfoCard extends StatelessWidget {
  // TODO 2: Declare final fields for name, age, and diagnosis.

  const PatientInfoCard({
    super.key,
    // TODO 3: Add required named parameters here.
    //         Example: required this.name,
    required this.name,
    required this.age,
    required this.diagnosis,
  });

  // Remove these placeholder declarations once you add your own fields
  // in TODO 2 above. They are here so the file compiles from the start.
  final String name;
  final int age;
  final String diagnosis;

  @override
  Widget build(BuildContext context) {
    // TODO 4: Replace the placeholder below with a Card containing:
    //   - Padding (EdgeInsets.all(16))
    //     - Column (crossAxisAlignment: CrossAxisAlignment.start)
    //       - Text for name  (bold, larger font)
    //       - SizedBox(height: 8)
    //       - Text for age   (e.g., "Age: 34")
    //       - SizedBox(height: 8)
    //       - Text for diagnosis (e.g., "Diagnosis: Type 2 Diabetes")
    //
    // Example for one text row:
    //   Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Replace this placeholder:
            Text('Patient: $name — implement the rest!'),
          ],
        ),
      ),
    );
  }
}
