import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class TextExpert {
  // Constructor.
  TextExpert();

  Future<List<dynamic>> _loadDishes() async {
    String jsonString = await rootBundle.loadString('assets/data/t_dishes.json');
    return List<dynamic>.from(json.decode(jsonString));
  }

  // Predict based on list of Ingredients.
  Future<(String, double)> predictDish(String textInput) async {
    final inputWords = textInput.split(RegExp(r'\s+'));
    
    List<dynamic> dishesInfo = await _loadDishes();
    String dish = "";
    double bestConfidence = 0.0;


    for (var dishInfo in dishesInfo) {
      final desc = (dishInfo['description'] as String).toLowerCase();
      final descWords = desc.split(RegExp(r'\s+'));

      int matchCount =
          inputWords.where((word) => descWords.contains(word)).length;
      if (matchCount == 0) continue;

      double confidence = matchCount / descWords.length;

      if (confidence > bestConfidence) {
        bestConfidence = confidence;
        dish = dishInfo['name'];
      }
    }

    return (dish, bestConfidence);
  }
}