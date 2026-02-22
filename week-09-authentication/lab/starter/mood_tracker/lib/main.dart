import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// TODO 7: Import auth_provider, login_screen, and home_screen
//
// Add: import 'providers/auth_provider.dart';
// Add: import 'screens/login_screen.dart';
//
// Then change MoodTrackerApp to a ConsumerWidget and:
//   1. Watch authProvider state
//   2. Call checkAuth() on startup (in a ConsumerStatefulWidget or via
//      ref.listen in the build method)
//   3. Show LoginScreen when unauthenticated
//   4. Show HomeScreen when authenticated
//   5. Show a loading indicator during initial/loading states
//
// Example approach using ConsumerWidget:
//
//   class MoodTrackerApp extends ConsumerWidget {
//     @override
//     Widget build(BuildContext context, WidgetRef ref) {
//       final authState = ref.watch(authProvider);
//       return MaterialApp(
//         ...
//         home: switch (authState) {
//           AuthState.authenticated => const HomeScreen(),
//           AuthState.unauthenticated => const LoginScreen(),
//           AuthState.loading => const Scaffold(body: Center(child: CircularProgressIndicator())),
//           AuthState.initial => const _AuthCheckScreen(),
//         },
//       );
//     }
//   }
//
// _AuthCheckScreen is a small ConsumerStatefulWidget that calls
// ref.read(authProvider.notifier).checkAuth() in initState().
import 'screens/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: MoodTrackerApp()));
}

// TODO 7: Change to ConsumerWidget and implement auth-based routing
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
      // TODO 7: Replace with auth-state-dependent home screen
      home: const HomeScreen(),
    );
  }
}
