import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';

import '../components/rounded_input_field.dart';
import '../components/rounded_password_field.dart';
import '../components/rounded_button.dart';
import '../components/under_part.dart';
import '../components/page_title_bar.dart';
import '../components/upside.dart';

import 'package:crypto/crypto.dart';
import 'dart:convert'; 

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

    final digest = sha256.convert(utf8.encode(password)).toString();

    final users = await _loadUsers();

    final user = users.firstWhere(
      (u) => u['email'] == email && u['password'] == digest,
      orElse: () => {},
    );

    if (user.isNotEmpty) {
      // Navigate to the Experts page
      if (context.mounted) {
        Navigator.pushNamed(context, '/homePage');
      }
    } else {
      setState(() {
        _message = 'Invalid email or password.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                const Upside(imgUrl: "assets/images/login.png"),
                const FancyTitleBar(),
                Padding(
                  padding: const EdgeInsets.only(top: 320.0),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        Text(
                          "Account Login",
                          style: GoogleFonts.lobster(
                            fontSize: 24,
                            color: Color(0xFF955306),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Column(
                            children: [
                              RoundedInputField(
                                hintText: "Email",
                                icon: Icons.email,
                                controller: _emailController,
                              ),
                              RoundedPasswordField(
                                controller: _passwordController,
                              ),
                              const SizedBox(height: 10),
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: RoundedButton(
                                  text: 'LOGIN',
                                  press: _login,
                                  // Keep default Comic Sans-like style
                                ),
                              ),
                              if (_message.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    _message,
                                    style: GoogleFonts.lobster(
                                      color: Colors.red,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        UnderPart(
                          title: "Don't have an account?",
                          navigatorText: " Create One",
                          onTap: () {
                            Navigator.pushNamed(context, '/create_account');
                          },
                          textStyle: GoogleFonts.lobster(
                            color: const Color(0xFF955306),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
