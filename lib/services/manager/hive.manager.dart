import 'package:hive/hive.dart';
import 'package:messenger/models/chat.dart';
import 'package:messenger/models/contacts_model.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/services/offline/hive.db/hive_init.dart';
import 'package:messenger/services/offline/hive.db/models/hive_chat.dart';
import 'package:messenger/services/offline/hive.db/models/hive_messages.dart';
import 'package:messenger/services/offline/hive.db/models/keypairs.dart';

import 'encrypt.manager.dart';
import 'manager.dart';

class HiveManager extends Manager {
  HiveManager._();
  static HiveManager? _instance;
  static HiveManager? get instance {
    if (_instance == null) {
      _instance = HiveManager._();
    }
    return _instance;
  }

  final _chatBox = Hive.box<HiveChat>(HiveInit.chatBoxName);
  final _messageBox = Hive.box<HiveMessages>(HiveInit.messagesBoxName);
  final _hiveContactsList =
      Hive.box<HivePhoneContactsList>(HiveInit.hiveContactsList);
  final _hiveKeyPairsBox = Hive.box<HiveKeyPair>(HiveInit.keyPairs);

  Future<void> saveChatToDB(Chat chat) async {
    // List<User> _users = ;
    final _hiveChat = HiveChat(
        chatId: chat.chatID,
        participants: chat.participants!.map((e) => User.fromMap(e!)).toList());
    if (checkIfChatExists(_hiveChat)) {
      print("It Didnt work");
      return;
    }
    await _chatBox.add(_hiveChat);
  }

  Future<void> saveMessages(HiveMessages message) async {
    print("OdeBi");
    if (_checkIfMessageExists(message)) return;
    try {
      await _messageBox.add(message);
    } catch (e) {
      print(e.toString());
    }
  }

  List<HiveMessages> getMessagesFromDB(String chatID) {
    return _messageBox.values
        .where((element) => element.chatID == chatID)
        .toList();
  }

  Future<HiveKeyPair?> saveKeyPairs(HiveKeyPair hiveKeyPairs) async {
    final _hiveKeyPairs = hiveKeyPairs;
    await _hiveKeyPairsBox.add(_hiveKeyPairs);
    return _hiveKeyPairs;
  }

  // bool checkIfExistObjExist(Object obj) {
  //   if (obj is HiveChat) {
  //     print('this is a Hive chat object');
  // return _chatBox.values
  //     .where((element) => obj.chatId == element.chatId)
  //     .isNotEmpty;
  //   } else if (obj is HiveMessages) {
  //     return _messageBox.values
  //         .where((element) => obj.messageID == element.messageID)
  //         .isNotEmpty;
  //   } else {
  //     return false;
  //   }
  // }

  Future<void> deleteChatAndMessagesFromLocalStorage(HiveChat hiveChat) async {
    await _chatBox.delete(hiveChat.key).then((value) {
      _messageBox.values
          .where((element) => hiveChat.chatId == element.chatID)
          .toList()
          .forEach((element) async {
        await _messageBox.delete(element.key);
      });
    });
  }

  bool checkIfChatExists(HiveChat hiveChat) {
    return _chatBox.values
        .where((element) => hiveChat.chatId == element.chatId)
        .isEmpty;
  }

  bool _checkIfMessageExists(HiveMessages message) {
    return _messageBox.values
        .where((element) => message.messageID == element.messageID)
        .isNotEmpty;
  }

  void updateMessageIsRead(HiveMessages message) {
    var messagesList = _messageBox.values
        .where((element) =>
            element.chatID == message.chatID && message.isRead == false)
        .toList();
    messagesList.forEach((element) {
      final newElement = element.copyWith(isRead: true);
      _messageBox.put(element.key, newElement);
    });
  }

  List<HiveChat> loadChatsFromLocalDB() {
    return _chatBox.values.toList();
  }

  List<List<Map<String, dynamic>>> getContactsListFromDB() {
    return _hiveContactsList.values.toList().single.phoneContacts;
  }

  void updateUserInHive(User user, int index) {
    assert(index < 2);
    _chatBox.values
        .where((element) {
          return element.participants![index].id == user.id;
        })
        .toList()
        .forEach(
          (element) {
            if (element.participants![index] != user) {
              print(element.chatId);
              element.participants![index] = user;
              // not Working here
              element.save();
            }
          },
        );
  }

  void updateUserOnContactsListInHive(User user, int index) {
    _hiveContactsList.values
        .where(
          (element) {
            late bool isEqualToId;
            element.phoneContacts[0].forEach(
              (element) {
                isEqualToId = element['user']['id'] == user.id;
              },
            );
            return isEqualToId;
          },
        )
        .toList()
        .forEach(
          (phoneContactList) {
            phoneContactList.phoneContacts[0].forEach(
              (element) {
                if (Map<String, dynamic>.from(element['user']) !=
                    user.toMap()) {
                  element['user'] = user.toMap() as dynamic;
                  phoneContactList.save();
                }
              },
            );
          },
        );
  }

  Future<void> saveContactsListToDB(
      List<List<PhoneContacts>> phoneContact) async {
    List<Map<String, Map<String, dynamic>>> _registered = [];
    List<Map<String, Map<String, dynamic>>> _unRegistered = [];
    phoneContact.forEach((element) {
      element.forEach((element) {
        if (element is RegisteredPhoneContacts) {
          _registered.add(element.toMap());
        } else {
          _unRegistered.add((element as UnRegisteredPhoneContacts).toMap());
        }
      });
    });
    var hiveContact = HivePhoneContactsList(
      phoneContacts: [
        _registered,
        _unRegistered,
      ],
    );
    await _hiveContactsList.add(hiveContact);
  }

  Box<HiveChat> get chatBox => _chatBox;
  Box<HiveMessages> get messageBox => _messageBox;
  bool get checkIfChatBoxExistAlready => _hiveContactsList.isNotEmpty;
}
