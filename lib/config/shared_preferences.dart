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
  static void clear(){
    _pref.clear();
  }
}

