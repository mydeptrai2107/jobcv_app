// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:app/modules/candidate/presentations/themes/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ItemManageJob extends StatefulWidget {
  ItemManageJob(
      {super.key,
      required this.icon,
      required this.title,
      this.count,
      this.onTap});
  final String icon;
  final String title;
  int? count;
  VoidCallback? onTap;

  @override
  State<ItemManageJob> createState() => _ItemManageJobState();
}

class _ItemManageJobState extends State<ItemManageJob> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(widget.icon,
                width: 22, height: 22, color: primaryColor),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: (size.width - 150) / 2,
                  child: Text(
                    widget.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Text(
                  widget.count.toString() == '' || widget.count == null
                      ? ''
                      : widget.count.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      color: primaryColor),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
