import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';

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

  // Load the existing recipe data from the asset
  Future<List<Map<String, dynamic>>> _loadRecipes() async {
    String jsonString = await rootBundle.loadString('assets/data/recipes.json');
    return List<Map<String, dynamic>>.from(json.decode(jsonString));
  }

  // Save the updated recipe data to the JSON file
  Future<void> _saveRecipes(List<Map<String, dynamic>> recipes) async {
    final file = File('assets/data/recipes.json');
    String updatedJson = JsonEncoder.withIndent('  ').convert(recipes);
    await file.writeAsString(updatedJson);
  }

  // Add the recipe to the list and save it
  void _addRecipe(List<Map<String, dynamic>> recipes) {
    if (nameController.text.isEmpty || ingredientsController.text.isEmpty) {
      // Show an error message if required fields are missing
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in the required fields: Meal Name, Ingredients")),
      );
      return;
    }

    // Parse the ingredients list from the user input
    List<String> ingredientsList = ingredientsController.text.split(',').map((e) => e.trim()).toList();
    // Parse the directions from the user input (assuming each direction is a new line)
    List<String> directionsList = directionsController.text.split('\n').map((e) => e.trim()).toList();
    // Parse the proportion field (assuming user enters comma-separated proportions)
    List<String> proportionList = proportionController.text.split(',').map((e) => e.trim()).toList();

    // Create a new recipe
    Map<String, dynamic> newRecipe = {
      "id": idController.text.isEmpty ? "Default" : idController.text,
      "name": nameController.text,
      "proportion": proportionList.isEmpty ? ["N/A"] : proportionList,
      "directions": directionsList.isEmpty ? ["N/A"] : directionsList,
      "link": linkController.text.isEmpty ? "N/A" : linkController.text,
      "source": sourceController.text.isEmpty ? "N/A" : sourceController.text,
      "ingredients": ingredientsList,
    };

    // Add the new recipe to the list of existing recipes
    recipes.add(newRecipe);

    // Save the updated list to the JSON file
    _saveRecipes(recipes);

    // Clear the input fields
    idController.clear();
    nameController.clear();
    proportionController.clear();
    directionsController.clear();
    linkController.clear();
    sourceController.clear();
    ingredientsController.clear();

    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Recipe added successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Recipe")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          List<Map<String, dynamic>> recipes = snapshot.data ?? [];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: idController,
                    decoration: const InputDecoration(labelText: "ID (optional)"),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Meal Name *"),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: proportionController,
                    decoration: const InputDecoration(labelText: "Proportion (optional)"),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: directionsController,
                    decoration: const InputDecoration(labelText: "Directions (separate by new lines)"),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: linkController,
                    decoration: const InputDecoration(labelText: "Link (optional)"),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: sourceController,
                    decoration: const InputDecoration(labelText: "Source (optional)"),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: ingredientsController,
                    decoration: const InputDecoration(
                      labelText: "Ingredients * (comma-separated)",
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _addRecipe(recipes);
                    },
                    child: const Text("Add Recipe"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
