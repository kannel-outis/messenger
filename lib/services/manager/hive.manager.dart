import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:messenger/models/chat.dart';
import 'package:messenger/models/contacts_model.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/services/offline/hive.db/hive_init.dart';
import 'package:messenger/services/offline/hive.db/models/hive_chat.dart';
import 'package:messenger/services/offline/hive.db/models/hive_group_chat_saltiv.dart';
import 'package:messenger/services/offline/hive.db/models/hive_messages.dart';
import 'package:messenger/services/offline/hive.db/models/keypairs.dart';
import 'package:messenger/services/offline/hive.db/models/keys.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'manager.dart';

class HiveManager implements IHiveManager {
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
  final _hiveGroupChatBox =
      Hive.box<HiveGroupChat>(HiveInit.hiveGroupChatsBoxName);
  @override
  Future<void> saveChatToDB(OnlineChat chat,
      {HiveGroupChatSaltIV? hiveGroupChatSaltIV}) async {
    if (chat is Chat) {
      final _hiveChat = HiveChat(
          chatId: chat.chatID,
          participants:
              chat.participants.map((e) => User.fromMap(e!)).toList());
      if (checkIfChatExists(_hiveChat)) {
        return;
      }
      await _chatBox.add(_hiveChat);
    } else {
      chat as GroupChat;
      final hiveGroupChat = HiveGroupChat(
        groupName: chat.groupName,
        groupCreator: User.fromMap(chat.groupCreator),
        participants: chat.participants.map((e) => User.fromMap(e!)).toList(),
        groupAdmins: chat.groupAdmins!.map((e) => User.fromMap(e)).toList(),
        groupCreationTimeDate: chat.groupCreationTimeDate,
        groupDescription: chat.groupDescription,
        groupID: chat.groupID,
        groupPhotoUrl: chat.groupPhotoUrl,
        hiveGroupChatSaltIV: hiveGroupChatSaltIV!,
      );
      if (checkIfChatExists(hiveGroupChat)) {
        return;
      }
      await _hiveGroupChatBox.add(hiveGroupChat);
    }
  }

