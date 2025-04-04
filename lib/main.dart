import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/login_page.dart';
import 'screens/home_page.dart';
import 'screens/create_account_page.dart';
import 'screens/experts/blackboard.dart';
import 'screens/recommendations_page.dart';

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
        '/homePage': (context) => HomePage(),
        '/create_account': (context) => const CreateAccountPage(),
        '/blackboard': (context) => BlackboardPage(),
        '/recommendation': (context) => RecommendationsPage(),
      },
    );
  }
}
