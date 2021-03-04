import 'package:flutter/foundation.dart';
import 'package:messenger/models/message.dart';
import 'package:messenger/services/offline/hive.db/hive_handler.dart';
import 'package:messenger/services/offline/hive.db/models/hive_chat.dart';
import 'package:messenger/services/offline/hive.db/models/hive_messages.dart';
import 'package:messenger/services/offline/shared_prefs/shared_prefs.dart';
import 'package:messenger/services/online/mqtt/mqtt_handler.dart';
import 'package:uuid/uuid.dart';

class ChatsProvider extends ChangeNotifier {
  MQTThandler _mqttHandler = MQTThandler();
  HiveHandler _hiveHandler = HiveHandler();
  void sendMessage({@required HiveChat hiveChat, @required String msg}) {
    print(SharedPrefs.instance.getUserData().id);
    // return;
    final Message message = Message(
      chatID: hiveChat.chatId,
      message: msg,
      messageType: 'text',
      senderID: hiveChat.participants[0].id,
      receiverID: hiveChat.participants[1].id,
      timeOfMessage: DateTime.now(),
      messageID: Uuid().v4(),
    );
    _mqttHandler.publish(hiveChat.chatId, message);
  }

  Stream<Map<String, dynamic>> get stream => _mqttHandler.messageController;

  List<HiveMessages> getMessagesFromDB(String chatID) {
    return _hiveHandler.getMessagesFromDB(chatID);
  }
}
