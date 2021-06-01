import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:messenger/customs/error/error.dart';
import 'package:messenger/models/chat.dart';
import 'package:messenger/models/message.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/services/encryption_class.dart';
import 'package:messenger/services/offline/hive.db/hive_handler.dart';
import 'package:messenger/services/offline/hive.db/models/hive_chat.dart';
import 'package:messenger/services/offline/shared_prefs/shared_prefs.dart';
import 'package:messenger/services/online/firebase/firestore_service.dart';
import 'package:messenger/services/online/mqtt/mqtt_handler.dart';
import 'package:messenger/services/online/online.dart';
import 'package:messenger/utils/constants.dart';

class HomeProvider extends ChangeNotifier {
  Online _storeService = FireStoreService();
  MQTThandler _mqttHandler = MQTThandler();
  HiveHandler _hiveHandler = HiveHandler();
  EncryptClassHandler _encryptClassHandler = EncryptClassHandler();
  List<Map<String, dynamic>?> _list = [];
  bool isme(List<String>? iDs) {
    final User prefUser = User.fromMap(
        json.decode(SharedPrefs.instance.getString(OfflineConstants.MY_DATA)!));
    return iDs!.contains(prefUser.id);
  }

  void listenTocloudStreamAndSubscribeTopic() {
    _storeService
        .listenWhenAUserInitializesAChat(_mqttHandler.user)
        .listen((event) {
      if (event.docs.isNotEmpty) {
        for (var element in event.docs) {
          Chat chat = Chat.froMap(element.data()!);
          HiveChat hiveChat = HiveChat(
            chatId: chat.chatID,
            participants:
                chat.participants.map((e) => User.fromMap(e!)).toList(),
          );
          bool exists = _hiveHandler.checkIfchatExists(hiveChat);

          if (exists == false) {
            _hiveHandler.saveChatToDB(chat);
          } else {
            for (var i = 0; i < hiveChat.participants!.length; i++) {
              _hiveHandler
                ..updateUserInHive(hiveChat.participants![i])
                ..updateUserOnContactsListInHive(hiveChat.participants![i], i);
            }
          }
          _mqttHandler
              .subscribe(chat.chatID)
              .then((value) => print('SubScribed'));
        }
      } else {
        print('Empty');
      }
    });
    // for Groups::: experimental
    _storeService
        .listenWhenAUserInitializesAChat(_mqttHandler.user, isGroup: true)
        .listen((event) {
      // print("foundOneChat");

      if (event.docs.isNotEmpty) {
        for (var element in event.docs) {
          GroupChat chat = GroupChat.froMap(element.data()!);
          HiveGroupChat hiveChat = HiveGroupChat(
            groupID: chat.groupID,
            participants:
                chat.participants.map((e) => User.fromMap(e!)).toList(),
            groupCreator: User.fromMap(chat.groupCreator),
            groupName: chat.groupName,
            groupAdmins: chat.groupAdmins!.map((e) => User.fromMap(e)).toList(),
            groupCreationTimeDate: chat.groupCreationTimeDate,
            groupDescription: chat.groupDescription,
            groupPhotoUrl: chat.groupPhotoUrl,
          );
          bool exists = _hiveHandler.checkIfchatExists(hiveChat);

          if (exists == false) {
            _hiveHandler.saveChatToDB(chat);
          } else {
            // TODO:update group Info in local db
            _hiveHandler..updateAllGroupInfo(hiveChat);
          }
          _mqttHandler
              .subscribe(chat.groupID)
              .then((value) => print('SubScribed group'));
        }
      } else {
        print('Group Empty');
      }
    });
    _mqttHandler.messageController.listen((event) {
      _list.add(event);
      print(_list.length);
      print(_list.last!["senderID"]);
      try {
        if (!isme([_list.last!["senderID"]])) {
          // print(String.fromCharCodes(_encryptClassHandler.rsaDecrypt(
          //     _hiveHandler.myPrivateKeyFromDB, event!['message'])));
          _hiveHandler.saveMessages(
            Message.fromMap(_list.last!).copyWith(
              message: String.fromCharCodes(
                _encryptClassHandler.rsaDecrypt(
                  _hiveHandler.myPrivateKeyFromDB,
                  event!['message'],
                ),
              ),
            ),
          );
        }
      } on MessengerError catch (e) {
        print(e.message);
      }
    });
  }

  // Future<void> updateConnectionStatus(String userId) async {

  // }

  Future<void> deleteChatAndRemovePrintsFromDB(HiveChat hiveChat) async {
    await _hiveHandler.deleteChatAndMessagesFromLocalStorage(hiveChat);
  }

  void iniState() {
    _mqttHandler.login().then((value) {
      listenTocloudStreamAndSubscribeTopic();
    });
  }

  User get user {
    return SharedPrefs.instance.getUserData();
  }
}
