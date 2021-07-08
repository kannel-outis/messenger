import 'package:flutter/foundation.dart';
import 'package:messenger/customs/error/error.dart';
import 'package:messenger/models/message.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/services/encryption_class.dart';
import 'package:messenger/services/offline/hive.db/hive_handler.dart';
import 'package:messenger/services/offline/hive.db/models/hive_chat.dart';
import 'package:messenger/services/offline/hive.db/models/hive_messages.dart';
import 'package:messenger/services/offline/hive.db/models/keys.dart';
import 'package:messenger/services/offline/shared_prefs/shared_prefs.dart';
import 'package:messenger/services/online/mqtt/mqtt_handler.dart';
import 'package:messenger/utils/typedef.dart';
import 'package:uuid/uuid.dart';

class ChatsProvider extends ChangeNotifier {
  MQTThandler _mqttHandler = MQTThandler();
  HiveHandler _hiveHandler = HiveHandler();
  EncryptClassHandler _encryptClassHandler = EncryptClassHandler();
  void sendMessage(
      {required String chatId,
      required String senderID,
      required String receiverID,
      required String? msg,
      required String publicKey,
      required VoidExceptionCallBack? handleExceptionInUi}) {
    try {
      final rsaPublicKey =
          _encryptClassHandler.keysFromString(isPrivate: false, key: publicKey);
      final myPublicKey = MyPublicKey(
          modulus: rsaPublicKey.modulus, exponent: rsaPublicKey.exponent);
      final secureMessage = _encryptClassHandler.rsaEncrypt(myPublicKey, msg!);
      final Message message = Message(
        chatID: chatId,
        message: String.fromCharCodes(secureMessage),
        messageType: 'text',
        senderID: senderID,
        receiverIDs: [receiverID],
        timeOfMessage: DateTime.now(),
        messageID: Uuid().v4(),
        isGroup: false,
      );
      _hiveHandler.saveMessages(message.copyWith(message: msg));
      _mqttHandler.publish(chatId, message);
    } on MessengerError catch (e) {
      handleExceptionInUi!(e.message);
    }
  }

  Stream<Map<String, dynamic>?> get stream => _mqttHandler.messageController;

  void updateMessageIsRead(HiveMessages message) =>
      _hiveHandler.updateMessageIsRead(message);

  List<HiveMessages> getMessagesFromDB(String chatID) {
    return _hiveHandler.getMessagesFromDB(chatID);
  }

  User get user {
    return SharedPrefs.instance.user;
  }

  void sendGroupMessage(
      // {required String groupID,
      // required String senderID,
      // required List<String> receiverIDs,
      {required HiveGroupChat hiveGroupChat,
      required String msg,
      required VoidExceptionCallBack? handleExceptionInUi}) {
    try {
      final encryptedMessage = _encryptClassHandler.aesEncrypt(
          msg, hiveGroupChat.groupID!,
          randomSalt: hiveGroupChat.hiveGroupChatSaltIV!.salt!,
          iv: hiveGroupChat.hiveGroupChatSaltIV!.iv!);
      final Message message = Message(
        chatID: hiveGroupChat.groupID,
        message: String.fromCharCodes(encryptedMessage),
        messageType: 'text',
        senderID: hiveGroupChat
            .participants![hiveGroupChat.participants!
                .map((e) => e.id!)
                .toList()
                .indexWhere((element) => user.id == element)]
            .id!,
        receiverIDs: hiveGroupChat.participants!.map((e) => e.id!).toList(),
        timeOfMessage: DateTime.now(),
        messageID: Uuid().v4(),
        isGroup: true,
      );
      _hiveHandler.saveMessages(message.copyWith(message: msg));
      _mqttHandler.publish(hiveGroupChat.groupID!, message);
    } on MessengerError catch (e) {
      handleExceptionInUi!(e.message);
    }
  }
}
