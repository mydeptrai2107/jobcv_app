import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TagInfoWidget extends StatelessWidget {
  const TagInfoWidget({super.key, required this.title, required this.content});
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      padding:
          EdgeInsets.only(left: 15.w, right: 15.w, top: 25.h, bottom: 25.h),
      margin: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.black.withOpacity(0.7)),
          ),
          Container(
            margin: EdgeInsets.only(left: 10.w, top: 15.h),
            child: Text(
              content,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withOpacity(0.3)),
            ),
          ),
        ],
      ),
    );
  }
}
