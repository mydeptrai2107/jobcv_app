import 'package:app/shared/utils/format.dart';
import 'package:flutter/material.dart';

class ExperienceItemPDF extends StatelessWidget {
  const ExperienceItemPDF(
      {super.key,
      required this.position,
      required this.nameCompany,
      required this.description,
      required this.to,
      required this.from});
  final String position;
  final String nameCompany;
  final String description;
  final DateTime to;
  final DateTime from;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '$position | ${Format.formatDateTimeToYYYYmm(to)} - ${Format.formatDateTimeToYYYYmm(from)}',
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
          ),
          Text(
            nameCompany,
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
