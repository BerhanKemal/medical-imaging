import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// TODO 7: Import mood_provider to call loadMoods() on startup
//
// Add: import 'providers/mood_provider.dart';
//
// Then modify the HomeScreen to load moods from the database when it
// first appears. The simplest approach:
//
// In home_screen.dart, change HomeScreen to a ConsumerStatefulWidget and
// add an initState() that calls:
//   ref.read(moodProvider.notifier).loadMoods();
//
// Alternatively, you can use a FutureProvider or call loadMoods() here
// in main(). The key requirement is that loadMoods() runs once at startup.
//
// Hint: If using initState(), you need to use Future.microtask() to
// safely call ref.read() during initialization:
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() => ref.read(moodProvider.notifier).loadMoods());
//   }
import 'screens/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: MoodTrackerApp()));
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
