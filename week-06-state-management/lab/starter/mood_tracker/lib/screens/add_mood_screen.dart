import 'package:flutter/material.dart';
// TODO 5: Import flutter_riverpod and mood_provider
//
// 1. Add: import 'package:flutter_riverpod/flutter_riverpod.dart';
// 2. Add: import '../providers/mood_provider.dart';
// 3. Change StatefulWidget to ConsumerStatefulWidget
// 4. Change State<AddMoodScreen> to ConsumerState<AddMoodScreen>
// 5. In _submitMood(), call:
//      ref.read(moodProvider.notifier).addMood(_score, _noteController.text.isEmpty ? null : _noteController.text);
//
// Note: Use ref.read() (not ref.watch()) inside event handlers!
// ref.watch() is for the build method, ref.read() is for one-time actions.

// TODO 5: Change to ConsumerStatefulWidget
class AddMoodScreen extends StatefulWidget {
  const AddMoodScreen({super.key});

  @override
  State<AddMoodScreen> createState() => _AddMoodScreenState();
}

// TODO 5: Change to ConsumerState<AddMoodScreen>
class _AddMoodScreenState extends State<AddMoodScreen> {
  int _score = 5;
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _submitMood() {
    // TODO 5: Replace this placeholder with actual provider call:
    //   ref.read(moodProvider.notifier).addMood(
    //     _score,
    //     _noteController.text.isEmpty ? null : _noteController.text,
    //   );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Not implemented yet — complete TODO 5!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Mood Entry'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'How are you feeling?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            Text(
              'Score: $_score',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            Slider(
              value: _score.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              label: '$_score',
              onChanged: (value) {
                setState(() {
                  _score = value.round();
                });
              },
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('1 — Terrible'),
                Text('10 — Excellent'),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Note (optional)',
                hintText: 'How was your day?',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _submitMood,
              icon: const Icon(Icons.check),
              label: const Text('Save Entry'),
            ),
          ],
        ),
      ),
    );
  }
}
