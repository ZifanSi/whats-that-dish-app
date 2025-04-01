import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';

/// This class stores the outputs from three experts and 
/// sends them to the Gemini API to determine the final dish.
class Blackboard {
  // -- Fields to store each expert's result. --
  // We assume each result is a Map<String, dynamic> containing
  // things like 'dishName', 'confidence', 'recipeDetails', etc.

  Map<String, dynamic>? _ingredientsAnalysisOutput; 
  Map<String, dynamic>? _descriptionAnalysisOutput;
  Map<String, dynamic>? _imageAnalysisOutput;

  // The final decision after combining the experts
  Map<String, dynamic>? _finalDish;

  /// Set the Ingredients Analysis output
  void setIngredientsAnalysisOutput(Map<String, dynamic> result) {
    _ingredientsAnalysisOutput = result;
  }

  /// Set the Description (Text) Analysis output
  void setDescriptionAnalysisOutput(Map<String, dynamic> result) {
    _descriptionAnalysisOutput = result;
  }

  /// Set the Image Analysis output
  void setImageAnalysisOutput(Map<String, dynamic> result) {
    _imageAnalysisOutput = result;
  }

  /// Returns the final dish decision (if already computed).
  Map<String, dynamic>? getFinalDish() {
    return _finalDish;
  }

  /// Constructs a single JSON/prompt from each expert output,
  /// calls the Gemini API to unify them, and stores the final dish.
  Future<Map<String, dynamic>> computeFinalDishUsingGemini() async {
    // 1. Build a combined input from all experts
    final combinedExpertData = {
      'ingredientsAnalysis': _ingredientsAnalysisOutput ?? {},
      'descriptionAnalysis': _descriptionAnalysisOutput ?? {},
      'imageAnalysis': _imageAnalysisOutput ?? {}
    };

    // 2. Build your prompt text
    String prompt = _buildPrompt(combinedExpertData);

    // Create the Gemini model instance (for demonstration, using a placeholder API key)
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: 'AIzaSyCK779iHw9_Q3UuAdSwQMCbkCuCY33qyVY', // Replace with your real key
    );

    try {
      // 3. Generate content using the prompt.
      final response = await model.generateContent([Content.text(prompt)]);

      if (response.isNotEmpty) {
        // We expect the response text to be JSON.
        final responseText = response[0].text;

        // Attempt to parse the text as JSON.
        try {
          final Map<String, dynamic> responseData = jsonDecode(responseText);
          // 4. Parse the data to get the final dish decision
          _finalDish = _parseGeminiResponse(responseData);
        } catch (jsonError) {
          // If the text isn't valid JSON, handle it.
          _finalDish = {
            'finalDish': 'Unknown',
            'confidence': 0.0,
            'notes': 'Could not parse JSON: $responseText',
          };
        }
      } else {
        // If there's no response from the model
        _finalDish = {
          'finalDish': 'No response',
          'confidence': 0.0,
          'notes': 'Model returned an empty response',
        };
      }
    } catch (e) {
      // Handle any errors from the model
      _finalDish = {
        'finalDish': 'Error',
        'confidence': 0.0,
        'notes': 'Exception: $e',
      };
    }

    return _finalDish!;
  }

  /// Helper: Build a prompt from the combined map
  String _buildPrompt(Map<String, dynamic> combinedData) {
    // Retrieve expert outputs, defaulting to empty maps if null
    final ingrOutput = combinedData['ingredientsAnalysis'] ?? {};
    final descOutput = combinedData['descriptionAnalysis'] ?? {};
    final imgOutput  = combinedData['imageAnalysis'] ?? {};

    // Transform the ingredients analysis output if it uses dummy keys.
    // If the map contains 'mealName', convert it to the expected format with 'finalDish' and 'confidence'.
    final ingredientsAnalysisMap = (ingrOutput is Map<String, dynamic> && ingrOutput.containsKey('mealName'))
        ? {
            'finalDish': ingrOutput['mealName'],
            'confidence': ingrOutput['confidence']
          }
        : ingrOutput;

    // Transform the image analysis output if it uses dummy keys.
    // If the map contains 'dishName', convert it to the expected format with 'finalDish' and 'confidence' (using key 'value').
    final imageAnalysisMap = (imgOutput is Map<String, dynamic> && imgOutput.containsKey('dishName'))
        ? {
            'finalDish': imgOutput['dishName'],
            'confidence': imgOutput['value']
          }
        : imgOutput;

    // Build and return the unified prompt with high-level instructions
    return """
    You are an AI expert tasked with unifying the outputs of three distinct dish recognition experts. 
    Each expert provides their assessment as follows:
    1) Ingredients Analysis: may include detailed recipes and ingredient data.
    2) Description Analysis: offers textual insights about the dish.
    3) Image Analysis: primarily includes the dish name and visual attributes.

    Using only these inputs, apply probabilistic reasoning and careful analysis to determine which expert's output is most likely correct, or merge them to form a more accurate prediction if needed. 
    Your final output should be a JSON object containing at minimum:
       - 'finalDish': the determined dish name (a string)
       - 'confidence': a numeric value between 0 and 1 indicating certainty
    You may include additional notes if necessary.

    Input Expert Outputs:
       - Ingredients Analysis: ${jsonEncode(ingredientsAnalysisMap)}
       - Description Analysis: ${jsonEncode(descOutput)}
       - Image Analysis: ${jsonEncode(imageAnalysisMap)}
    """;
  }

  /// Helper: Parse the Gemini response to extract the final dish, confidence, etc.
  Map<String, dynamic> _parseGeminiResponse(Map<String, dynamic> responseData) {
    // Example if Gemini returns:
    // {
    //   "finalDish": "Pepperoni Pizza",
    //   "confidence": 0.88,
    //   "notes": "some additional text..."
    // }
    return {
      "finalDish": responseData["finalDish"],
      "confidence": responseData["confidence"],
      "notes": responseData["notes"]
    };
  }
}