import 'package:flutter/foundation.dart';
import 'package:messenger/models/message.dart';
import 'package:messenger/services/offline/hive.db/models/hive_chat.dart';
import 'package:messenger/services/online/mqtt/mqtt_handler.dart';

class ChatsProvider extends ChangeNotifier {
  MQTThandler _mqttHandler = MQTThandler();
  void sendMessage(
      {String identifier, @required HiveChat hiveChat, @required String msg}) {
    final Message message = Message(
      chatID: hiveChat.chatId,
      message: msg,
      messageType: 'text',
      senderID: hiveChat.participants[0].id,
      receiverID: hiveChat.participants[1].id,
      timeOfMessage: DateTime.now(),
    );
    _mqttHandler.publish(hiveChat.chatId, message);
  }
}
