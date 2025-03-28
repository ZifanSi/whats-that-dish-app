import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'screens/experts_page.dart';
import 'screens/ingredients_analysis.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/experts': (context) => const ExpertsPage(),
        '/ingredients': (context) => const IngredientsAnalysisPage(),
      },
    );
  }
}
