import 'package:bed/ui/themes/themes.dart';
import 'package:flutter/material.dart';

import 'colors_theme.dart';

class AppTheme {
  static ThemeData get theme => ThemeData(
        /// Colors base
        accentColor: ColorsTheme.primaryColor,
        highlightColor: ColorsTheme.secondaryColor,
        primaryColor: ColorsTheme.primaryColor,
        primaryColorDark: ColorsTheme.primaryColorDark,
        primaryColorLight: ColorsTheme.primaryColorLight,

        /// Color Cursor
        primarySwatch: ColorsTheme.primaryColor as MaterialColor,

        /// StatusBar
        brightness: Brightness.light,

        /// Default Theme InputDecorationTheme
        inputDecorationTheme: InputDecorationTheme(
          alignLabelWithHint: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorsTheme.primaryColorLight),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorsTheme.primaryColorLight),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorsTheme.red),
          ),
        ),
      );
}
