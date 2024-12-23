// ignore_for_file: deprecated_member_use

import 'package:app/modules/candidate/presentations/themes/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class InfoRecuitmentItem extends StatelessWidget {
  const InfoRecuitmentItem(
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
      margin: EdgeInsets.only(top: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 185, 247, 193)),
            height: 35.h,
            width: 35.h,
            child: SvgPicture.asset(
              icon,
              color: primaryColor,
            ),
          ),
          SizedBox(
            width: 20.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 25,
                child: Text(
                  title,
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 13,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                width: size.width - 125,
                child: Text(
                  content,
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                height: 1,
                width: size.width - 125,
                color: Colors.grey.withOpacity(0.5),
              )
            ],
          )
        ],
      ),
    );
  }
}
