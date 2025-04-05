import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  _AddRecipePageState createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController proportionController = TextEditingController();
  final TextEditingController directionsController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();

  Future<List<Map<String, dynamic>>> _loadRecipes() async {
    String jsonString = await rootBundle.loadString('assets/data/recipes.json');
    return List<Map<String, dynamic>>.from(json.decode(jsonString));
  }

  Future<void> _saveRecipes(List<Map<String, dynamic>> recipes) async {
    final file = File('assets/data/recipes.json');
    String updatedJson = JsonEncoder.withIndent('  ').convert(recipes);
    await file.writeAsString(updatedJson);
  }

  void _addRecipe(List<Map<String, dynamic>> recipes) {
    if (nameController.text.isEmpty || ingredientsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in the required fields: Meal Name, Ingredients")),
      );
      return;
    }

    List<String> ingredientsList = ingredientsController.text.split(',').map((e) => e.trim()).toList();
    List<String> directionsList = directionsController.text.split('\n').map((e) => e.trim()).toList();
    List<String> proportionList = proportionController.text.split(',').map((e) => e.trim()).toList();

    Map<String, dynamic> newRecipe = {
      "id": idController.text.isEmpty ? "Default" : idController.text,
      "name": nameController.text,
      "proportion": proportionList.isEmpty ? ["N/A"] : proportionList,
      "directions": directionsList.isEmpty ? ["N/A"] : directionsList,
      "link": linkController.text.isEmpty ? "N/A" : linkController.text,
      "source": sourceController.text.isEmpty ? "N/A" : sourceController.text,
      "ingredients": ingredientsList,
    };

    recipes.add(newRecipe);
    _saveRecipes(recipes);

    idController.clear();
    nameController.clear();
    proportionController.clear();
    directionsController.clear();
    linkController.clear();
    sourceController.clear();
    ingredientsController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Recipe added successfully!")),
    );
  }

  Widget _styledInput({required String label, required TextEditingController controller, int maxLines = 1}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF955306),
            offset: Offset(4, 4),
            blurRadius: 6,
          ),
        ],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(fontFamily: 'Inter'),
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
            labelStyle: const TextStyle(fontFamily: 'Inter'),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8ED),
      appBar: AppBar(
        title: Text("Add New Recipe", style: GoogleFonts.lobster(fontSize: 24)),
        backgroundColor: const Color(0xFF955306),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          List<Map<String, dynamic>> recipes = snapshot.data ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _styledInput(label: "ID (Optional)", controller: idController),
                _styledInput(label: "Name of the Dish *", controller: nameController),
                _styledInput(label: "Number of Servings (Optional)", controller: proportionController),
                _styledInput(
                  label: "Recipe Directions  (separate by new lines)",
                  controller: directionsController,
                  maxLines: 5,
                ),
                _styledInput(label: "Link (Optional)", controller: linkController),
                _styledInput(label: "Source (Optional)", controller: sourceController),
                _styledInput(label: "Ingredients * (comma-separated)", controller: ingredientsController),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => _addRecipe(recipes),
                    icon: const Icon(Icons.menu_book, color: Colors.white),
                    label: const Text(
                      "Add Recipe",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF955306),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(color: Colors.black, width: 2),
                      ),
                      shadowColor: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
