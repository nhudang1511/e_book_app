import 'package:shared_preferences/shared_preferences.dart';

class SharedService {
  static late SharedPreferences _pref;

  static init() async {
    _pref = await SharedPreferences.getInstance();
  }

  static String? getUserId() {
    return _pref.getString("userId");
  }

  static void setUserId(String userId) {
    _pref.setString("userId", userId);
  }
  static bool? getTheme() {
    return _pref.getBool("is_dark");
  }

  static void setTheme(bool isDark) {
    _pref.setBool("is_dark", isDark);
  }
  static void setFont(int fontSize){
    _pref.setInt('font', fontSize);
  }
  static int? getFont(){
    return _pref.getInt("font");
  }
  static void clear(){
    _pref.clear();
  }
}

