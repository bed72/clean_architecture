import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login_presenter.dart';
import '../../../themes/themes.dart';

class EmailInputWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);

    return StreamBuilder<String>(
      stream: presenter.emailErrorStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return TextFormField(
          key: Key('inputTextEmailTest'),
          keyboardType: TextInputType.emailAddress,
          onChanged: presenter.validateEmail,
          decoration: InputDecoration(
            errorText: snapshot.data,
            labelText: 'Email',
            icon: Icon(
              Icons.email,
              color: ColorsTheme.primaryColorLight,
            ),
          ),
        );
      },
    );
  }
}
