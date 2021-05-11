import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widget/widget.dart';
import 'login_presenter.dart';

import '../../themes/themes.dart';
import '../../widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  final LoginPresenter presenter;

  LoginScreen(this.presenter);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void dispose() {
    super.dispose();
    widget.presenter.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Builder(
          builder: (BuildContext context) {
            widget.presenter.isLoadingStream.listen(
              (isLoading) {
                if (isLoading) {
                  showLoading(context);
                } else {
                  hideLoading(context);
                }
              },
            );

            widget.presenter.mainErrorStream.listen(
              (error) {
                if (error.isNotEmpty) {
                  showGenericSnackbar(context, Colors.red[900]!, error);
                }
              },
            );

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    top: _displayHeight(context) / 4, left: 8, right: 8),
                child: Provider(
                  create: (_) => widget.presenter,
                  child: Form(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        EmailInputWidget(),
                        SizedBox(height: 16),
                        InputPasswordWidget(),
                        SizedBox(height: 32),
                        ButtonLoginWidget(),
                        SizedBox(height: 16),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            primary: ColorsTheme.primaryColor,
                            padding: EdgeInsets.symmetric(
                              horizontal: 34,
                              vertical: 12,
                            ),
                            textStyle: TypographyTheme.normalText(
                              context,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: Text('Create Account'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Size _displaySize(BuildContext context) {
  debugPrint('\n 🔧 Size = ${MediaQuery.of(context).size.toString()}\n');
  return MediaQuery.of(context).size;
}

double _displayHeight(BuildContext context) {
  debugPrint('\n 🔧 Height = ${_displaySize(context).height.toString()}\n');
  return _displaySize(context).height;
}

// ignore: unused_element
double _displayWidth(BuildContext context) {
  debugPrint('\n 🔧 Width = ${_displaySize(context).width.toString()}\n');
  return _displaySize(context).width;
}
