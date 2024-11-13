import 'package:app/modules/candidate/presentations/themes/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class TagRecuitmentItem extends StatelessWidget {
  const TagRecuitmentItem({super.key, required this.title, required this.icon});

  final String title;
  final String icon;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.4,
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            // ignore: deprecated_member_use
            color: primaryColor,
            height: 18,
            width: 18,
          ),
          SizedBox(
            width: 8.w,
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: primaryColor),
          )
        ],
      ),
    );
  }
}
