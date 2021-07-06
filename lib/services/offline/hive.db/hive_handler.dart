import 'package:messenger/models/chat.dart';
import 'package:messenger/models/contacts_model.dart';
import 'package:messenger/models/message.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/services/manager/hive.manager.dart';
import 'package:messenger/services/manager/manager.dart';
import 'package:messenger/services/offline/hive.db/models/hive_messages.dart';
import 'package:messenger/services/offline/hive.db/models/keys.dart';

import 'models/hive_chat.dart';
import 'models/hive_group_chat_saltiv.dart';
import 'models/keypairs.dart';

class HiveHandler extends ManagerHandler<IHiveManager> {
  HiveHandler() {
    setManager(HiveManager.instance);
  }
  @override
  Manager? setManager(newManager) {
    return super.setManager(newManager as HiveManager);
  }

  Future<void> saveChatToDB(OnlineChat chat,
      {HiveGroupChatSaltIV? hiveGroupChatSaltIV}) async {
    await manager!.saveChatToDB(chat, hiveGroupChatSaltIV: hiveGroupChatSaltIV);
  }

  List<LocalChat> loadChatsFromDB() {
    return manager!.loadChatsFromLocalDB();
  }

  bool checkIfchatExists(LocalChat hiveChat) {
    return manager!.checkIfChatExists(hiveChat);
  }

  PhoneContacts<Map<String, dynamic>, Map<String, dynamic>>
      getContactsListFromDB() {
    return manager!.getContactsListFromDB();
  }

  Future<void> saveContactsListToDB(
      PhoneContacts<RegisteredPhoneContacts, UnRegisteredPhoneContacts>
          phoneContact) async {
    manager!.saveContactsListToDB(phoneContact);
  }

  void updateUserInHive(User user, int index) {
    manager!.updateUserInHive(user, index);
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

  Future<void> deleteChatAndMessagesFromLocalStorage(LocalChat hiveChat) async {
    return await manager!.deleteChatAndMessagesFromLocalStorage(hiveChat);
  }

  LocalChat loadSingleChat(String id, {bool? isGroupChat = false}) {
    return manager!.loadSingleChat(id, isGroupChat: isGroupChat);
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

  HiveMessages? getLastMessage(
      {String? userId, required String chatId, bool? isGroup}) {
    return manager!
        .getLastMessage(userId: userId, chatId: chatId, isGroup: isGroup);
  }

  // void updateHiveGroupChat(
  //     GroupChat groupChat, HiveGroupChatSaltIV hiveGroupChatSaltIV) {
  //   manager!.updateHiveGroupChat(groupChat, hiveGroupChatSaltIV);
  // }

  MyPrivateKey get myPrivateKeyFromDB => manager!.getPrivateKeyFromDB;
}
