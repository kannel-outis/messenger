import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:messenger/customs/error/error.dart';
import 'package:messenger/models/chat.dart';
import 'package:messenger/models/contacts_model.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/services/offline/hive.db/hive_handler.dart';
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
    );
    await _cloudService
        .createNewGroupChat(newGroupChat)
        .then((value) => _hiveHandler.saveChatToDB(newGroupChat));
    return;
  }

  User get user {
    return SharedPrefs.instance.getUserData();
  }

  // String get _id {
  //   _groupID = Uuid().v4();
  //   return _groupID!;
  // }
  File? get internalImage => _internalImage;
  String? get imageUrl => _imageUrl;
  bool get uploadingImageToStorage => _uploadingImageToStore;
}
