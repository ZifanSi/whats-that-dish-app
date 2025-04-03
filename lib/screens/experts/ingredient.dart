import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class IngredientExpertPage extends StatefulWidget {
  const IngredientExpertPage({super.key});

  @override
  State<IngredientExpertPage> createState() => _IngredientExpertPageState();
}

class _IngredientExpertPageState extends State<IngredientExpertPage> {
  List<String> _availableIngredients = [];
  List<String> _selectedIngredients = [];
  String _ingredientResult = '';
  bool _isIngredientLoading = false;

  @override
  void initState() {
    super.initState();
    _loadIngredients();
  }

  Future<void> _loadIngredients() async {
    final jsonStr = await rootBundle.loadString(
      'assets/data/t_ingredients.json',
    );
    final List<dynamic> data = jsonDecode(jsonStr);
    final Set<String> ingredients = {};

    for (var item in data) {
      for (var ing in item['ingredients']) {
        ingredients.add(ing.toString());
      }
    }

    setState(() {
      _availableIngredients = ingredients.toList()..sort();
    });
  }

  Future<void> _analyzeIngredientSelection() async {
    setState(() {
      _isIngredientLoading = true;
      _ingredientResult = '';
    });

    final jsonStr = await rootBundle.loadString(
      'assets/data/t_ingredients.json',
    );
    final List<dynamic> dishes = jsonDecode(jsonStr);

    String matchedDish = '';
    int highestMatch = 0;

    for (var dish in dishes) {
      final List<dynamic> ingredients = dish['ingredients'];
      int matchCount =
          ingredients.where((i) => _selectedIngredients.contains(i)).length;

      if (matchCount > highestMatch) {
        highestMatch = matchCount;
        matchedDish = dish['name'];
      }
    }

    setState(() {
      _isIngredientLoading = false;
      _ingredientResult =
          matchedDish.isNotEmpty
              ? 'Matched Dish: $matchedDish\nConfidence: 50%'
              : 'No matching dish found.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🥗 Ingredient Expert')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select ingredients that are in your dish:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 5,
              children:
                  _availableIngredients.map((ingredient) {
                    final isSelected = _selectedIngredients.contains(
                      ingredient,
                    );
                    return FilterChip(
                      label: Text(ingredient),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          selected
                              ? _selectedIngredients.add(ingredient)
                              : _selectedIngredients.remove(ingredient);
                        });
                      },
                    );
                  }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _analyzeIngredientSelection,
              child: const Text('Analyze Ingredients'),
            ),
            const SizedBox(height: 20),
            _isIngredientLoading
                ? const CircularProgressIndicator()
                : Text(_ingredientResult, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