  @override
  Future<void> saveMessages(HiveMessages message) async {
    if (_checkIfMessageExists(message)) return;
    try {
      await _messageBox.add(message);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  List<HiveMessages> getMessagesFromDB(String chatID) {
    return _messageBox.values
        .where((element) => element.chatID == chatID)
        .toList();
  }

  @override
  Future<HiveKeyPair?> saveKeyPairs(HiveKeyPair hiveKeyPairs) async {
    final _hiveKeyPairs = hiveKeyPairs;
    await _hiveKeyPairsBox
        .add(_hiveKeyPairs)
        .then((value) => print("saved Key pairs"));
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
  @override
  Future<void> deleteChatAndMessagesFromLocalStorage(LocalChat hiveChat) async {
    if (hiveChat is HiveChat) {
      await _chatBox.delete(hiveChat.key).then((value) {
        _messageBox.values
            .where((element) => hiveChat.chatId == element.chatID)
            .toList()
            .forEach((element) async {
          await _messageBox.delete(element.key);
        });
      });
    } else {
      hiveChat as HiveGroupChat;
      await _hiveGroupChatBox.delete(hiveChat.key).then((value) {
        _messageBox.values
            .where((element) => hiveChat.groupID == element.chatID)
            .toList()
            .forEach((element) async {
          await _messageBox.delete(element.key);
        });
      });
    }
  }

  @override
  bool checkIfChatExists(LocalChat hiveChat) {
    if (hiveChat is HiveChat) {
      return _chatBox.values
          .where((element) => hiveChat.chatId == element.chatId)
          .isNotEmpty;
    } else if (hiveChat is HiveGroupChat) {
      return _hiveGroupChatBox.values
          .where((element) => hiveChat.groupID == element.groupID)
          .isNotEmpty;
    }
    return false;
  }

  bool _checkIfMessageExists(HiveMessages message) {
    return _messageBox.values
        .where((element) => message.messageID == element.messageID)
        .isNotEmpty;
  }

  @override
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

  @override
  List<HiveChat> loadChatsFromLocalDB() {
    return _chatBox.values.toList();
  }

  @override
  List<List<Map<String, dynamic>>> getContactsListFromDB() {
    return _hiveContactsList.values.toList().single.phoneContacts;
  }

  @override
  void updateUserInHive(User user, int index) {
    // int? index;
    // final _listOfChatsThatUserParticipatesIn = _chatBox.values.where((element) {
    //   final listOfIDs = element.participants!.map((e) => e.id!).toList();
    //   index = listOfIDs.indexOf(user.id!);
    //   return index! >= 0 ? element.participants![index!].id == user.id : false;
    // }).toList();

    // if (_listOfChatsThatUserParticipatesIn.length >= 0) {
    //   for (var element in _listOfChatsThatUserParticipatesIn) {
    //     if (element.participants![index!] != user) {
    //       element.participants![index!] = user;
    //       element.save();
    //     }
    //   }
    // }

    assert(index < 2);
    _chatBox.values
        .where((element) {
          return element.participants![index].id == user.id;
        })
        .toList()
        .forEach(
          (element) {
            if (element.participants![index] != user) {
              element.participants![index] = user;
              element.save();
            }
          },
        );
  }

  @override
  void updateAllGroupInfo(HiveGroupChat group) {
    _hiveGroupChatBox.values
        .where((element) => element.id == group.id)
        .forEach((element) {
      // final e = element.copyWith(
      //   groupAdmins: group.groupAdmins,
      //   groupCreationTimeDate: group.groupCreationTimeDate,
      //   groupCreator: group.groupCreator,
      //   groupDescription: group.groupDescription,
      //   groupName: group.groupName,
      //   groupPhotoUrl: group.groupPhotoUrl,
      //   // hiveGroupChatSaltIV: group
      //   participants: group.participants,
      // );
      _hiveGroupChatBox.put(element.key, group);
    });
  }

  @override
  void updateUserOnContactsListInHive(User user, int index) {
    // print("Happen shele");
    // _hiveContactsList.values
    //     .where(
    //       (element) {
    //         late bool isEqualToId;
    //         element.phoneContacts[0].forEach(
    //           (element) {
    //             isEqualToId = element['user']['id'] == user.id;
    //           },
    //         );
    //         return isEqualToId;
    //       },
    //     )
    //     .toList()
    //     .forEach(
    //       (phoneContactList) {
    //         phoneContactList.phoneContacts[0].forEach(
    //           (element) {
    //             if (Map<String, dynamic>.from(element['user']) !=
    //                 user.toMap()) {
    //               element['user'] = user.toMap() as dynamic;
    //               phoneContactList.save();
    //             }
    //           },
    //         );
    //       },
    //     );
  }
  @override
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

  @override
  @protected
  MyPrivateKey get getPrivateKeyFromDB {
    final _keyHelper = RsaKeyHelper();

    final rsaPrivateKey = _keyHelper.parsePrivateKeyFromPem(
        _hiveKeyPairsBox.values.toList()[0].privateKey!);
    return MyPrivateKey(
        modulus: rsaPrivateKey.modulus,
        p: rsaPrivateKey.p,
        privateExponent: rsaPrivateKey.privateExponent,
        q: rsaPrivateKey.q);
  }

  Box<HiveChat> get chatBox => _chatBox;
  Box<HiveMessages> get messageBox => _messageBox;
  bool get checkIfChatBoxExistAlready => _hiveContactsList.isNotEmpty;

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  LocalChat loadSingleChat(String id, {bool? isGroupChat}) {
    if (isGroupChat == false) {
      return _chatBox.values
          .where((element) => element.chatId == id)
          .toList()
          .single;
    } else {
      return _hiveGroupChatBox.values
          .where((element) => element.groupID == id)
          .toList()
          .single;
    }
  }

  @override
  HiveMessages? getLastMessage(
      {String? userId, required String chatId, bool? isGroup}) {
    if (isGroup!) {
      print("shiy");
      final message = _messageBox.values
          .where((element) => element.chatID == chatId)
          .toList();
      if (message.isEmpty) return null;
      return message.last;
    }
    final message = _messageBox.values
        .where(
            (element) => element.senderID == userId && element.chatID == chatId)
        .toList();
    if (message.isEmpty) return null;
    return message.last;
  }
}
