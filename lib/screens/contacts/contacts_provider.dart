import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:messenger/customs/error/error.dart';
import 'package:messenger/models/contacts_model.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/services/offline/contacts/contacts.dart';
import 'package:messenger/services/offline/hive.db/hive_handler.dart';
import 'package:messenger/services/offline/shared_prefs/shared_prefs.dart';
import 'package:messenger/services/online/firebase/firestore_service.dart';
import 'package:messenger/services/online/online.dart';
import 'package:messenger/utils/constants.dart';
import 'package:uuid/uuid.dart';
import '../../models/chat.dart';

class ContactProvider extends ChangeNotifier {
  final Online _fireStoreService = FireStoreService();
  final SharedPrefs sharedPrefs = SharedPrefs.instance;
  final _hiveHandler = HiveHandler();
  List<List<PhoneContacts>>? _listOfContact;
  Future<List<List<PhoneContacts>>> registeredAndUnregisteredContacts() async {
    Timeline.startSync("name");
    var _contacts = Contacts(_fireStoreService);
    if (_listOfContact != null) return _listOfContact!;
    try {
      if (_hiveHandler.checkIfChatBoxExistAlready != true) {
        await _contacts.listOfRegisteredAndUnregisteredUsers().then((value) {
          _listOfContact = value;
          notifyListeners();
          _hiveHandler.saveContactsListToDB(_listOfContact!);
        });
      } else {
        _listOfContact = _getPhoneContactsFromHiveDB();
        notifyListeners();
      }
    } catch (e, s) {
      print(s.toString());
      throw MessengerError(e.toString());
    }
    Timeline.finishSync();
    return _listOfContact!;
  }

  Future<void> messageUser(User myUser, User friendUser,
      {VoidCallback? navigate}) async {
    print(myUser.phoneNumbers![0]);
    print(friendUser.phoneNumbers![0]);
    Chat _chat = Chat(
      chatID: _chatID(),
      participantsIDs: [myUser.id, friendUser.id],
      participants: [
        myUser.toMap(),
        friendUser.toMap(),
      ],
    );
    if (await _checkIfChatExistAlready(participants: _chat.participantsIDs)) {
      await _fireStoreService.createNewChat(_chat).then((value) {
        _hiveHandler.saveChatToDB(_chat).then((value) {
          navigate!();
        });
      });
    } else {
      navigate!();
    }
  }

  Future<bool> _checkIfChatExistAlready({List<String?>? participants}) async {
    bool exists = true;
    await _fireStoreService.queryInfo(participants![0]).then((value) {
      bool _contains = value.docChanges.isNotEmpty;
      if (_contains)
        value.docChanges.forEach((d) {
          if (_contains &&
                  d.doc.data()!['participantsIDs'][0] == participants[1] ||
              _contains &&
                  d.doc.data()!['participantsIDs'][1] == participants[1]) {
            exists = false;
            print("Already Exist");
            print(d.doc.data()!['chatID']);
          }
        });
    });
    return exists;
  }

  User getUserPref() {
    final User _user = User.fromMap(
        json.decode(sharedPrefs.getString(OfflineConstants.MY_DATA)!));
    return _user;
  }

  List<List<PhoneContacts>> _getPhoneContactsFromHiveDB() {
    List<RegisteredPhoneContacts> registered = [];
    List<UnRegisteredPhoneContacts> unRegistered = [];
    final _contactListFromHiveDB = _hiveHandler.getContactsListFromDB();
    if (_contactListFromHiveDB.length > 0) {
      // TODO: change forEach to for in for both ops
      _contactListFromHiveDB[0].forEach(
        (element) {
          registered.add(
            RegisteredPhoneContacts.fromMap(element),
          );
        },
      );
      _contactListFromHiveDB[1].forEach(
        (element) {
          unRegistered.add(
            UnRegisteredPhoneContacts.fromMap(element),
          );
        },
      );
    } else {
      print("List is Empty");
    }
    return [registered, unRegistered];
  }

  String _chatID() {
    String _chatID = Uuid().v4();
    return _chatID;
  }

  List<List<PhoneContacts>> get listOfContact => _listOfContact!;
}
