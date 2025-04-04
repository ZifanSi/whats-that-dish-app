import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:dish_app/screens/experts/image.dart';
import 'package:dish_app/screens/experts/text.dart';
import 'package:dish_app/screens/experts/ingredient.dart';
import 'package:dish_app/screens/experts/blackboard.dart';

class ExpertsPage extends StatelessWidget {
  const ExpertsPage({super.key});

  final String imageResult = 'Dish: Pepperoni Pizza';
  final String textResult = 'Dish: Cheese Pizza';
  final String ingredientResult = 'Dish: Margherita Pizza';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8ED),
      appBar: AppBar(
        title: Text(
          'Experts',
          style: GoogleFonts.lobster(fontSize: 26, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF955306),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildExpertCard(
              context: context,
              label: 'Image Recognition Expert',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ImageExpertPage()),
              ),
              useScripterFont: true,
            ),
            const SizedBox(height: 20),
            _buildExpertCard(
              context: context,
              label: 'Text Input Expert',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TextExpertPage()),
              ),
              useScripterFont: true,
            ),
            const SizedBox(height: 20),
            _buildExpertCard(
              context: context,
              label: 'Ingredient Match Expert',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const IngredientExpertPage()),
              ),
              useScripterFont: true,
            ),
            const SizedBox(height: 20),
            _buildExpertCard(
              context: context,
              label: 'Show Blackboard Result',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlackboardPage(
                    imageResult: imageResult,
                    textResult: textResult,
                    ingredientResult: ingredientResult,
                  ),
                ),
              ),
              useScripterFont: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpertCard({
    required BuildContext context,
    required String label,
    required VoidCallback onTap,
    required bool useScripterFont,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFF955306),
                offset: Offset(4, 4),
                blurRadius: 6,
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: useScripterFont
                  ? const TextStyle(
                      fontFamily: 'Scripter',
                      fontSize: 20,
                      color: Colors.black,
                    )
                  : GoogleFonts.lobster(
                      fontSize: 20,
                      color: Colors.black,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
