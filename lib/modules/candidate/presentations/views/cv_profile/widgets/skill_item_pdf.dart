import 'package:flutter/material.dart';

class SkillItemPDF extends StatelessWidget {
  const SkillItemPDF({
    super.key,
    required this.nameSkill,
    required this.description,
  });
  final String nameSkill;
  final String description;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            nameSkill,
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
          ),
          Text(
            description,
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 9),
          )
        ],
      ),
    );
  }
}
