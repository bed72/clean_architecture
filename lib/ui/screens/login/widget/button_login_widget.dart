import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login_presenter.dart';
import '../../../themes/themes.dart';

class ButtonLoginWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);

    return StreamBuilder<bool>(
      stream: presenter.isFormValidErrorStream,
      builder: (context, snapshot) {
        return ElevatedButton(
          key: Key('buttonLogin'),
          onPressed: snapshot.data == true ? presenter.auth : null,
          style: ElevatedButton.styleFrom(
            primary: ColorsTheme.primaryColor,
            padding: EdgeInsets.symmetric(
              horizontal: 64,
              vertical: 16,
            ),
            textStyle: TypographyTheme.normalText(
              context,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          child: Text('LOGIN'),
        );
      },
    );
  }
}
