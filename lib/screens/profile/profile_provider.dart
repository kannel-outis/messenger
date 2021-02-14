import 'package:flutter/cupertino.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/services/offline/hive.db/hive_handler.dart';
import 'package:messenger/services/offline/offline.dart';
import 'package:messenger/services/offline/shared_prefs/shared_prefs.dart';
import 'package:messenger/services/online/firebase/firestore_service.dart';
import 'package:messenger/services/online/online.dart';

class ProfileProvider extends ChangeNotifier {
  Online _cloud = FireStoreService();
  Offline _sharedPrefs = SharedPrefs.instance;
  HiveHandler _hiveHandler = HiveHandler();
  bool _isDone = false;

  Future<void> updateAllDataInCloud(
      {String username, String status, String photoUrl}) async {
    final User user = User(
      id: userPrefData.id,
      phoneNumbers: userPrefData.phoneNumbers,
      status: status ?? userPrefData.status,
      userName: username ?? userPrefData.userName,
      photoUrl: photoUrl ?? userPrefData.photoUrl,
    );
    _isDone = await _cloud.updateUserInCloud(user: user);
    notifyListeners();
    if (!_isDone) {
      _sharedPrefs.setUserData(user);
      _hiveHandler
        ..updateUserInHive(user, 0)
        ..updateUserOnContactsListInHive(user, 0);
    }
  }

  User get userPrefData => _sharedPrefs.getUserData();
  bool get isDone => _isDone;
}
