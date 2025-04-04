import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ImageExpert {
  // Constructor.
  ImageExpert();

  // Predict based on picture.
  String getString() {
    return "Hello from SampleClass";
  }

  Future<(String, double)> analyzeImage(File? image) async {
    if (image == null) return ("", 0.0);

    final apiKey = dotenv.env['IMAGE_RECOGNITION_API'];
    final apiUrl =
        'https://api.clarifai.com/v2/users/clarifai/apps/main/models/food-item-recognition/versions/1d5fd481e0cf4826aa72ec3ff049e044/outputs';

    final base64Image = base64Encode(await image!.readAsBytes());

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Key $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'inputs': [
            {
              'data': {
                'image': {'base64': base64Image},
              },
            },
          ],
        }),
      );

      final data = jsonDecode(response.body);
      final predictions = data['outputs'][0]['data']['concepts'];
      String name = predictions[0]['name'];
      double confidence = predictions[0]['value'];

      return (name, confidence);
    }
    catch (e) {
      return ("", 0.0);
    }

  }
}