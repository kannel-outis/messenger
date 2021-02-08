import 'package:hive/hive.dart';
import 'package:messenger/models/chat.dart';
import 'package:messenger/models/contacts_model.dart';
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
  final _hiveContactsList =
      Hive.box<HivePhoneContactsList>(HiveInit.hiveContactsList);

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

  bool checkIfChatExist(HiveChat chat) {
    ///check if already exist in the db and dont create a new chat
    return _chatBox.values.where((element) => chat == element).isNotEmpty;
  }

  List<HiveChat> loadChatsFromLocalDB() {
    return _chatBox.values.toList();
  }

  List<List<Map<String, dynamic>>> getContactsListFromDB() {
    return _hiveContactsList.values.toList().single.phoneContacts;
  }

  Future<void> saveContactsListToDB(
      List<List<PhoneContacts>> phoneContact) async {
    // to List<Map<String, dynamic>>
    List<Map<String, Map<String, dynamic>>> _registered = [];
    List<Map<String, Map<String, dynamic>>> _unRegistered = [];
    print("Start");
    phoneContact.forEach((element) {
      print("Start++");

      element.forEach((element) {
        print("Start+++");
        if (element is RegisteredPhoneContacts) {
          print('Start and make sense ....then work');
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
