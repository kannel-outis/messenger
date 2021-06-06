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
import 'package:messenger/services/offline/hive.db/models/hive_group_chat_saltiv.dart';
import 'package:messenger/services/offline/hive.db/models/keys.dart';
import 'package:messenger/services/offline/image_picker.dart';
import 'package:messenger/services/offline/shared_prefs/shared_prefs.dart';
import 'package:messenger/services/online/firebase/firebase_storage.dart';
import 'package:messenger/services/online/firebase/firestore_service.dart';
// import 'package:messenger/services/online/mqtt/mqtt_handler.dart';
import 'package:messenger/services/online/online.dart';
import 'package:messenger/utils/constants.dart';
// import 'package:messenger/utils/typedef.dart';
import 'package:uuid/uuid.dart';

class GroupProvider extends ChangeNotifier {
  final Online _firebaseStorage = MessengerFirebaseStorage();
  Online _cloudService = FireStoreService();
  // MQTThandler _mqttHandler = MQTThandler();
  EncryptClassHandler _encryptClassHandler = EncryptClassHandler();

  HiveHandler _hiveHandler = HiveHandler();
  String? _groupID;
  File? _internalImage;
  String? _imageUrl;
  bool _uploadingImageToStore = false;

  Future<void> pickeImageAndSaveToCloudStorage() async {
    _groupID = Uuid().v4();
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
    // TODO: generate salt and iv for
    final newGroupChat = new GroupChat(
      groupCreator: user.toMap(),
      groupName: groupName,
      participants: [
        user.toMap(),
        ...selected.map((e) => e.user.toMap()).toList()
      ],
      participantsIDs: [user.id!, ...selected.map((e) => e.user.id).toList()],
      groupAdmins: [user.toMap()],
      groupCreationTimeDate: DateTime.now(),
      groupDescription: "This is a New group created by ${user.userName}",
      groupID: _groupID ?? Uuid().v4(),
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
    await _cloudService.createNewGroupChat(newGroupChat).then((value) {
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

  User get user {
    return SharedPrefs.instance.getUserData();
  }

  // TODO:Change later

  File? get internalImage => _internalImage;
  String? get imageUrl => _imageUrl;
  bool get uploadingImageToStorage => _uploadingImageToStore;
}
