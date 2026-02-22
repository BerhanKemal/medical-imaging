import 'package:flutter/material.dart';
// TODO 3: Import flutter_riverpod and wrap runApp with ProviderScope
//
// 1. Add this import:
//      import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// 2. Wrap the runApp() call with ProviderScope:
//      runApp(const ProviderScope(child: MoodTrackerApp()));
//
// ProviderScope is the container that stores all your provider state.
// Without it, ref.watch() and ref.read() will throw an error.
import 'screens/home_screen.dart';

void main() {
  // TODO 3: Wrap with ProviderScope (see instructions above)
  runApp(const MoodTrackerApp());
}

class MoodTrackerApp extends StatelessWidget {
  const MoodTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
