import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:messenger/customs/error/error.dart';
import 'package:messenger/models/chat.dart';
import 'package:messenger/models/contacts_model.dart';
// import 'package:messenger/models/message.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/services/encryption_class.dart';
import 'package:messenger/services/offline/hive.db/hive_handler.dart';
import 'package:messenger/services/offline/hive.db/models/hive_chat.dart';
import 'package:messenger/services/offline/hive.db/models/hive_group_chat_saltiv.dart';
import 'package:messenger/services/offline/hive.db/models/keys.dart';
import 'package:messenger/services/offline/image_picker.dart';
import 'package:messenger/services/offline/shared_prefs/shared_prefs.dart';
import 'package:messenger/services/online/firebase/firebase_storage.dart';
import 'package:messenger/services/online/firebase/firestore_service.dart';
import 'package:messenger/services/online/online.dart';
import 'package:messenger/utils/constants.dart';
import 'package:uuid/uuid.dart';

class GroupProvider extends ChangeNotifier {
  final Online _firebaseStorage = MessengerFirebaseStorage();
  Online _cloudService = FireStoreService();
  EncryptClassHandler _encryptClassHandler = EncryptClassHandler();

  HiveHandler _hiveHandler = HiveHandler();
  String? _groupID;
  File? _internalImage;
  String? _imageUrl;
  bool _uploadingImageToStore = false;

  Future<void> pickeImageAndSaveToCloudStorage([String? id]) async {
    _groupID = id ?? Uuid().v4();
    try {
      await MessengerImagePicker.pickeImage().then(
        (value) async {
          _uploadingImageToStore = true;
          _internalImage = value;
          notifyListeners();
          _firebaseStorage.saveImageToFireStore(_groupID, value).then(
            (url) {
              _imageUrl = url;
              _uploadingImageToStore = false;
              notifyListeners();
            },
          );
        },
      );
    } on MessengerError catch (e) {
      _imageUrl = null;
      print(e.message);
    }
  }

  Future<void> createGroupChat(
      {required String groupName,
      required List<RegisteredPhoneContacts> selected,
      VoidCallback? onCreatedSuccessful}) async {
    final String generateSalt =
        latin1.decode(_encryptClassHandler.generateRandomBytes(100)!);
    final iv = _encryptClassHandler.generateRandomBytes(128 ~/ 8);
    final Map<String, String> _mapSaltAndIv = {
      "salt": generateSalt,
      "iv": String.fromCharCodes(iv!),
    };
    final String stringifyMap = json.encode(_mapSaltAndIv);
    final newGroupChat = new GroupChat(
      groupCreator: user.map,
      groupName: groupName,
      participants: [user.map, ...selected.map((e) => e.user.map).toList()],
      participantsIDs: [user.id!, ...selected.map((e) => e.user.id).toList()],
      groupAdmins: [user.map],
      groupCreationTimeDate: DateTime.now(),
      groupDescription: "This is a New group created by ${user.userName}",
      // groupID: _groupID ?? Uuid().v4(),
      groupID: Uuid().v4(),
      groupPhotoUrl: _imageUrl ?? GeneralConstants.DEFAULT_PHOTOURL,
      usersEncrytedKey: [
        _encryptKeyWithIndividualPublicKey(
            publicKey: user.publicKey, textToEncrypt: stringifyMap),
        ...selected
            .map((e) => _encryptKeyWithIndividualPublicKey(
                publicKey: e.user.publicKey, textToEncrypt: stringifyMap))
            .toList(),
      ],
    );
    await _cloudService.saveGroupChat(newGroupChat).then((value) {
      Map<String, dynamic> decoded = json.decode(stringifyMap);
      Map<String, String> stringToString =
          decoded.map((key, value) => MapEntry(key, value as String));
      return _hiveHandler.saveChatToDB(
        newGroupChat,
        hiveGroupChatSaltIV: HiveGroupChatSaltIV.fromMap(stringToString),
      );
    });
    return;
  }

  String _encryptKeyWithIndividualPublicKey(
      {String? publicKey, String? textToEncrypt}) {
    final key =
        _encryptClassHandler.keysFromString(isPrivate: false, key: publicKey);
    return String.fromCharCodes(_encryptClassHandler.rsaEncrypt(
        MyPublicKey(exponent: key.exponent, modulus: key.modulus),
        textToEncrypt!));
  }

  Future<HiveGroupChat> updateGroupInfo(
      {required List<User> selected,
      required HiveGroupChat oldGroupChat,
      required String groupName,
      VoidCallback? onCreatedSuccessful}) async {
    late final _hiveGroupChat;

    final String generateSalt = oldGroupChat.hiveGroupChatSaltIV!.salt!;
    final iv = oldGroupChat.hiveGroupChatSaltIV!.iv;
    final Map<String, String> _mapSaltAndIv = {
      "salt": generateSalt,
      "iv": String.fromCharCodes(iv!),
    };
    final String stringifyMap = json.encode(_mapSaltAndIv);
    final newGroupChat = new GroupChat(
      groupCreator: oldGroupChat.groupCreator.map,
      groupName: groupName,
      participants: [...selected.map((e) => e.map).toList()],
      participantsIDs: [...selected.map((e) => e.id).toList()],
      groupAdmins: oldGroupChat.groupAdmins!.map((e) => e.map).toList(),
      groupCreationTimeDate: oldGroupChat.groupCreationTimeDate,
      groupDescription: "This is a New group created by ${user.userName}",
      groupID: oldGroupChat.groupID,
      groupPhotoUrl: _imageUrl ?? oldGroupChat.groupPhotoUrl,
      usersEncrytedKey: [
        ...selected
            .map((e) => _encryptKeyWithIndividualPublicKey(
                publicKey: e.publicKey, textToEncrypt: stringifyMap))
            .toList(),
      ],
    );
    await _cloudService.saveGroupChat(newGroupChat).then((value) {
      Map<String, dynamic> decoded = json.decode(stringifyMap);
      Map<String, String> stringToString =
          decoded.map((key, value) => MapEntry(key, value as String));

      HiveGroupChat hiveGroupChat = HiveGroupChat(
        groupID: newGroupChat.groupID,
        participants:
            newGroupChat.participants.map((e) => User.fromMap(e!)).toList(),
        groupCreator: User.fromMap(newGroupChat.groupCreator),
        groupName: newGroupChat.groupName,
        groupAdmins:
            newGroupChat.groupAdmins!.map((e) => User.fromMap(e)).toList(),
        groupCreationTimeDate: newGroupChat.groupCreationTimeDate,
        groupDescription: newGroupChat.groupDescription,
        groupPhotoUrl: newGroupChat.groupPhotoUrl,
        hiveGroupChatSaltIV: HiveGroupChatSaltIV.fromMap(stringToString),
      );
      _hiveGroupChat = hiveGroupChat;
      return _hiveHandler.updateAllGroupInfo(hiveGroupChat);
    });
    onCreatedSuccessful!();
    return _hiveGroupChat;
  }

  User get user {
    return SharedPrefs.instance.user;
  }

  File? get internalImage => _internalImage;
  String? get imageUrl => _imageUrl;
  bool get uploadingImageToStorage => _uploadingImageToStore;
}
