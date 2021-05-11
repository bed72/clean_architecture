import 'package:flutter/material.dart';

void showGenericSnackbar(BuildContext context, Color? color, String error) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color,
      content: Text(
        error,
        textAlign: TextAlign.center,
      ),
    ),
  );
}
