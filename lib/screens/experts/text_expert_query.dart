import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TextExpertPage extends StatefulWidget {
  const TextExpertPage({super.key});

  @override
  State<TextExpertPage> createState() => _TextExpertPageState();
}

class _TextExpertPageState extends State<TextExpertPage> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';
  bool _isLoading = false;

  Future<void> _analyzeText() async {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    setState(() {
      _isLoading = true;
      _result = '';
    });
        final jsonStr = await rootBundle.loadString('assets/data/t_dishes.json');
    final List<dynamic> dishes = jsonDecode(jsonStr);

    final inputWords = input.split(RegExp(r'\s+'));
    String? matchedDish;
    double bestConfidence = 0.0;

    for (var dish in dishes) {
      final desc = (dish['description'] as String).toLowerCase();
      final descWords = desc.split(RegExp(r'\s+'));

      int matchCount =
          inputWords.where((word) => descWords.contains(word)).length;
      if (matchCount == 0) continue;

      double confidence = matchCount / descWords.length;

      if (confidence > bestConfidence) {
        bestConfidence = confidence;
        matchedDish = dish['name'];
              }
    } catch (e) {
      setState(() {
        _result = 'Exception: $e';
      });
    }

    setState(() {
      _isLoading = false;
            _result =
          matchedDish != null
              ? 'Dish: $matchedDish\nConfidence: ${(bestConfidence * 100).toStringAsFixed(2)}%'
              : 'No matching dish found.';
              });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Text Expert")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Describe the dish...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _analyzeText,
              child: const Text("Analyze"),
            ),
                        const SizedBox(height: 10),
            _isLoading
                ? const CircularProgressIndicator()
                : Text(_result, style: const TextStyle(fontSize: 16)),
                          ],
        ),
      ),
    );
  }
}