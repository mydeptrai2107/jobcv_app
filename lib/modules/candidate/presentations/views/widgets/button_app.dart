import 'package:app/modules/candidate/presentations/themes/color.dart';
import 'package:flutter/material.dart';

class ButtonApp extends StatelessWidget {
  final String title;
  final VoidCallback? onPress;
  final Color? backGroundColor;
  final double? paddingvertical;
  final double? paddingHorizontal;
  final double? height;
  final double? width;
  final double? borderRadius;
  final double? fontSize;
  final Color? textColor;
  const ButtonApp(
      {super.key,
      required this.title,
      this.backGroundColor,
      this.paddingHorizontal,
      this.paddingvertical,
      this.onPress,
      this.width,
      this.height,
      this.borderRadius,
      this.fontSize,
      this.textColor});

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
              color: backGroundColor ?? primaryColor,
              borderRadius: BorderRadius.circular(borderRadius ?? 20)),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontSize: fontSize ?? 12,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
