import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPrefsController extends GetxController {
  SharedPreferences? _prefs;
  static const tokenKey = 'token';

  AuthPrefsController(SharedPreferences prefsObj) {
    initObj(prefsObj);
  }

  void initObj(SharedPreferences prefsObj) {
    if (_prefs != null) {
      return;
    }
    _prefs = prefsObj;
  }

  Future<bool> setToken(String token) async {
    return await _prefs!.setString(tokenKey, token);
  }

  String? getToken(String token) {
    return _prefs!.getString(tokenKey);
  }

  Future<bool> removeToken() async {
    return await _prefs!.remove(tokenKey);
  }
}
