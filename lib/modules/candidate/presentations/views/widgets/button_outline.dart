// ignore_for_file: deprecated_member_use

import 'package:app/modules/candidate/presentations/themes/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ButtonOutline extends StatelessWidget {
  final String title;
  final String? icon;
  final VoidCallback? onPress;
  final Color? backGroundColor;
  final double? paddingvertical;
  final double? paddingHorizontal;
  final double? height;
  final double? width;
  final double? borderRadius;
  final double? fontSize;
  final Color? textColor;
  final double? widthBorder;
  final Color? colorsBorder;
  const ButtonOutline(
      {super.key,
      required this.title,
      this.icon,
      this.backGroundColor,
      this.paddingHorizontal,
      this.paddingvertical,
      this.onPress,
      this.width,
      this.height,
      this.borderRadius,
      this.fontSize,
      this.textColor,
      this.widthBorder,
      this.colorsBorder});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPress,
        borderRadius: BorderRadius.circular(borderRadius ?? 20),
        child: Ink(
            height: height,
            width: width,
            padding: EdgeInsets.symmetric(
                horizontal: paddingHorizontal ?? 20,
                vertical: paddingvertical ?? 10),
            decoration: BoxDecoration(
                border: Border.all(
                    width: widthBorder ?? 1,
                    color: colorsBorder ?? primaryColor),
                color: backGroundColor ?? Colors.white,
                borderRadius: BorderRadius.circular(borderRadius ?? 20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null)
                  SvgPicture.asset(
                    icon!,
                    width: 20,
                    height: 20,
                    color: textColor ?? primaryColor,
                  ),
                if (icon != null)
                  const SizedBox(
                    width: 5,
                  ),
                Text(
                  title,
                  style: TextStyle(
                      color: textColor ?? primaryColor,
                      fontSize: fontSize ?? 12,
                      fontWeight: FontWeight.w600),
                ),
              ],
            )),
      ),
    );
  }
}
