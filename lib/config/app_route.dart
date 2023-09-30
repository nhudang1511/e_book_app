import 'package:flutter/material.dart';
import '../screen/screen.dart';

class AppRouter{
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MainScreen.route();
      case '/home':
        return HomeScreen.route();
      case SplashScreen.routeName:
        return SplashScreen.route();
      case SearchScreen.routeName:
        return SearchScreen.route();
      case LibraryScreen.routeName:
        return LibraryScreen.route();
      case ProfileScreen.routeName:
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