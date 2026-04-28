import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Selector',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const MoodSelectorScreen(),
    );
  }
}

class MoodSelectorScreen extends StatelessWidget {
  const MoodSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How Are You Feeling?'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Padding(
        padding: EdgeInsets.all(24.0),
        child: MoodSelector(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// TODO: Implement the MoodSelector as a StatefulWidget.
//
// Requirements:
//   1. Display a prompt text, e.g., "Select your current mood:".
//   2. Show a row of buttons — one for each mood.
//      Suggested moods (feel free to add more):
//        - Happy     (emoji or icon: Icons.sentiment_very_satisfied)
//        - Neutral   (emoji or icon: Icons.sentiment_neutral)
//        - Sad       (emoji or icon: Icons.sentiment_very_dissatisfied)
//   3. When the user taps a mood button, store the selection in a
//      state variable and update the display.
//   4. Below the buttons, show a Text widget indicating the selected mood,
//      e.g., "You selected: Happy" or "No mood selected yet."
//
// Steps:
//   a) Create a StatefulWidget class called MoodSelector.
//   b) Create the corresponding State class _MoodSelectorState.
//   c) Declare a state variable: String _selectedMood = '';
//   d) Write a method _selectMood(String mood) that calls setState()
//      to update _selectedMood.
//   e) In build(), return a Column with:
//        - A Text widget for the prompt.
//        - A SizedBox(height: 24) for spacing.
//        - A Row with mood buttons (use ElevatedButton or IconButton).
//          Wrap the Row in mainAxisAlignment: MainAxisAlignment.spaceEvenly.
//        - A SizedBox(height: 32) for spacing.
//        - A Text widget showing the selected mood (or a default message).
//
// Hints:
//   - For each button, pass a different string to _selectMood.
//   - You can use emoji strings directly: '😊', '😐', '😢'
//     or use Material Icons: Icons.sentiment_very_satisfied, etc.
//   - To display an icon inside an ElevatedButton:
//       ElevatedButton.icon(
//         onPressed: () => _selectMood('Happy'),
//         icon: const Icon(Icons.sentiment_very_satisfied),
//         label: const Text('Happy'),
//       )
// ---------------------------------------------------------------------------

class MoodSelector extends StatefulWidget {
  const MoodSelector({super.key});

  @override
  State<MoodSelector> createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  // TODO 1: Declare a state variable to hold the selected mood.
  //         Example: String _selectedMood = '';

  // TODO 2: Create a method _selectMood(String mood) that calls
  //         setState(() { _selectedMood = mood; });

  @override
  Widget build(BuildContext context) {
    // TODO 3: Replace the placeholder below with the full UI.
    //
    // Suggested structure:
    //
    // return Column(
    //   children: [
    //     const Text(
    //       'Select your current mood:',
    //       style: TextStyle(fontSize: 20),
    //     ),
    //     const SizedBox(height: 24),
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       children: [
    //         ElevatedButton.icon(
    //           onPressed: () => _selectMood('Happy'),
    //           icon: const Icon(Icons.sentiment_very_satisfied),
    //           label: const Text('Happy'),
    //         ),
    //         ElevatedButton.icon(
    //           onPressed: () => _selectMood('Neutral'),
    //           icon: const Icon(Icons.sentiment_neutral),
    //           label: const Text('Neutral'),
    //         ),
    //         ElevatedButton.icon(
    //           onPressed: () => _selectMood('Sad'),
    //           icon: const Icon(Icons.sentiment_very_dissatisfied),
    //           label: const Text('Sad'),
    //         ),
    //       ],
    //     ),
    //     const SizedBox(height: 32),
    //     Text(
    //       _selectedMood.isEmpty
    //           ? 'No mood selected yet.'
    //           : 'You selected: $_selectedMood',
    //       style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    //     ),
    //   ],
    // );

    return const Center(
      child: Text(
        'Implement the mood selector here!',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
