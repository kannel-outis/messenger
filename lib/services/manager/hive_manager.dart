import 'package:hive/hive.dart';
import 'package:messenger/models/chat.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/services/offline/hive.db/hive_init.dart';
import 'package:messenger/services/offline/hive.db/models/hive_chat.dart';
import 'package:messenger/services/offline/hive.db/models/hive_messages.dart';

import 'manager.dart';

class HiveManager extends Manager {
  HiveManager._();
  static HiveManager _instance;
  static HiveManager get instance {
    if (_instance == null) {
      _instance = HiveManager._();
    }
    return _instance;
  }

  final _chatBox = Hive.box<HiveChat>(HiveInit.chatBoxName);
  final _messageBox = Hive.box<HiveMessages>(HiveInit.messagesBoxName);

  Future<void> saveChatToDB(Chat chat) async {
    List<User> _users = [];
    chat.participants.forEach((element) {
      _users.add(User.fromMap(element));
    });
    final _hiveChat = HiveChat(chatId: chat.chatID, participants: _users);
    await _chatBox.add(_hiveChat);
  }

  Future<void> saveMessages(HiveMessages message) async {
    await _messageBox.add(message);
  }

  List<HiveMessages> getMessagesFromDB(String chatID) {
    return _messageBox.values
        .where((element) => element.chatID == chatID)
        .toList();
  }

  List<HiveChat> loadChatsFromLocalDB() {
    return _chatBox.values.toList();
  }

  Box<HiveChat> get chatBox => _chatBox;
  Box<HiveMessages> get messageBox => _messageBox;
}
