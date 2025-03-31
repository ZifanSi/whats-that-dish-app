import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/login_page.dart';
import 'screens/experts_page.dart';
import 'screens/ingredients_analysis.dart';
import 'screens/recipe_manager.dart';
import 'screens/image_recognition.dart';

Future<void> main() async {
  // Loading the .env file
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dish Identification App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/experts': (context) => ExpertsPage(),
        '/ingredients': (context) => IngredientsAnalysisPage(),
        '/recipe_manager': (context) => AddRecipePage(),
        '/image_recognition': (context) => ImageRecognitionPage(),
      },
    );
  }
}
