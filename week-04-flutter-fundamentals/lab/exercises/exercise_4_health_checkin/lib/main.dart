import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Check-In',
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
      ),
      home: const HealthCheckInScreen(),
    );
  }
}

class HealthCheckInScreen extends StatefulWidget {
  const HealthCheckInScreen({super.key});

  @override
  State<HealthCheckInScreen> createState() => _HealthCheckInScreenState();
}

class _HealthCheckInScreenState extends State<HealthCheckInScreen> {
  // TODO 1: Declare state variables.
  //
  // You will need:
  //   - A TextEditingController for the patient name text field.
  //     Example: final TextEditingController _nameController = TextEditingController();
  //
  //   - A double for the pain level slider value, initialized to 5.
  //     Example: double _painLevel = 5.0;

  // TODO 2: Implement a _submit() method that prints the collected data
  //         to the console using debugPrint() or print().
  //
  // Example:
  //   void _submit() {
  //     debugPrint('Patient: ${_nameController.text}');
  //     debugPrint('Pain level: ${_painLevel.round()}');
  //   }

  // TODO 3 (optional): Override dispose() to clean up the
  //         TextEditingController when the widget is removed.
  //
  //   @override
  //   void dispose() {
  //     _nameController.dispose();
  //     super.dispose();
  //   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Check-In'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      // TODO 4: Replace the body below with a SingleChildScrollView
      //         containing a Padding and a Column.
      //
      // Suggested structure:
      //
      // body: SingleChildScrollView(
      //   child: Padding(
      //     padding: const EdgeInsets.all(24.0),
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.stretch,
      //       children: [
      //
      //         // --- Patient Name ---
      //         const Text(
      //           'Patient Name',
      //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      //         ),
      //         const SizedBox(height: 8),
      //         TextField(
      //           controller: _nameController,
      //           decoration: const InputDecoration(
      //             border: OutlineInputBorder(),
      //             hintText: 'Enter patient name',
      //           ),
      //         ),
      //
      //         const SizedBox(height: 24),
      //
      //         // --- Pain Level Slider ---
      //         Text(
      //           'Pain Level: ${_painLevel.round()}',
      //           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      //         ),
      //         const SizedBox(height: 8),
      //         Slider(
      //           value: _painLevel,
      //           min: 1,
      //           max: 10,
      //           divisions: 9,
      //           label: _painLevel.round().toString(),
      //           onChanged: (double value) {
      //             setState(() {
      //               _painLevel = value;
      //             });
      //           },
      //         ),
      //
      //         const SizedBox(height: 32),
      //
      //         // --- Submit Button ---
      //         ElevatedButton(
      //           onPressed: _submit,
      //           style: ElevatedButton.styleFrom(
      //             padding: const EdgeInsets.symmetric(vertical: 16),
      //           ),
      //           child: const Text(
      //             'Submit Check-In',
      //             style: TextStyle(fontSize: 18),
      //           ),
      //         ),
      //
      //       ],
      //     ),
      //   ),
      // ),

      body: const Center(
        child: Text(
          'Build the health check-in form here!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
