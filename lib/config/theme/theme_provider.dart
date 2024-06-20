import 'package:flutter/material.dart';
import 'package:e_book_app/config/theme/theme.dart';

import '../shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightTheme;

  ThemeData get themeData => _themeData;

  ThemeProvider(bool isDark){
    if(isDark){
      _themeData = darkTheme;
    }
    else{
      _themeData = lightTheme;
    }
  }

  void toggleTheme() async {
    if (_themeData == lightTheme) {
      _themeData = darkTheme;
      SharedService.setTheme(true);
    } else {
      _themeData = lightTheme;
      SharedService.setTheme(false);
    }
    notifyListeners();
  }
}