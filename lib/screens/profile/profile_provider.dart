import 'package:flutter/cupertino.dart';
import 'package:messenger/customs/error/error.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/services/offline/hive.db/hive_handler.dart';
import 'package:messenger/services/offline/image_picker.dart';
import 'package:messenger/services/offline/offline.dart';
import 'package:messenger/services/offline/shared_prefs/shared_prefs.dart';
import 'package:messenger/services/online/firebase/firebase_storage.dart';
import 'package:messenger/services/online/firebase/firestore_service.dart';
import 'package:messenger/services/online/online.dart';

class ProfileProvider extends ChangeNotifier {
  Online _cloud = FireStoreService();
  Online _firebaseStorage = MessengerFirebaseStorage();

  Offline _sharedPrefs = SharedPrefs.instance;
  HiveHandler _hiveHandler = HiveHandler();
  bool _isDone = false;
  String? _imageUrl;

  Future<void> updateAllDataInCloud({String? username, String? status}) async {
    final User user = User(
      id: userPrefData.id,
      phoneNumbers: userPrefData.phoneNumbers,
      status: status ?? userPrefData.status,
      userName: username ?? userPrefData.userName,
      photoUrl: _imageUrl ?? userPrefData.photoUrl,
      publicKey: userPrefData.publicKey,
    );
    _isDone = await _cloud.updateUserInCloud(user: user);
    notifyListeners();
    if (!_isDone) {
      _sharedPrefs.setUserData(user);
      _hiveHandler
        ..updateUserInHive(user)
        ..updateUserOnContactsListInHive(user, 0);
    }
  }

  Future<void> pickeImageAndSaveToCloudStorage(User? user) async {
    try {
      await MessengerImagePicker.pickeImage().then(
        (value) async {
          _firebaseStorage.saveImageToFireStore(user!.id, value).then(
            (value) {
              _imageUrl = value;
              print(_imageUrl);
              notifyListeners();
            },
          );
        },
      );
    } on MessengerError catch (e) {
      print(e.message);
    }
  }

  User get userPrefData => _sharedPrefs.getUserData();
  bool get isDone => _isDone;
  String? get imageUrl => _imageUrl;
}
