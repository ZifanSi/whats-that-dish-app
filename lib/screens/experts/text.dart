import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

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
    final input = _controller.text.trim().toLowerCase();
    if (input.isEmpty) return;

    setState(() {
      _isLoading = true;
      _result = '';
    });

    final jsonStr = await rootBundle.loadString('assets/data/t_dishes.json');
    final dishes = jsonDecode(jsonStr);

    for (var dish in dishes) {
      final desc = (dish['description'] as String).toLowerCase();
      if (desc.contains(input)) {
        setState(() {
          _isLoading = false;
          _result = 'Dish: ${dish['name']}\nConfidence: 100%';
        });
        return;
      }
    }

    setState(() {
      _isLoading = false;
      _result = 'No matching dish found.';
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
            _isLoading ? const CircularProgressIndicator() : Text(_result),
          ],
        ),
      ),
    );
  }
}
