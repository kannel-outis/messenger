import 'package:flutter/foundation.dart';
import 'package:messenger/models/message.dart';
import 'package:messenger/services/encryption_class.dart';
import 'package:messenger/services/manager/encrypt.manager.dart';
import 'package:messenger/services/offline/hive.db/hive_handler.dart';
import 'package:messenger/services/offline/hive.db/models/hive_chat.dart';
import 'package:messenger/services/offline/hive.db/models/hive_messages.dart';
import 'package:messenger/services/offline/hive.db/models/keys.dart';
import 'package:messenger/services/offline/shared_prefs/shared_prefs.dart';
import 'package:messenger/services/online/mqtt/mqtt_handler.dart';
import 'package:uuid/uuid.dart';

class ChatsProvider extends ChangeNotifier {
  MQTThandler _mqttHandler = MQTThandler();
  HiveHandler _hiveHandler = HiveHandler();
  EncryptClassHandler _encryptClassHandler = EncryptClassHandler();
  void sendMessage(
      {required HiveChat hiveChat,
      required String? msg,
      required String publicKey}) {
    print(SharedPrefs.instance.getUserData().id);
    // return;
    final rsaPublicKey =
        _encryptClassHandler.keysFromString(isPrivate: false, key: publicKey);
    final myPublicKey = MyPublicKey(
        modulus: rsaPublicKey.modulus, exponent: rsaPublicKey.exponent);
    final secureMessage = _encryptClassHandler.rsaEncrypt(myPublicKey, msg!);
    final Message message = Message(
      chatID: hiveChat.chatId,
      message: String.fromCharCodes(secureMessage),
      messageType: 'text',
      senderID: hiveChat.participants![0].id,
      receiverID: hiveChat.participants![1].id,
      timeOfMessage: DateTime.now(),
      messageID: Uuid().v4(),
    );
    _hiveHandler.saveMessages(message.copyWith(message: msg));
    _mqttHandler.publish(hiveChat.chatId!, message);
  }

  Stream<Map<String, dynamic>?> get stream => _mqttHandler.messageController;

  void updateMessageIsRead(HiveMessages message) =>
      _hiveHandler.updateMessageIsRead(message);

  List<HiveMessages> getMessagesFromDB(String chatID) {
    return _hiveHandler.getMessagesFromDB(chatID);
  }
}
