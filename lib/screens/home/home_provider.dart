import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:messenger/customs/error/error.dart';
import 'package:messenger/models/chat.dart';
import 'package:messenger/models/message.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/services/encryption_class.dart';
import 'package:messenger/services/offline/hive.db/hive_handler.dart';
import 'package:messenger/services/offline/hive.db/models/hive_chat.dart';
import 'package:messenger/services/offline/hive.db/models/hive_group_chat_saltiv.dart';
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
  // bool contains(List<String>? iDs) {
  //   final User prefUser = User.fromMap(
  //       json.decode(SharedPrefs.instance.getString(OfflineConstants.MY_DATA)!));
  //   return iDs!.contains(prefUser.id);
  // }

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
                ..updateUserInHive(hiveChat.participants![i], i)
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
          if (chat.participantsIDs.contains(user.id)) {
            final s = _encryptClassHandler.rsaDecrypt(
              _hiveHandler.myPrivateKeyFromDB,
              chat.usersEncrytedKey[
                  _index(chat.participantsIDs.map((e) => e!).toList())],
              // chat.usersEncrytedKey[0],
            );
            final Map<String, dynamic> _map =
                json.decode(String.fromCharCodes(s));
            final _stringStringMap =
                _map.map((key, value) => MapEntry(key, value as String));
            // print(_stringStringMap);

            HiveGroupChat hiveChat = HiveGroupChat(
                groupID: chat.groupID,
                participants:
                    chat.participants.map((e) => User.fromMap(e!)).toList(),
                groupCreator: User.fromMap(chat.groupCreator),
                groupName: chat.groupName,
                groupAdmins:
                    chat.groupAdmins!.map((e) => User.fromMap(e)).toList(),
                groupCreationTimeDate: chat.groupCreationTimeDate,
                groupDescription: chat.groupDescription,
                groupPhotoUrl: chat.groupPhotoUrl,
                hiveGroupChatSaltIV:
                    HiveGroupChatSaltIV.fromMap(_stringStringMap));
            bool exists = _hiveHandler.checkIfchatExists(hiveChat);

            if (exists == false) {
              _hiveHandler.saveChatToDB(chat,
                  hiveGroupChatSaltIV: hiveChat.hiveGroupChatSaltIV);
            } else {
              _hiveHandler..updateAllGroupInfo(hiveChat);
            }
            _mqttHandler
                .subscribe(chat.groupID)
                .then((value) => print('SubScribed group'));
          } else {
            // TODO: Do Something
          }
        }
      } else {
        print('Group Empty');
      }
    });
    _mqttHandler.messageController.listen((event) {
      _list.add(event);
      try {
        if (_list.last!['isGroup'] == false) {
          if (![_list.last!["senderID"]].contains(user.id)) {
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
        } else if (_list.last!['isGroup'] == true) {
          final groupMessage = Message.fromMap(_list.last!);
          final getChatFromDb = (_hiveHandler.loadSingleChat(
              groupMessage.chatID!,
              isGroupChat: true)) as HiveGroupChat;

          final decryptedGroupMessage = _encryptClassHandler.aesDecrypt(
              Uint8List.fromList(groupMessage.message!.codeUnits),
              groupMessage.chatID!,
              randomSalt: getChatFromDb.hiveGroupChatSaltIV!.salt!,
              iv: getChatFromDb.hiveGroupChatSaltIV!.iv!);
          _hiveHandler.saveMessages(
              groupMessage.copyWith(message: decryptedGroupMessage));
        }

        _hiveHandler.saveMessages(
          Message.fromMap(_list.last!),
        );
      } on MessengerError catch (e) {
        print(e.message);
      }
    });
  }

  // bool isme(List<String>? iDs) {
  //   final User prefUser = User.fromMap(
  //       json.decode(SharedPrefs.instance.getString(OfflineConstants.MY_DATA)!));
  //   return iDs!.contains(prefUser.id);
  // }

  int _index(List<String> users) {
    return users.indexWhere((element) => user.id == element);
  }

  Future<void> deleteChatAndRemovePrintsFromDB(LocalChat hiveChat,
      {bool? isGroup}) async {
    await _storeService.deleteChat(id: hiveChat.id!, isGroup: isGroup!).then(
      (value) async {
        _mqttHandler.unsubscribe(hiveChat.id!);
        await _hiveHandler.deleteChatAndMessagesFromLocalStorage(hiveChat);
      },
    );
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
