import 'package:flutter/material.dart';

class Upside extends StatelessWidget {
  final String imgUrl;

  const Upside({super.key, required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.4, // Adjust height if needed
      width: double.infinity,     // Full width
      child: Image.asset(
        imgUrl,
        fit: BoxFit.cover,         // Stretch to fill the width
      ),
    );
  }
}
