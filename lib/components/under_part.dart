import 'package:flutter/material.dart';

class UnderPart extends StatelessWidget {
  final String title;
  final String navigatorText;
  final VoidCallback onTap;
  final TextStyle? textStyle;

  const UnderPart({
    super.key,
    required this.title,
    required this.navigatorText,
    required this.onTap,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: textStyle),
        GestureDetector(
          onTap: onTap,
          child: Text(
            navigatorText,
            style: textStyle?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
