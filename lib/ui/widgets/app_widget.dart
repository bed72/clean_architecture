import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import '../routes/routes.dart';
import '../helpers/helpers.dart';

import '../../ui/themes/themes.dart';
import '../../ui/screens/screens.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        /// StatusBar
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,

        /// NavigatioBar
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return MaterialApp(
      title: 'Bed',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      //navigatorKey: NavigationRoutes.navigatorKey,
      //onGenerateRoute: NavigationRoutes.onGenerateRoute,
      home: LoginScreen(LogintMock()),
      builder: (BuildContext context, Widget? child) {
        final _data = MediaQuery.of(context);
        final _smallSize = min(_data.size.width, _data.size.height);
        final _textScaleFactor =
            min(_smallSize / Constants.designScreenSize.width, 1.0);

        return MediaQuery(
          data: _data.copyWith(textScaleFactor: _textScaleFactor),
          child: child!,
        );
      },
    );
  }
}
/*
class LogintMock implements LoginPresenter {
  @override
  void validateEmail(String email) {}

  @override
  void validatePassword(String password) {}

  @override
  Stream get emailErrorStrem => throw UnimplementedError();

  @override
  Stream get passwordErrorStrem => throw UnimplementedError();

  @override
  Stream get isFormValidErrorStrem => throw UnimplementedError();
}
*/