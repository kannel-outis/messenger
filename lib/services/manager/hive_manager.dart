import 'package:hive/hive.dart';
import 'package:messenger/models/chat.dart';
import 'package:messenger/models/message.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/services/offline/hive.db/hive_init.dart';
import 'package:messenger/services/offline/hive.db/models/hive_chat.dart';

class HiveManager {
  HiveManager._();
  static HiveManager _instance;
  static HiveManager get instance {
    if (_instance == null) {
      _instance = HiveManager._();
    }
    return _instance;
  }

  final _chatBox = Hive.box<HiveChat>(HiveInit.chatBoxName);
  final _messageBox = Hive.box<Message>(HiveInit.messagesBoxName);

  Future<void> saveChatToDB(Chat chat) async {
    List<User> _users = [];
    chat.participants.forEach((element) {
      _users.add(User.fromMap(element));
    });
    final _hiveChat = HiveChat(chatId: chat.chatID, participants: _users);
    await _chatBox.add(_hiveChat);
  }

  Future<void> saveMessages(Message message) async {
    await _messageBox.add(message);
  }

  List<Message> getMessagesFromDB(String chatID) {
    return _messageBox.values
        .where((element) => element.chatID == chatID)
        .toList();
  }
}
