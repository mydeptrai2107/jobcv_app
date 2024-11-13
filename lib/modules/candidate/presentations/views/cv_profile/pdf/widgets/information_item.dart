import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InformationCVItem extends StatelessWidget {
  const InformationCVItem(
      {super.key, required this.icon, required this.content});
  final String icon;
  final String content;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: (size.width - 50) / 2,
      margin: const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            width: 15,
            height: 15,
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: (size.width - 100) / 2,
            child: Text(
              content,
              maxLines: 5,
              style: const TextStyle(fontSize: 9),
            ),
          )
        ],
      ),
    );
  }
}
