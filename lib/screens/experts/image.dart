import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ImageExpertPage extends StatefulWidget {
  const ImageExpertPage({super.key});

  @override
  State<ImageExpertPage> createState() => _ImageExpertPageState();
}

class _ImageExpertPageState extends State<ImageExpertPage> {
  File? _image;
  String _result = '';
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _result = '';
      });
      _analyzeImage();
    }
  }

  Future<void> _analyzeImage() async {
    if (_image == null) return;

    setState(() => _isLoading = true);

    final apiKey = dotenv.env['IMAGE_RECOGNITION_API'];
    final apiUrl =
        'https://api.clarifai.com/v2/users/clarifai/apps/main/models/food-item-recognition/versions/1d5fd481e0cf4826aa72ec3ff049e044/outputs';

    final base64Image = base64Encode(await _image!.readAsBytes());

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
      final name = predictions[0]['name'];
      final confidence = predictions[0]['value'];

      setState(() {
        _isLoading = false;
        _result =
            'Dish: $name\nConfidence: ${(confidence * 100).toStringAsFixed(2)}%';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _result = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Image Recognition")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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
            const SizedBox(height: 16),
            _isLoading ? const CircularProgressIndicator() : Text(_result),
          ],
        ),
      ),
    );
  }
}
