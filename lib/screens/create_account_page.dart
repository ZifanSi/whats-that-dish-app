// lib/screens/create_account_page.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for the utf8.encode method


class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _message = '';

  // Load the existing users data from the asset
  Future<List<Map<String, dynamic>>> _loadUsers() async {
    String jsonString = await rootBundle.loadString('assets/data/t_users.json');
    return List<Map<String, dynamic>>.from(json.decode(jsonString));
  }

  // Save the updated user data to the JSON file
  Future<void> _saveUsers(List<Map<String, dynamic>> userData) async {
    final file = File('assets/data/t_users.json');
    String updatedJson = JsonEncoder.withIndent('  ').convert(userData);
    await file.writeAsString(updatedJson);
  }

  void _mockCreateAccount() async{
    // Load the current user database.
    List<Map<String, dynamic>> users = await _loadUsers();

    var bytes = utf8.encode(_passwordController.text);
    var digest = sha256.convert(bytes).toString();

    // Create a new user and add to the user database.
    Map<String, dynamic> newUser = {
      "id": _emailController.text,
      "password": digest,
    };
    users.add(newUser);

    // Write the user date back to the json file.
    _saveUsers(users);

    setState(() {
      _message = 'Account created successfully!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Create a New Account',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 30),

                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _mockCreateAccount,
                  child: const Text('Create Account'),
                ),

                const SizedBox(height: 16),
                Text(_message, style: const TextStyle(fontSize: 16)),

                const SizedBox(height: 30),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Back to Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
