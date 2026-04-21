// A minimal smoke test. You will write real tests in Week 10.
//
// To run: `flutter test`

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mood_tracker/main.dart';

void main() {
  testWidgets('App launches without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MoodTrackerApp()),
    );
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
