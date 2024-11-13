import 'package:app/configs/font_style_text.dart';
import 'package:flutter/material.dart';

final ThemeData themeData = ThemeData(
    scaffoldBackgroundColor: Colors.grey[200],
    useMaterial3: true,
    appBarTheme: AppBarTheme(
        color: Colors.grey[200],
        titleTextStyle: textStyleTitleAppBar,
        centerTitle: true));
