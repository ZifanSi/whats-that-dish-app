import 'package:flutter/material.dart';

class FancyTitleBar extends StatelessWidget {
  const FancyTitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100.0), // ← Adjust this value
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              "WHAT'S THAT DISH",
              style: TextStyle(
                fontFamily: 'Scripter',
                fontSize: 70,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 5
                  ..color = const Color(0xFF955306),
              ),
            ),
            const Text(
              "WHAT'S THAT DISH?",
              style: TextStyle(
                fontFamily: 'Scripter',
                fontSize: 0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
