// ignore_for_file: must_be_immutable

import 'package:app/configs/image_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InformationItem extends StatelessWidget {
  final String icon;
  final String title;
  VoidCallback? onPress;
  InformationItem(
      {super.key, required this.icon, required this.title, this.onPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 226, 225, 225),
              ),
              child: SvgPicture.asset(
                icon,
                width: 20,
                height: 20,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 30,
            ),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const Expanded(child: SizedBox()),
            SvgPicture.asset(
              ImageFactory.right,
              width: 20,
              height: 20,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
