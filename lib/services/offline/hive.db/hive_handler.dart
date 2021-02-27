import 'package:messenger/models/chat.dart';
import 'package:messenger/models/contacts_model.dart';
import 'package:messenger/models/message.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/services/manager/hive_manager.dart';
import 'package:messenger/services/manager/manager.dart';
import 'package:messenger/services/offline/hive.db/models/hive_messages.dart';

import 'models/hive_chat.dart';

class HiveHandler extends ManagerHandler<HiveManager> {
  HiveHandler() {
    setManager(HiveManager.instance);
  }
  @override
  HiveManager setManager(HiveManager newManager) {
    return super.setManager(newManager);
  }

  @override
  Future<void> saveChatToDB(Chat chat) async {
    await manager.saveChatToDB(chat);
  }

  @override
  List<HiveChat> loadChatsFromDB() {
    return manager.loadChatsFromLocalDB();
  }

  @override
  bool checkIfchatExists(HiveChat hiveChat) {
    return manager.checkIfChatExist(hiveChat);
  }

  @override
  List<List<Map<String, dynamic>>> getContactsListFromDB() {
    return manager.getContactsListFromDB();
  }

  // yeah??

  @override
  Future<void> saveContactsListToDB(
      List<List<PhoneContacts>> phoneContact) async {
    manager.saveContactsListToDB(phoneContact);
  }

  @override
  void updateUserInHive(User user, int index) {
    manager.updateUserInHive(user, index);
  }

  @override
  void updateUserOnContactsListInHive(User user, int index) {
    manager.updateUserOnContactsListInHive(user, index);
  }

  List<HiveMessages> getMessagesFromDB(String chatID) {
    return manager.getMessagesFromDB(chatID);
  }

  @override
  Future<void> saveMessages(Message message) {
    return manager.saveMessages(
      HiveMessages(
        chatID: message.chatID,
        dateTime: message.timeOfMessage,
        messageType: message.messageType,
        msg: message.message,
        receiverID: message.receiverID,
        senderID: message.senderID,
      ),
    );
  }
}
