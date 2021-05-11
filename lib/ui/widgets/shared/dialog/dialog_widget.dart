import 'package:flutter/material.dart';

void showLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return SimpleDialog(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator.adaptive(),
              SizedBox(
                height: 16,
              ),
              Text(
                'Carregando...',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      );
    },
  );
}

/// [hideLoading] Escondendo Modal
void hideLoading(BuildContext context) {
  if (Navigator.canPop(context)) Navigator.of(context).pop();
}
