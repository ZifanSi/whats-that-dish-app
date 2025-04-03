import 'package:flutter/material.dart';

class BlackboardPage extends StatelessWidget {
  final String imageResult;
  final String textResult;
  final String ingredientResult;

  const BlackboardPage({
    super.key,
    required this.imageResult,
    required this.textResult,
    required this.ingredientResult,
  });

  @override
  Widget build(BuildContext context) {
    // Hardcoded confidence levels
    const imageConfidence = 0.99;
    const textConfidence = 0.80;
    const ingredientConfidence = 0.50;

    // Decision logic
    String bestResult;
    if (imageConfidence >= textConfidence &&
        imageConfidence >= ingredientConfidence) {
      bestResult =
          '📷 Best Expert: Image Recognition\n$imageResult\nConfidence: 99%';
    } else if (textConfidence >= ingredientConfidence) {
      bestResult =
          '📝 Best Expert: Text Description\n$textResult\nConfidence: 80%';
    } else {
      bestResult =
          '🥗 Best Expert: Ingredients\n$ingredientResult\nConfidence: 50%';
    }

    return Scaffold(
      appBar: AppBar(title: const Text('🧠 Blackboard')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Final Decision (Highest Confidence)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(bestResult, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
