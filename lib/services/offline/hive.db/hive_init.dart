import 'package:hive/hive.dart';
import 'package:messenger/models/contacts_model.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/services/offline/hive.db/models/hive_chat.dart';
import 'package:messenger/services/offline/hive.db/models/hive_messages.dart';
import 'package:messenger/services/offline/hive.db/models/keypairs.dart';
import 'package:messenger/services/offline/hive.db/models/keys.dart';
import 'package:path_provider/path_provider.dart';

class HiveInit {
  static String messagesBoxName = "MessagesBox";
  static String chatBoxName = "HiveChatBox";
  static String hiveContactsList = "HiveContactsList";
  static String keyPairs = "KeyPairs";

  static Future hiveInit() async {
    final documentDir = await getApplicationDocumentsDirectory();
    Hive.init(documentDir.path);
    Hive.ignoreTypeId<MyPrivateKey>(5);
    Hive.ignoreTypeId<MyPublicKey>(4);
    Hive.registerAdapter(HiveMessagesAdapter());
    Hive.registerAdapter(HiveChatAdapter());
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(HivePhoneContactsListAdapter());
    // Hive.registerAdapter(MyPrivateKeyAdapter());
    // Hive.registerAdapter(MyPublicKeyAdapter());
    Hive.registerAdapter(HiveKeyPairAdapter());

    // await Hive.openBox<User>()
    await Hive.openBox<HiveMessages>(messagesBoxName);
    await Hive.openBox<HiveChat>(chatBoxName);
    await Hive.openBox<HivePhoneContactsList>(hiveContactsList);
    await Hive.openBox<HiveKeyPair>(keyPairs);
  }
}
