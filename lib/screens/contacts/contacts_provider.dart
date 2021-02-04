import 'dart:convert';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:messenger/customs/error/error.dart';
import 'package:messenger/models/contacts_model.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/services/offline/contacts/contacts.dart';
import 'package:messenger/services/offline/hive.db/hive_handler.dart';
import 'package:messenger/services/offline/shared_prefs/shared_prefs.dart';
import 'package:messenger/services/online/cloud_firestore/firestore_service.dart';
import 'package:messenger/services/online/online.dart';
import 'package:messenger/utils/constants.dart';
import 'package:uuid/uuid.dart';
import '../../models/chat.dart';

class ContactProvider extends ChangeNotifier {
  final Online _fireStoreService = FireStoreService();
  final SharedPrefs sharedPrefs = SharedPrefs.instance;
  final _hiveHandler = HiveHandler();
  List<List<PhoneContacts>> _listOfContact = [];
  Future<List<List<PhoneContacts>>> registeredAndUnregisteredContacts() async {
    var _contacts = Contacts(_fireStoreService);
    try {
      await _contacts.listOfRegisteredAndUnregisteredUsers().then((value) {
        _listOfContact = value;
        notifyListeners();
      });
    } catch (e) {
      throw MessengerError(e.message);
    }
    return _listOfContact;
  }

  Future<void> messageUser(User myUser, User friendUser,
      {VoidCallback navigate}) async {
    Chat _chat = Chat(
      chatID: _chatID(),
      participants: [
        myUser.toMap(),
        friendUser.toMap(),
      ],
    );
    print(_chat.participants);
    if (await _checkIfChatExistAlready(participants: _chat.participants)) {
      print('Love Done');
      await _fireStoreService.createNewChat(_chat).then((value) {
        _hiveHandler.saveChatToDB(_chat).then((value) {
          print('saved');
          navigate();
        });
      });
    } else {
      navigate();
      print('Nothing done');
    }
  }

  Future<bool> _checkIfChatExistAlready(
      {List<Map<String, dynamic>> participants}) async {
    print('Love and try');
    bool exists;
    await _fireStoreService
        .queryInfo(participants, 'participants',
            path: OnlineConstants.FIRESTORE_ONGOING_CHATS)
        .then((value) {
      print('Love');

      bool _contains = value.docChanges.isNotEmpty;
      print(_contains
          ? value.docChanges[0].doc?.data()['participants'][0]['phoneNumbers']
              [0]
          : "null + ppp");
      print(participants[0]['phoneNumbers'][0]);
      if (_contains &&
          value.docChanges[0].doc?.data()['participants'][0]['phoneNumbers']
                  [0] ==
              participants[0]['phoneNumbers'][0]) {
        exists = false;
      } else {
        exists = true;
      }
      print('Love');
    });
    return exists;
  }

  User getUserPref() {
    final User _user = User.fromMap(
        json.decode(sharedPrefs.getString(OfflineConstants.MY_DATA)));
    return _user;
  }

  String _chatID() {
    String _chatID = Uuid().v4();
    print(_chatID);
    return _chatID;
  }

  List<List<PhoneContacts>> get listOfContact => _listOfContact;
}
