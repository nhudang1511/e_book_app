import 'package:flutter/material.dart';
import '../model/models.dart';
import '../screen/screen.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainScreen.routeName:
        return _route(const MainScreen());
      case ChangePasswordScreen.routeName:
        return _route(const ChangePasswordScreen());
      case EnterEmailScreen.routeName:
        return _route(const EnterEmailScreen());
      case EnterNewPasswordScreen.routeName:
        return _route(const EnterNewPasswordScreen());
      case EnterOTPScreen.routeName:
        return _route(const EnterOTPScreen());
      case EditProfileScreen.routeName:
        return _route(const EditProfileScreen());
      case HomeScreen.routeName:
        return _route(const HomeScreen());
      case SplashScreen.routeName:
        return _route(const SplashScreen());
      case SearchScreen.routeName:
        return _route(const SearchScreen());
      case SettingsScreen.routeName:
        return _route(const SettingsScreen());
      case LibraryScreen.routeName:
        return _route(const LibraryScreen());
      case LoginScreen.routeName:
        return _route(const LoginScreen());
      case ProfileScreen.routeName:
        return _route(const ProfileScreen());
      case SignupScreen.routeName:
        return _route(const SignupScreen());
      case TextNotesScreen.routeName:
        final User user = settings.arguments as User;
        return _route(TextNotesScreen(user: user));
      case BookDetailScreen.routeName:
        final Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
        final Book book = arguments['book'] as Book;
        final bool inLibrary = arguments['inLibrary'] as bool;
        return _route(BookDetailScreen(book: book, inLibrary: inLibrary));
      case CategoryScreen.routeName:
        final Category category = settings.arguments as Category;
        return _route(CategoryScreen(category: category));
      case BookScreen.routeName:
        final Map<String, dynamic> arguments =
        settings.arguments as Map<String, dynamic>;
        final Book book = arguments['book'] as Book;
        final String uId = arguments['uId'] as String;
        final Map<String, dynamic> chapterScrollPositions =
        arguments['chapterScrollPositions'];
        final Map<String, dynamic> chapterScrollPercentages =
        arguments['chapterScrollPercentages'];
        return _route(BookScreen(
            book: book,
            uId: uId,
            chapterScrollPositions: chapterScrollPositions,
            chapterScrollPercentages: chapterScrollPercentages));
      case AdminPanel.routeName:
        return _route(const AdminPanel());
      case ReviewsScreen.routeName:
        Book book = settings.arguments as Book;
        return _route(ReviewsScreen(book: book));
      case ChoosePaymentScreen.routeName:
        return _route(const ChoosePaymentScreen());
      case BankTransferScreen.routeName:
        return _route(const BankTransferScreen());
      case MissionScreen.routeName:
        return _route(const MissionScreen());
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: '/error'),
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text('Error'),
              ),
            ));
  }
  static Route _route(screen) {
    return MaterialPageRoute(builder: (context) => screen);
  }
}
