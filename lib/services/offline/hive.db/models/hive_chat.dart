import 'package:hive/hive.dart';
import 'package:messenger/models/user.dart' as u;
import 'package:messenger/models/user.dart';
part 'hive_chat.g.dart';

@HiveType(typeId: 1)
class HiveChat {
  @HiveField(0)
  final String chatId;
  @HiveField(1)
  final List<u.User> participants;

  // List of Map<String, dynamic>

  HiveChat({
    this.chatId,
    this.participants,
  });
}
