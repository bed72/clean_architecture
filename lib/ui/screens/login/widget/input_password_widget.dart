import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login_presenter.dart';
import '../../../themes/themes.dart';

class InputPasswordWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);

    return StreamBuilder<String>(
      stream: presenter.passwordErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
          onChanged: presenter.validatePassword,
          decoration: InputDecoration(
            errorText: snapshot.data,
            labelText: 'Password',
            icon: Icon(
              Icons.lock,
              color: ColorsTheme.primaryColorLight,
            ),
          ),
        );
      },
    );
  }
}
