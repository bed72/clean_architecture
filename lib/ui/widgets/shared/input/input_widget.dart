import 'package:flutter/material.dart';

/// __TextField Text__
///
/// Parâmetros:
///
/// * __hintText__: Texto de Ajuda
/// * __labelText__: Texto do campo
/// * __typeIcon__: Icone que representara o Input
/// * __typeInput__: O tipo do determinado Input. Ex.: text, emailAddress
/// * __maxLength__: Quantidade maxíma de caracteres do Input
/// * __color__: Cor do texto interno do Input
/// * __obscure__: Se e campo de senha?
///
///
class InputTextFieldWidget extends StatelessWidget {
  final Color color;
  final Icon typeIcon;
  final int maxLength;
  final bool obscure;
  final String hintText;
  final String labelText;
  final TextStyle hintStyle;
  final TextStyle textStyle;
  final TextStyle errorStyle;
  final TextStyle labelStyle;
  final TextInputType typeInput;
  final String Function() error;

  InputTextFieldWidget({
    required this.error,
    required this.color,
    required this.obscure,
    required this.typeIcon,
    required this.hintText,
    required this.labelText,
    required this.typeInput,
    required this.maxLength,
    required this.hintStyle,
    required this.textStyle,
    required this.labelStyle,
    required this.errorStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: 1,
      autofocus: false,
      maxLength: maxLength,
      obscureText: obscure,
      style: textStyle,
      keyboardType: typeInput,
      decoration: InputDecoration(
        prefixIcon: typeIcon,
        hintText: '$hintText',
        labelText: '$labelText',
        hintStyle: hintStyle,
        labelStyle: labelStyle,
        errorStyle: errorStyle,
        errorText: error().isEmpty ? null : error(),
      ),
    );
  }
}
