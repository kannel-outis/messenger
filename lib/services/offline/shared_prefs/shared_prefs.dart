import 'package:messenger/services/offline/offline.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs extends Offline {
  SharedPrefs._();
  static SharedPrefs _instance = SharedPrefs._();
  static SharedPrefs get instance {
    return _instance;
  }

  SharedPreferences _prefs;

  @override
  Future<String> getString(String key) async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getString(key);
  }

  @override
  Future<bool> getBool(String key) async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getBool(key);
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.setBool(key, value);
  }

  @override
  Future<bool> setString(String key, String value) async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.setString(key, value);
  }
}
