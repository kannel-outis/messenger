import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:messenger/customs/error/error.dart';
import 'package:messenger/models/chat.dart';
import 'package:messenger/models/contacts_model.dart';
import 'package:messenger/models/message.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/services/encryption_class.dart';
import 'package:messenger/services/offline/hive.db/hive_handler.dart';
import 'package:messenger/services/offline/hive.db/models/hive_messages.dart';
import 'package:messenger/services/offline/hive.db/models/keys.dart';
import 'package:messenger/services/offline/shared_prefs/shared_prefs.dart';
import 'package:messenger/services/online/firebase/firestore_service.dart';
import 'package:messenger/services/online/mqtt/mqtt_handler.dart';
import 'package:messenger/services/online/online.dart';
import 'package:messenger/utils/constants.dart';
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
        receiverID: receiverID,
        timeOfMessage: DateTime.now(),
        messageID: Uuid().v4(),
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
    return SharedPrefs.instance.getUserData();
  }

  bool isme(List<String>? iDs) {
    final User prefUser = User.fromMap(
        json.decode(SharedPrefs.instance.getString(OfflineConstants.MY_DATA)!));
    return iDs!.contains(prefUser.id);
  }
}
