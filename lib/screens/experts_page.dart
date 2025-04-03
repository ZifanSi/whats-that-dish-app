import 'package:flutter/material.dart';
import 'package:dish_app/screens/experts/image.dart';
import 'package:dish_app/screens/experts/text.dart';
import 'package:dish_app/screens/experts/ingredient.dart';
import 'package:dish_app/screens/experts/blackboard.dart'; // Add this line

class ExpertsPage extends StatelessWidget {
  const ExpertsPage({super.key});

  // Mocked expert results (replace with shared state later)
  final String imageResult = 'Dish: Pepperoni Pizza';
  final String textResult = 'Dish: Cheese Pizza';
  final String ingredientResult = 'Dish: Margherita Pizza';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Experts')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ImageExpertPage()),
                );
              },
              child: const Text('📷 Image Recognition Expert'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TextExpertPage()),
                );
              },
              child: const Text('📝 Text Input Expert'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const IngredientExpertPage(),
                  ),
                );
              },
              child: const Text('🥗 Ingredient Match Expert'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => BlackboardPage(
                          imageResult: imageResult,
                          textResult: textResult,
                          ingredientResult: ingredientResult,
                        ),
                  ),
                );
              },
              child: const Text('🧠 Show Blackboard Result'),
            ),
          ],
        ),
      ),
    );
  }
}
