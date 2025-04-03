import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

class ExpertsPage extends StatefulWidget {
  const ExpertsPage({super.key});

  @override
  State<ExpertsPage> createState() => _ExpertsPageState();
}

class _ExpertsPageState extends State<ExpertsPage> {
  File? _image;
  String _result = '';
  String _textResult = '';
  String _ingredientResult = '';
  bool _isLoading = false;
  bool _isTextLoading = false;
  bool _isIngredientLoading = false;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController _textController = TextEditingController();

  List<String> _availableIngredients = [];
  List<String> _selectedIngredients = [];

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

    String bestMatch = '';
    int highestMatch = 0;

    for (var dish in dishes) {
      final List<dynamic> ingredients = dish['ingredients'];
      int matches =
          ingredients.where((i) => _selectedIngredients.contains(i)).length;

      if (matches > highestMatch) {
        highestMatch = matches;
        bestMatch = dish['name'];
      }
    }

    setState(() {
      _isIngredientLoading = false;
      _ingredientResult =
          bestMatch.isNotEmpty
              ? 'Matched Dish: $bestMatch\nMatch Score: $highestMatch'
              : 'No matching dish found.';
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _result = '';
      });
      _analyzeImage();
    }
  }

  Future<void> _analyzeImage() async {
    if (_image == null) {
      setState(() => _result = 'Please upload an image first.');
      return;
    }

    setState(() => _isLoading = true);

    final apiKey = dotenv.env['IMAGE_RECOGNITION_API'];
    if (apiKey == null || apiKey.isEmpty) {
      setState(() {
        _result = 'API Key is missing. Please configure your .env file.';
        _isLoading = false;
      });
      return;
    }

    final apiUrl =
        'https://api.clarifai.com/v2/users/clarifai/apps/main/models/food-item-recognition/versions/1d5fd481e0cf4826aa72ec3ff049e044/outputs';

    final bytes = await _image!.readAsBytes();
    final base64Image = base64Encode(bytes);

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

      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final predictions = data['outputs'][0]['data']['concepts'];

        if (predictions != null && predictions.isNotEmpty) {
          final dishName = predictions[0]['name'];
          final confidence = predictions[0]['value'];

          setState(() {
            _result =
                'Dish: $dishName\nConfidence: ${(confidence * 100).toStringAsFixed(2)}%';
          });
        } else {
          setState(() => _result = 'No dish identified.');
        }
      } else {
        setState(() => _result = 'Failed to analyze image.');
        print('Clarifai error: ${response.body}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _result = 'Error occurred: $e';
      });
    }
  }

  Future<void> _analyzeTextDescription() async {
    final input = _textController.text.trim().toLowerCase();
    if (input.isEmpty) {
      setState(() => _textResult = 'Please enter a dish description.');
      return;
    }

    setState(() {
      _isTextLoading = true;
      _textResult = '';
    });

    try {
      final jsonStr = await rootBundle.loadString('assets/data/t_dishes.json');
      final List<dynamic> dishes = jsonDecode(jsonStr);

      String bestMatch = '';
      int bestScore = 0;

      for (var dish in dishes) {
        final description = (dish['description'] as String).toLowerCase();
        int score = 0;

        for (final word in input.split(' ')) {
          if (description.contains(word)) {
            score++;
          }
        }

        if (score > bestScore) {
          bestScore = score;
          bestMatch = dish['name'];
        }
      }

      setState(() {
        _isTextLoading = false;
        _textResult =
            bestMatch.isNotEmpty
                ? 'Matched Dish: $bestMatch\nMatch Score: $bestScore'
                : 'No matching dish found.';
      });
    } catch (e) {
      setState(() {
        _isTextLoading = false;
        _textResult = 'Error reading dish data: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Experts')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📷 Image Recognition Expert',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _image == null
                ? const Text('No image selected')
                : Image.file(_image!, height: 200),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery'),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _isLoading
                ? const CircularProgressIndicator()
                : Text(
                  _result,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
            const Divider(height: 30),
            const Text(
              '📝 Text Description Expert',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Type a short description of the dish...',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _analyzeTextDescription,
              child: const Text('Analyze Text Description'),
            ),
            const SizedBox(height: 10),
            _isTextLoading
                ? const CircularProgressIndicator()
                : Text(
                  _textResult,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
            const Divider(height: 30),
            const Text(
              '🥗 Ingredient Match Expert',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                          if (selected) {
                            _selectedIngredients.add(ingredient);
                          } else {
                            _selectedIngredients.remove(ingredient);
                          }
                        });
                      },
                    );
                  }).toList(),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _analyzeIngredientSelection,
              child: const Text('Analyze Ingredients'),
            ),
            const SizedBox(height: 10),
            _isIngredientLoading
                ? const CircularProgressIndicator()
                : Text(
                  _ingredientResult,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
          ],
        ),
      ),
    );
  }
}
