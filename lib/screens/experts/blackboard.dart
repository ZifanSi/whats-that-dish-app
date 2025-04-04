import 'package:flutter/material.dart';
import "image.dart";
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BlackboardPage extends StatefulWidget {
  const BlackboardPage({super.key});

  @override
  State<BlackboardPage> createState() => _BlackboardPageState();
}

class _BlackboardPageState extends State<BlackboardPage> {
  String imageResult = "";
  String textResult = "";
  String ingredientResult = "";

  double imageConfidence = 0.0;
  double textConfidence = 0.0;
  double ingredientConfidence = 0.0;

  ImagePicker _picker = ImagePicker();

  // Experts.
  ImageExpert imageExpert = ImageExpert();

  // Input datatypes.
  File? _image;

  // Outputs.
  String predictedDish = "";
  double confidence = 0.0;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      
    }
  }

  Future<void> controller() async{
    // Controller logic.

    // Call each expert.
    var (imageResult, imageConfidence) = await imageExpert.analyzeImage(_image);

    setState(() {
        predictedDish = imageResult;
      confidence = imageConfidence;
    });
    

    String bestResult;
    if (imageConfidence >= textConfidence &&
        imageConfidence >= ingredientConfidence) {
      bestResult =
          '📷 Best Expert: Image Recognition\n$imageResult\nConfidence: 99%';
    } else if (textConfidence >= ingredientConfidence) {
      bestResult =
          '📝 Best Expert: Text Description\n$textResult\nConfidence: 80%';
    } else {
      bestResult =
          '🥗 Best Expert: Ingredients\n$ingredientResult\nConfidence: 50%';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🧠 Blackboard')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Final Decision (Highest Confidence)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // Image input.
            _image == null
                ? const Text('No image selected')
                : Image.file(_image!, height: 200),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo),
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
              // Run blackboard.
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: controller,
                icon: const Icon(Icons.restaurant),
                label: const Text('What\'s That Dish?'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 12.0,
                  ),
                ),
              ),
              Text(
              'Predicted Dish: $predictedDish\nPrediction Confidence:$confidence',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
