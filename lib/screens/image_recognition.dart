import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageRecognitionPage extends StatefulWidget {
  const ImageRecognitionPage({super.key});

  @override
  _ImageRecognitionPageState createState() => _ImageRecognitionPageState();
}

class _ImageRecognitionPageState extends State<ImageRecognitionPage> {
  File? _image; // Holds the uploaded image
  String _result = ''; // Holds API results
  bool _isLoading = false; // For loading indicator
  final ImagePicker _picker = ImagePicker(); // To pick image from gallery

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _result = ''; // Reset result on new image upload
      });
      _analyzeImage(); // Automatically analyze after picking
    }
  }

  // Function to analyze the image using Clarifai API
  Future<void> _analyzeImage() async {
    if (_image == null) {
      setState(() {
        _result = 'Please upload an image first.';
      });
      return;
    }

    // Validate if the file is an image
    if (!_image!.path.endsWith('.jpg') && !_image!.path.endsWith('.png')) {
      setState(() {
        _result = 'Please select a valid image file (.jpg or .png).';
      });
      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    // Get API Key from .env
    final apiKey = dotenv.env['IMAGE_RECOGNITION_API'];
    if (apiKey == null || apiKey.isEmpty) {
      setState(() {
        _result = 'API Key is missing. Please configure your .env file.';
      });
      return;
    }

    // ✅ Correct Clarifai API URL
    final apiUrl =
        'https://api.clarifai.com/v2/users/clarifai/apps/main/models/food-item-recognition/versions/1d5fd481e0cf4826aa72ec3ff049e044/outputs';

    // ✅ Convert image to base64 format
    final bytes = await _image!.readAsBytes();
    final base64Image = base64Encode(bytes);

    try {
      // ✅ Prepare and send the API request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Key $apiKey', // Clarifai API Key
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'inputs': [
            {
              'data': {
                'image': {'base64': base64Image}
              }
            }
          ]
        }),
      );

      setState(() {
        _isLoading = false; // Hide loading indicator after response
      });

      // ✅ Check for valid response
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final predictions = responseData['outputs'][0]['data']['concepts'];

        if (predictions == null || predictions.isEmpty) {
          setState(() {
            _result = 'No dish identified. Try another image!';
          });
        } else {
          setState(() {
            _result =
                'Dish: ${predictions[0]['name']} \nConfidence: ${(predictions[0]['value'] * 100).toStringAsFixed(2)}%';
          });
        }
      } else {
        // Handle error if response is not 200
        setState(() {
          _result = 'Error: Unable to analyze the image. Try again.';
        });
        print('Error response: ${response.body}');
      }
    } catch (e) {
      // Catch any exceptions during the API call
      setState(() {
        _isLoading = false;
        _result = 'Error: Failed to connect to the server.';
      });
      print('Exception occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dish Recognition'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Wondering what the dish in your gallery photo is?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            _image == null
                ? const Text(
                    'No image selected',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  )
                : Image.file(
                    _image!,
                    height: 200,
                  ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.upload),
              label: const Text('Upload Picture'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 12.0),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator() // Show loading indicator while processing
                : Text(
                    _result,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
          ],
        ),
      ),
    );
  }
}
