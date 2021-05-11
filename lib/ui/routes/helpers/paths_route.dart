import 'helpers.dart';

class Paths {
  static const String home = '/';
  static const String login = '/login';

  static const Map<Routes, String> _paths = {
    Routes.home: Paths.home,
    Routes.login: Paths.login,
  };

  static String? of(Routes route) => _paths[route];
}
