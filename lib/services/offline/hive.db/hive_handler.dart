import 'package:messenger/models/chat.dart';
import 'package:messenger/services/manager/hive_manager.dart';
import 'package:messenger/services/manager/manager.dart';

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
}
