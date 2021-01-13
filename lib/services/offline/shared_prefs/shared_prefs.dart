import 'dart:convert';
import 'package:messenger/utils/constants.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/services/offline/offline.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs extends Offline {
  SharedPrefs._();
  static SharedPrefs _instance = SharedPrefs._();
  static SharedPrefs get instance {
    return _instance;
  }

  static SharedPreferences _prefs;

  static Future<SharedPreferences> getInstance() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
      if (!_prefs.containsKey(OfflineConstants.FIRST_TIME)) {
        await _prefs.setBool(OfflineConstants.FIRST_TIME, false);
      } else {
        print(_prefs.getString(OfflineConstants.MY_DATA));
      }
    }
    return _prefs;
  }

  @override
  String getString(String key) {
    return _prefs.getString(key);
  }

  @override
  bool getBool(String key) {
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

  @override
  Future<bool> setUserData(User user) async {
    final String value = json.encode(user.toMap());
    return _prefs.setString(OfflineConstants.MY_DATA, value);
  }

  @override
  User getUserData() {
    final rawUserString = _prefs.getString(OfflineConstants.MY_DATA);
    Map<String, dynamic> rawUserDecode = json.decode(rawUserString);
    return User.fromMap(rawUserDecode);
  }
}
