import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class IngredientsAnalysisPage extends StatelessWidget {
  const IngredientsAnalysisPage({super.key});

  Future<List<Map<String, dynamic>>> _loadRecipes() async {
    String jsonString = await rootBundle.loadString('assets/data/recipes.json');
    return List<Map<String, dynamic>>.from(json.decode(jsonString));
  }

  (String, double) predictMeal(String ingredientsInput, List<Map<String, dynamic>> recipes) {
    List<String> inputIngredients = ingredientsInput.toLowerCase().split(',').map((e) => e.trim()).toList();
    
    String bestMatch = "No matching recipe found";
    double confidence = 0.0;
    int maxMatchCount = 0;

    for (var recipe in recipes) {
      List<String> recipeIngredients = List<String>.from(recipe['ingredients']);
      int matchCount = recipeIngredients.where((ingredient) => inputIngredients.contains(ingredient.toLowerCase())).length;
      
      if (matchCount > maxMatchCount) {
        maxMatchCount = matchCount;
        bestMatch = recipe['meal_name'];
        confidence = matchCount / recipeIngredients.length;
      }
    }

    return (bestMatch, confidence);
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController ingredientsController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text("Meal Predictor")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          
          List<Map<String, dynamic>> recipes = snapshot.data ?? [];
          String predictedMeal = "";

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: ingredientsController,
                  decoration: const InputDecoration(
                    labelText: "Enter Ingredients (comma-separated)",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    String input = ingredientsController.text;
                    var (result, confidence)  = predictMeal(input, recipes);
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Predicted Meal"),
                        content: Text(result),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("OK"),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text("Predict Meal"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
