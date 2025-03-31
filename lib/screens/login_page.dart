import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _message = '';

  Future<List<Map<String, dynamic>>> _loadUsers() async {
    final jsonString = await rootBundle.loadString('assets/data/t_users.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.cast<Map<String, dynamic>>();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final users = await _loadUsers();

    final user = users.firstWhere(
      (u) => u['email'] == email && u['password'] == password,
      orElse: () => {},
    );

    if (user.isNotEmpty) {
      // Navigate to the Experts page
      if (context.mounted) {
        Navigator.pushNamed(context, '/experts');
      }
    } else {
      setState(() {
        _message = 'Invalid email or password.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: const Text('Login')),
            const SizedBox(height: 20),
            Text(_message, style: const TextStyle(fontSize: 16)),
            //debug button for navigating to image recognition:
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/image_recognition');
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Go to Image Recognition (Debug)'),
            ),            
          ],
        ),
      ),
    );
  }
}
