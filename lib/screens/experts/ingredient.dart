import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class IngredientsExpert {
  // Constructor.
  IngredientsExpert();

  Future<List<Map<String, dynamic>>> _loadRecipes() async {
    String jsonString = await rootBundle.loadString('assets/data/recipes.json');
    return List<Map<String, dynamic>>.from(json.decode(jsonString));
  }

  // Predict based on list of Ingredients.
  Future<(String, double)> predictDish(String ingredientsInput) async {

    List<String> inputIngredients = ingredientsInput.toLowerCase().split(',').map((e) => e.trim()).toList();
    
    List<Map<String, dynamic>> recipes = await _loadRecipes();
    String dish = "";
    double confidence = 0.0;
    int maxMatchCount = 0;

    for (var recipe in recipes) {
      List<String> recipeIngredients = List<String>.from(recipe['ingredients']);
      int matchCount = recipeIngredients.where((ingredient) => inputIngredients.contains(ingredient.toLowerCase())).length;
      
      if (matchCount > maxMatchCount) {
        maxMatchCount = matchCount;
        dish = recipe['meal_name'];
        confidence = matchCount / recipeIngredients.length;
      }
    }

    return (dish, confidence);
  }
}