import 'package:messenger/models/user.dart';

class Chat {
  final String chatID;
  final List<Map<String, dynamic>> participants;

  Chat({
    this.chatID,
    this.participants,
  });

  Map<String, dynamic> toMap() {
    return {
      "chatID": chatID,
      "participants": participants,
    };
  }

  Chat.froMap(Map<String, dynamic> map)
      : chatID = map["chatID"],
        participants = map["participants"];
}
