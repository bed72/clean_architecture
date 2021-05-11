import 'package:flutter/material.dart';

import './colors_theme.dart';

class TypographyTheme {
  static TextStyle normalText(
    BuildContext context, {
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.normal,
    Color color = ColorsTheme.primaryColor,
  }) {
    return Theme.of(context).textTheme.bodyText1!.copyWith(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
        );
  }

  static TextStyle inputText(
    BuildContext context, {
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.w200,
    Color color = ColorsTheme.primaryColor,
  }) {
    return Theme.of(context).textTheme.bodyText1!.copyWith(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
        );
  }
}
