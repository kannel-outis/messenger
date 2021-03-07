import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:messenger/models/chat.dart';
import 'package:messenger/models/message.dart';
import 'package:messenger/models/user.dart';
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
  List<Map<String, dynamic>> _list = [];
  bool isme(String userID) {
    final User prefUser = User.fromMap(
        json.decode(SharedPrefs.instance.getString(OfflineConstants.MY_DATA)));
    return prefUser.id == userID;
  }

  void listenTocloudStreamAndSubscribeTopic() {
    _storeService
        .listenWhenAUserInitializesAChat(_mqttHandler.user)
        .listen((event) {
      if (event.docChanges.isNotEmpty) {
        event.docChanges.forEach((element) {
          Chat chat = Chat.froMap(element.doc.data());
          HiveChat hiveChat = HiveChat(
            chatId: chat.chatID,
            participants:
                chat.participants.map((e) => User.fromMap(e)).toList(),
          );
          bool exists = _hiveHandler.checkIfchatExists(hiveChat);

          if (exists == false) {
            _hiveHandler.saveChatToDB(chat);
          } else {
            for (var user in hiveChat.participants) {
              _hiveHandler
                ..updateUserInHive(user, 1)
                ..updateUserOnContactsListInHive(user, 1);
            }
          }
          _mqttHandler
              .subscribe(chat.chatID)
              .then((value) => print('SubScribed'));
        });
      } else {
        print('Empty');
      }
    });
    _mqttHandler.messageController.listen((event) {
      _list.add(event);
      print(_list.length);
      try {
        _hiveHandler.saveMessages(Message.fromMap(_list.last));
      } catch (e) {
        print(e.toString());
      }
    });
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
