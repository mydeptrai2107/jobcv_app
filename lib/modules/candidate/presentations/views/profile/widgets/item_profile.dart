// ignore_for_file: deprecated_member_use

import 'package:app/configs/image_factory.dart';
import 'package:app/modules/candidate/presentations/themes/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ItemProfile extends StatelessWidget {
  const ItemProfile(
      {super.key,
      required this.icon,
      required this.title,
      required this.content});

  final String icon;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 10.h, bottom: 10),
      width: size.width - 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 216, 241, 220)),
            height: 35.h,
            width: 35.h,
            child: SvgPicture.asset(
              icon,
              color: primaryColor,
            ),
          ),
          SizedBox(
            width: size.width - 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 25,
                  child: Text(
                    title,
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  width: size.width - 115,
                  child: Text(
                    content,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
          SvgPicture.asset(
            ImageFactory.right,
            width: 20,
            height: 20,
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}
