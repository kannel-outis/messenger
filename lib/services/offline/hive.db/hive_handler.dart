import 'package:messenger/models/chat.dart';
import 'package:messenger/models/contacts_model.dart';
import 'package:messenger/models/message.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/services/manager/hive.manager.dart';
import 'package:messenger/services/manager/manager.dart';
import 'package:messenger/services/offline/hive.db/models/hive_messages.dart';
import 'package:messenger/services/offline/hive.db/models/keys.dart';

import 'models/hive_chat.dart';
import 'models/keypairs.dart';

class HiveHandler extends ManagerHandler<Manager> {
  HiveHandler() {
    setManager(HiveManager.instance);
  }
  @override
  Manager? setManager(Manager? newManager) {
    return super.setManager(newManager);
  }

  Future<void> saveChatToDB(OnlineChat chat) async {
    await manager!.saveChatToDB(chat);
  }

  List<HiveChat> loadChatsFromDB() {
    return manager!.loadChatsFromLocalDB();
  }

  bool checkIfchatExists(LocalChat hiveChat) {
    return manager!.checkIfChatExists(hiveChat);
  }

  List<List<Map<String, dynamic>>> getContactsListFromDB() {
    return manager!.getContactsListFromDB();
  }

  Future<void> saveContactsListToDB(
      List<List<PhoneContacts>> phoneContact) async {
    manager!.saveContactsListToDB(phoneContact);
  }

  void updateUserInHive(User user) {
    manager!.updateUserInHive(user);
  }

  void updateUserOnContactsListInHive(User user, int index) {
    manager!.updateUserOnContactsListInHive(user, index);
  }

  List<HiveMessages> getMessagesFromDB(String chatID) {
    return manager!.getMessagesFromDB(chatID);
  }

  void updateMessageIsRead(HiveMessages message) {
    manager!.updateMessageIsRead(message);
  }

  void updateAllGroupInfo(HiveGroupChat group) {
    manager!.updateAllGroupInfo(group);
  }

  Future<void> deleteChatAndMessagesFromLocalStorage(HiveChat hiveChat) async {
    return await manager!.deleteChatAndMessagesFromLocalStorage(hiveChat);
  }

  Future<void> saveMessages(Message message) {
    return manager!.saveMessages(
      HiveMessages(
        chatID: message.chatID,
        dateTime: message.timeOfMessage,
        messageType: message.messageType,
        msg: message.message,
        receiverIDs: message.receiverIDs,
        senderID: message.senderID,
        messageID: message.messageID,
        isRead: false,
        isGroup: message.isGroup,
      ),
    );
  }

  Future<HiveKeyPair?> saveKeyPairs(HiveKeyPair hiveKeyPairs) async {
    return await manager!.saveKeyPairs(hiveKeyPairs);
  }

  MyPrivateKey get myPrivateKeyFromDB => manager!.getPrivateKeyFromDB;
}
