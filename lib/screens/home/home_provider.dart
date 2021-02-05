import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:messenger/models/chat.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/services/offline/shared_prefs/shared_prefs.dart';
import 'package:messenger/services/online/firebase/firestore_service.dart';
import 'package:messenger/services/online/mqtt/mqtt_handler.dart';
import 'package:messenger/services/online/online.dart';
import 'package:messenger/utils/constants.dart';

class HomeProvider extends ChangeNotifier {
  Online _storeService = FireStoreService();
  MQTThandler _mqttHandler = MQTThandler();
  bool isme(String userID) {
    final User prefUser = User.fromMap(
        json.decode(SharedPrefs.instance.getString(OfflineConstants.MY_DATA)));
    return prefUser.id == userID;
  }

  void listenTocloudStreamAndSubscribeTopic(String identifier, User user) {
    // Should be need to ;isten on the database......... this is wrong implementation

    _storeService.listenWhenAUserInitializesAChat(user).listen((event) {
      event.docChanges.forEach((element) {
        print(element.doc.data());
      });
      if (event.docChanges.isNotEmpty) {
        event.docChanges.forEach((element) {
          Chat chat = Chat.froMap(element.doc.data());
          _mqttHandler
              .subscribe(chat.chatID)
              .then((value) => print('SubScribed'));
        });
      } else {
        print('Empty');
      }
    });
  }
}
