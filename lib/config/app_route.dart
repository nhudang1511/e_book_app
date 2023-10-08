import 'package:flutter/material.dart';
import '../model/models.dart';
import '../screen/screen.dart';

class AppRouter{
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MainScreen.route();
      case HomeScreen.routeName:
        return HomeScreen.route();
      case SplashScreen.routeName:
        return SplashScreen.route();
      case SearchScreen.routeName:
        return SearchScreen.route();
      case LibraryScreen.routeName:
        return LibraryScreen.route();
      case ProfileScreen.routeName:
        return ProfileScreen.route();
      case BookDetailScreen.routeName:
        if (settings.arguments is Book) {
          return BookDetailScreen.route(book: settings.arguments as Book);
        } else {
          // Trả về một Route mặc định hoặc thông báo lỗi tùy thuộc vào yêu cầu của bạn.
          return HomeScreen.route();
        }
      case CategoryScreen.routeName:
        if (settings.arguments is Category) {
          return CategoryScreen.route(category: settings.arguments as Category);
        } else {
          // Trả về một Route mặc định hoặc thông báo lỗi tùy thuộc vào yêu cầu của bạn.
          return HomeScreen.route();}
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