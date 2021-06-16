import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:messenger/customs/error/error.dart';
import 'package:messenger/models/chat.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/services/encryption_class.dart';
import 'package:messenger/services/offline/hive.db/hive_handler.dart';
import 'package:messenger/services/offline/hive.db/models/hive_chat.dart';
import 'package:messenger/services/offline/hive.db/models/hive_messages.dart';
import 'package:messenger/services/offline/hive.db/models/keys.dart';
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
      // _hiveHandler
      //   ..updateUserInHive(user, 0)
      //   ..updateUserOnContactsListInHive(user, 0);
    }
  }

  Future<void> pickeImageAndSaveToCloudStorage(User? user) async {
    try {
      await MessengerImagePicker.pickeImage().then(
        (value) async {
          _firebaseStorage.saveImageToFireStore(user!.id, value).then(
            (value) {
              _imageUrl = value;
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

class ProfileInfoProvider extends ProfileProvider {
  HiveMessages? getLastMessage(
      {String? userId, required String chatId, bool? isGroup = false}) {
    return super
        ._hiveHandler
        .getLastMessage(userId: userId, chatId: chatId, isGroup: isGroup);
  }

  Future<void> leaveGroupChat(HiveGroupChat hiveGroupChat) async {
    // await _cloud.updateGroupChat(groupChat);
    final String generateSalt = hiveGroupChat.hiveGroupChatSaltIV!.salt!;
    final iv = hiveGroupChat.hiveGroupChatSaltIV!.iv;
    final Map<String, String> _mapSaltAndIv = {
      "salt": generateSalt,
      "iv": String.fromCharCodes(iv!),
    };
    final String stringifyMap = json.encode(_mapSaltAndIv);
    final groupChat = GroupChat(
      groupID: hiveGroupChat.groupID,
      groupName: hiveGroupChat.groupName,
      groupCreator: hiveGroupChat.groupCreator.toMap(),
      participantsIDs: hiveGroupChat.participants!.map((e) => e.id!).toList(),
      participants: hiveGroupChat.participants!.map((e) => e.toMap()).toList(),
      usersEncrytedKey: [
        ...hiveGroupChat.participants!
            .map((e) => _encryptKeyWithIndividualPublicKey(
                publicKey: e.publicKey, textToEncrypt: stringifyMap))
            .toList(),
      ],
      groupAdmins: _manageGroupAdmin(
              hiveGroupChat.groupAdmins!, hiveGroupChat.participants!)
          .map((e) => e.toMap())
          .toList(),
      groupCreationTimeDate: hiveGroupChat.groupCreationTimeDate,
      groupDescription: hiveGroupChat.groupDescription,
      groupPhotoUrl: hiveGroupChat.groupPhotoUrl,
    );
    await _cloud.saveGroupChat(groupChat);
    return;
  }

  List<User> _manageGroupAdmin(
      List<User> groupAdmins, List<User> groupParticipants) {
    final List<String> pIds = groupParticipants.map((e) => e.id!).toList();
    final List<String> aIds = groupAdmins.map((e) => e.id!).toList();
    late final List<String> newAdmins;
    for (var id in aIds) {
      if (!pIds.contains(id) && aIds.length == 1) {
        newAdmins = [pIds.first];
        // }else if(!pIds.contains(id) && aIds.length > 1){
        //   newAdmins = [pIds.first];
      } else {
        newAdmins = [...aIds];
      }
    }
    return groupParticipants
        .where((element) => newAdmins.contains(element.id))
        .toList();
  }

  String _encryptKeyWithIndividualPublicKey(
      {String? publicKey, String? textToEncrypt}) {
    EncryptClassHandler _encryptClassHandler = EncryptClassHandler();

    final key =
        _encryptClassHandler.keysFromString(isPrivate: false, key: publicKey);
    return String.fromCharCodes(_encryptClassHandler.rsaEncrypt(
        MyPublicKey(exponent: key.exponent, modulus: key.modulus),
        textToEncrypt!));
  }
}
