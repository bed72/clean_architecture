import 'package:flutter/material.dart';

import '../login/login.dart';

import '../../routes/routes.dart';
import '../../themes/themes.dart';
import '../../routes/helpers/helpers.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Home'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  NavigationRoutes.push(Routes.login, LogintMock);
                },
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LogintMock implements LoginPresenter {
  @override
  void validateEmail(String email) {}

  @override
  void validatePassword(String password) {}

  @override
  Future<void> auth() async {}

  @override
  void dispose() {}

  @override
  Stream<String> get emailErrorStream => throw UnimplementedError();

  @override
  Stream<String> get passwordErrorStream => throw UnimplementedError();

  @override
  Stream<String> get mainErrorStream => throw UnimplementedError();

  @override
  Stream<bool> get isLoadingStream => throw UnimplementedError();

  @override
  Stream<bool> get isFormValidErrorStream => throw UnimplementedError();
}
