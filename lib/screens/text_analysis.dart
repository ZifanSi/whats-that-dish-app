import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TextExpertPage extends StatefulWidget {
  const TextExpertPage({super.key});

  @override
  State<TextExpertPage> createState() => _TextExpertPageState();
}

class _TextExpertPageState extends State<TextExpertPage> {
  final TextEditingController _descriptionController = TextEditingController();
  String _result = '';
  bool _isLoading = false;

  Future<void> _analyzeDescription() async {
    final description = _descriptionController.text.trim();
    if (description.isEmpty) {
      setState(() {
        _result = 'Please enter a description.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _result = '';
    });

    final apiKey = 'AIzaSyAMRUCdqn-5lK3YDZWIsiUY70ApRGMfBAs';
    const apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

    final headers = {
      'Content-Type': 'application/json',
      'x-goog-api-key': apiKey,
    };

    final prompt = "Given this food description: \"$description\", what is the most likely name of the dish in 3 words or less?";

    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ]
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prediction = data['candidates'][0]['content']['parts'][0]['text'];
        setState(() {
          _result = "Dish: $prediction";
        });
      } else {
        setState(() {
          _result = 'Error: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Text Input Expert')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Describe your dish below:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'e.g. pasta with bechamel sauce and cheese layers...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _analyzeDescription,
              child: const Text('Analyze'),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : Text(
                    _result,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
          ],
        ),
      ),
    );
  }
}
