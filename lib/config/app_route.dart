import 'package:flutter/material.dart';
import '../model/models.dart';
import '../screen/screen.dart';

class AppRouter{
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MainScreen.route();
      case ChangePasswordScreen.routeName:
        return ChangePasswordScreen.route();
      case ChooseRecoveryMethodScreen.routeName:
        return ChooseRecoveryMethodScreen.route();
      case EnterEmailScreen.routeName:
        return EnterEmailScreen.route();
      case EnterNewPasswordScreen.routeName:
        return EnterNewPasswordScreen.route();
      case EnterOTPScreen.routeName:
        return EnterOTPScreen.route();
      case EditProfileScreen.routeName:
        return EditProfileScreen.route();
      case HomeScreen.routeName:
        return HomeScreen.route();
      case SplashScreen.routeName:
        return SplashScreen.route();
      case SearchScreen.routeName:
        return SearchScreen.route();
      case SettingsScreen.routeName:
        return SettingsScreen.route();
      case LibraryScreen.routeName:
        return LibraryScreen.route();
      case LoginScreen.routeName:
        return LoginScreen.route();
      case ProfileScreen.routeName:
        return ProfileScreen.route();
      case SignupScreen.routeName:
        return SignupScreen.route();
      case TextNotesScreen.routeName:
        return TextNotesScreen.route();
      case BookDetailScreen.routeName:
        if (settings.arguments is Map<String, dynamic>) {
          final Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
          final Book book = arguments['book'] as Book;
          final bool inLibrary = arguments['inLibrary'] as bool;
          return BookDetailScreen.route(book: book, inLibrary: inLibrary);
        } else {
          // Trả về một Route mặc định hoặc thông báo lỗi tùy thuộc vào yêu cầu của bạn.
          return MainScreen.route();
        }
      case CategoryScreen.routeName:
        if (settings.arguments is Category) {
          return CategoryScreen.route(category: settings.arguments as Category);
        } else {
          // Trả về một Route mặc định hoặc thông báo lỗi tùy thuộc vào yêu cầu của bạn.
          return MainScreen.route();
        }
      case BookScreen.routeName:
        if (settings.arguments is Map<String, dynamic>) {
          final Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
          final Book book = arguments['book'] as Book;
          final String uId = arguments['uId'] as String;
          final Map<String,dynamic> chapterScrollPositions = arguments['chapterScrollPositions'] ;
          return BookScreen.route(book: book, uId: uId, chapterScrollPositions: chapterScrollPositions);
        } else {
          // Trả về một Route mặc định hoặc thông báo lỗi tùy thuộc vào yêu cầu của bạn.
          return MainScreen.route();
        }
      case AdminPanel.routeName:
        return AdminPanel.route();
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