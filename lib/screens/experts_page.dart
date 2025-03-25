import 'package:flutter/material.dart';

class ExpertsPage extends StatelessWidget {
  const ExpertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Experts')),
      body: const Center(child: Text('Welcome to the Experts Page!')),
    );
  }
}
