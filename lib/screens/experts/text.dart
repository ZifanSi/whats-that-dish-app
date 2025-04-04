import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    if (textInput == "") return ("", 0.0);

    const apiKey = 'AIzaSyAMRUCdqn-5lK3YDZWIsiUY70ApRGMfBAs'; // ✅ your API key
    final url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey';

    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": "What dish could this be: $textInput"}
          ]
        }
      ]
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Key $apiKey',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      final data = jsonDecode(response.body);
      String name = data['candidates']?[0]?['content']?['parts']?[0]?['text'] ;
      double confidence = 0.5;

      return (name, confidence);
  }
  catch (e) {
      return ("", 0.0);
    }
}
}