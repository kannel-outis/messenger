import 'package:hive/hive.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/services/offline/hive.db/models/hive_chat.dart';
import 'package:messenger/services/offline/hive.db/models/hive_messages.dart';
import 'package:path_provider/path_provider.dart';

class HiveInit {
  static String messagesBoxName = "MessagesBox";
  static String chatBoxName = "HiveChatBox";

  static Future hiveInit() async {
    final documentDir = await getApplicationDocumentsDirectory();
    Hive.init(documentDir.path);
    Hive.registerAdapter(HiveMessagesAdapter());
    Hive.registerAdapter(HiveChatAdapter());
    Hive.registerAdapter(UserAdapter());
    // await Hive.openBox<User>()
    await Hive.openBox<HiveMessages>(messagesBoxName);
    await Hive.openBox<HiveChat>(chatBoxName);
  }
}