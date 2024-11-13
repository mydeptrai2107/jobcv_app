import 'package:flutter/material.dart';

class CompulsoryText extends StatelessWidget {
  const CompulsoryText(
      {super.key,
      required this.title,
      this.colorText,
      this.colorAsterisk,
      this.fontSize});
  final String title;
  final Color? colorText;
  final Color? colorAsterisk;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style:
              TextStyle(color: colorText ?? Colors.black, fontSize: fontSize),
        ),
        Text(
          ' (*)',
          style: TextStyle(
              color: colorAsterisk ?? Colors.red,
              fontSize: fontSize,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
