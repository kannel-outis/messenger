import 'package:hive/hive.dart';
import 'package:messenger/models/contacts_model.dart';
import 'package:messenger/models/user.dart';
import 'models/hive_chat.dart';
import 'models/hive_messages.dart';
import 'models/keypairs.dart';
import 'package:path_provider/path_provider.dart';

import 'models/hive_group_chat_saltiv.dart';

class HiveInit {
  static String messagesBoxName = "MessagesBox";
  static String chatBoxName = "HiveChatBox";
  static String hiveContactsList = "HiveContactsList";
  static String keyPairs = "KeyPairs";
  static String hiveGroupChatsBoxName = "HiveGroupChats";

  static Future hiveInit() async {
    final documentDir = await getApplicationDocumentsDirectory();
    Hive.init(documentDir.path);
    Hive.registerAdapter(HiveMessagesAdapter());
    Hive.registerAdapter(HiveChatAdapter());
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(HivePhoneContactsListAdapter());
    Hive.registerAdapter(HiveKeyPairAdapter());
    Hive.registerAdapter(HiveGroupChatAdapter());
    Hive.registerAdapter(HiveGroupChatSaltIVAdapter());

    // await Hive.openBox<User>()
    await Hive.openBox<HiveMessages>(messagesBoxName);
    await Hive.openBox<HiveChat>(chatBoxName);
    await Hive.openBox<HiveGroupChat>(hiveGroupChatsBoxName);
    await Hive.openBox<HivePhoneContactsList>(hiveContactsList);
    await Hive.openBox<HiveKeyPair>(keyPairs);
  }
}
