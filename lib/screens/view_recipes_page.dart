import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';

class ViewRecipesPage extends StatefulWidget {
  const ViewRecipesPage({super.key});

  @override
  State<ViewRecipesPage> createState() => _ViewRecipesPageState();
}

class _ViewRecipesPageState extends State<ViewRecipesPage> {
  List<Map<String, dynamic>> _allRecipes = [];
  List<Map<String, dynamic>> _filteredRecipes = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRecipes();
    _searchController.addListener(_filterRecipes);
  }

  Future<void> _loadRecipes() async {
    final String jsonStr = await rootBundle.loadString('assets/data/recipes.json');
    final List<dynamic> jsonData = jsonDecode(jsonStr);
    setState(() {
      _allRecipes = List<Map<String, dynamic>>.from(jsonData);
      _filteredRecipes = _allRecipes;
    });
  }

  void _filterRecipes() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredRecipes = _allRecipes
          .where((recipe) =>
              recipe['meal_name'].toString().toLowerCase().contains(query))
          .toList();
    });
  }

  Widget _buildRecipeCard(Map<String, dynamic> recipe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _styledText("Recipe ID: ${recipe['ID']}"),
          _styledText("Name of Dish: ${recipe['meal_name']}", isBold: true),
          _styledText("Ingredients:\n${recipe['ingredients'].join(', ')}"),
          _styledText("Number of Servings:\n${recipe['proportions'].join(', ')}"),
          _styledText("Recipe Directions:\n${recipe['directions'].join('\n')}"),
          _styledText("Source: ${recipe['source']}"),
        ],
      ),
    );
  }

  Widget _styledText(String text, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8ED),
      appBar: AppBar(
        backgroundColor: const Color(0xFF955306),
        foregroundColor: Colors.white,
        title: Text('View Recipes', style: GoogleFonts.lobster(fontSize: 24)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            // Search Bar
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(fontFamily: 'Inter'),
                decoration: const InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: "Search by Dish Name",
                  border: InputBorder.none,
                ),
              ),
            ),
            Expanded(
              child: _filteredRecipes.isEmpty
                  ? const Center(
                      child: Text("No recipes found", style: TextStyle(fontFamily: 'Inter')),
                    )
                  : ListView.builder(
                      itemCount: _filteredRecipes.length,
                      itemBuilder: (context, index) {
                        return _buildRecipeCard(_filteredRecipes[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
