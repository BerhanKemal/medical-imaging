import 'package:flutter/material.dart';

class MoodScoreIndicator extends StatelessWidget {
  final int score;
  final double size;

  const MoodScoreIndicator({
    super.key,
    required this.score,
    this.size = 40,
  });

  Color get color {
    if (score <= 2) return Colors.red.shade700;
    if (score <= 4) return Colors.orange.shade700;
    if (score <= 6) return Colors.amber.shade600;
    if (score <= 8) return Colors.lightGreen.shade600;
    return Colors.green.shade700;
  }

  String get emoji {
    if (score <= 2) return '😢';
    if (score <= 4) return '😟';
    if (score <= 6) return '😐';
    if (score <= 8) return '😊';
    return '😄';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Text(
          '$score',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.4,
          ),
        ),
      ),
    );
  }
}
