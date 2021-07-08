import 'dart:convert';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:messenger/app/isolate__.dart';
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

class ContactProvider extends ChangeNotifier with ContactsIsolate_CC {
  final Online _fireStoreService = FireStoreService();
  final SharedPrefs sharedPrefs = SharedPrefs.instance;
  bool refreshing = false;
  final _hiveHandler = HiveHandler();
  PhoneContacts<RegisteredPhoneContacts, UnRegisteredPhoneContacts?>?
      _phoneContacts;
  Future<PhoneContacts<RegisteredPhoneContacts, UnRegisteredPhoneContacts?>>
      registeredAndUnregisteredContacts() async {
    var _contacts = Contacts(_fireStoreService);
    if (_phoneContacts != null) return _phoneContacts!;
    try {
      // if (_hiveHandler.checkIfChatBoxExistAlready != true) {
      await _contacts.listOfRegisteredAndUnregisteredUsers().then((value) {
        _phoneContacts = value;
        notifyListeners();
        _hiveHandler.saveContactsListToDB(
          PhoneContacts<RegisteredPhoneContacts, UnRegisteredPhoneContacts>(
            firstList: _phoneContacts!.firstList,
            lastList: _phoneContacts!.lastList!.map((e) => e!).toList(),
          ),
        );
      });
      // } else {
      // _listOfContact = _getPhoneContactsFromHiveDB();
      // notifyListeners();
      // }
    } catch (e, s) {
      print(s.toString());
      throw MessengerError(e.toString());
    }
    return _phoneContacts!;
  }

  Future<void> messageUser(User myUser, User friendUser,
      {VoidCallback? navigate}) async {
    print(myUser.phoneNumbers![0]);
    print(friendUser.phoneNumbers![0]);
    Chat _chat = Chat(
      chatID: _chatID(),
      participantsIDs: [myUser.id, friendUser.id],
      participants: [
        myUser.map,
        friendUser.map,
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

  // Future<PhoneContacts<RegisteredPhoneContacts, UnRegisteredPhoneContacts>>
  //     decodeAndCreateContactsListFromJson(
  //         PhoneContacts<Map<String, dynamic>, Map<String, dynamic>>
  //             list) async {
  //   List<RegisteredPhoneContacts> registered = [];
  //   List<UnRegisteredPhoneContacts> unRegistered = [];
  //   return await Future<
  //       PhoneContacts<RegisteredPhoneContacts,
  //           UnRegisteredPhoneContacts>>.microtask(() {
  //     for (var e in list.firstList!) {
  //       final r = RegisteredPhoneContacts.fromMap(e);
  //       registered.add(r);
  //     }
  //     for (var e in list.lastList!) {
  //       final r = UnRegisteredPhoneContacts.fromMap(e);
  //       unRegistered.add(r);
  //     }

  //     // return _listOfContact = [registered, unRegistered];
  //     return _phoneContacts =
  //         PhoneContacts(firstList: registered, lastList: unRegistered);
  //   });
  // }

  Future<PhoneContacts<RegisteredPhoneContacts, UnRegisteredPhoneContacts?>?>
      getContactsListsFromDB() async {
    final list = _hiveHandler.getContactsListFromDB();
    return _phoneContacts = await isolateSpawn(list);
  }

  String _chatID() {
    String _chatID = Uuid().v4();
    return _chatID;
  }

  dispose() {
    disposeIsolate();
    super.dispose();
  }

  PhoneContacts<RegisteredPhoneContacts, UnRegisteredPhoneContacts?>
      get phoneContacts => _phoneContacts!;
  bool get existInHive => _hiveHandler.checkIfChatBoxExistAlready;
}
