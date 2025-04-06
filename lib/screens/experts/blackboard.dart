import 'package:flutter/material.dart';
import "image.dart";
import "ingredient.dart";
import "text.dart";
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

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

  TextEditingController ingredientsController = TextEditingController();
  TextEditingController textController = TextEditingController();
  ImagePicker _picker = ImagePicker();

  ImageExpert imageExpert = ImageExpert();
  IngredientsExpert ingredientsExpert = IngredientsExpert();
  TextExpert textExpert = TextExpert();

  File? _image;

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

Future<void> controller() async {
  var (imageResult, imageConfidence) = await imageExpert.predictDish(_image);
  var (textResult, textConfidence) = await textExpert.predictDish(textController.text);
  var (ingredientResult, ingredientConfidence) = await ingredientsExpert.predictDish(ingredientsController.text);

  if (textConfidence >= 0.5) {
    // Prioritize TextExpert if confidence is 50% or above
    setState(() {
      predictedDish = textResult;
      confidence = textConfidence;
    });
  } else {
    // Otherwise, pick the highest among all three experts
    if (imageConfidence >= textConfidence &&
        imageConfidence >= ingredientConfidence) {
      setState(() {
        predictedDish = imageResult;
        confidence = imageConfidence;
      });
    } else if (ingredientConfidence >= textConfidence) {
      setState(() {
        predictedDish = ingredientResult;
        confidence = ingredientConfidence;
      });
    } else {
      setState(() {
        predictedDish = textResult;
        confidence = textConfidence;
      });
    }
  }
}



  BoxDecoration _customBoxDecoration() => BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF955306),
            offset: Offset(6, 6),
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8ED),
      appBar: AppBar(
        title: Text(
          "What’s that Dish?",
          style: GoogleFonts.lobster(
            fontSize: 26,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF955306),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Upload Dish Image:", style: GoogleFonts.lobster(fontSize: 20)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  child: Text("Gallery", style: TextStyle(fontFamily: "Inter", fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    elevation: 6,
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Colors.black, width: 2),
                    ),
                    shadowColor: const Color(0xFF955306),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.camera),
                  child: Text("Camera", style: TextStyle(fontFamily: "Inter", fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    elevation: 6,
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Colors.black, width: 2),
                    ),
                    shadowColor: const Color(0xFF955306),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Container(
              decoration: _customBoxDecoration(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: ingredientsController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter Ingredients (comma-separated)",
                ),
                style: const TextStyle(fontFamily: "Inter", fontSize: 16),
              ),
            ),
            const SizedBox(height: 25),
            Container(
              decoration: _customBoxDecoration(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: textController,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Describe the Dish",
                ),
                style: const TextStyle(fontFamily: "Inter", fontSize: 16),
              ),
            ),
            const SizedBox(height: 30), // Increased spacing
            Center(
              child: ElevatedButton.icon(
              onPressed: controller,
              icon: const Icon(Icons.restaurant),
              label: Text(
                "What’s That Dish?",
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF955306),
                  foregroundColor: Colors.white,
                  elevation: 6,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(color: Colors.black, width: 2),
                  ),
                  shadowColor: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 30),
            Text("Predicted Dish:", style: GoogleFonts.lobster(fontSize: 20)),
            Text(predictedDish, style: const TextStyle(fontFamily: "Inter", fontSize: 18)),
            const SizedBox(height: 10),
            Text("Prediction Confidence:", style: GoogleFonts.lobster(fontSize: 20)),
            Text("$confidence", style: const TextStyle(fontFamily: "Inter", fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
