import 'package:flutter/material.dart';
import '../screen/screen.dart';

class AppRouter{
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MainScreen.route();
      case '/home':
        return HomeScreen.route();
      case '/splash':
        return SplashScreen.route();
      case '/search':
        return SearchScreen.route();
      case '/library':
        return LibraryScreen.route();
      case '/profile':
        return ProfileScreen.route();
      default:
        return _errorRoute();
    }
  }
  static Route _errorRoute(){
    return MaterialPageRoute(
        settings: const RouteSettings(name: '/error'),
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Error'),),
        ));
  }
}