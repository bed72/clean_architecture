import 'package:flutter/material.dart';

import 'helpers/helpers.dart';

import '../screens/screens.dart';

class NavigationRoutes {
  static GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: 'Main Navigator');

  static Route onGenerateRoute(RouteSettings settings) {
    Widget _screen;
    debugPrint('\n 🔧 Route Screen = ${settings.name}\n');
    debugPrint('\n 🔧 Route Screen Parms = ${settings.arguments}\n');

    switch (settings.name) {
      case Paths.home:
        _screen = HomeScreen();
        break;
      /*case Paths.login:
        _screen = LoginScreen(settings.arguments);
        break;*/
      default:
        _screen = HomeScreen();
        break;
    }

    return FadeRoute(screen: _screen);
    /*return MaterialPageRoute(
      maintainState: true,
      fullscreenDialog: true,
      builder: (BuildContext context) => _screen,
    );*/
  }

  static NavigatorState? get state => navigatorKey.currentState;

  static void pop() => state!.pop();

  static Future push<T>(Routes route, [T? arguments]) =>
      state!.pushNamed(Paths.of(route)!, arguments: arguments);

  static Future replaceWith<T>(Routes route, [T? arguments]) =>
      state!.pushReplacementNamed(Paths.of(route)!, arguments: arguments);
}
