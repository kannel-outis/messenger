import 'package:flutter/foundation.dart';

class Chat {
  final String chatID;
  final List<String> participantsIDs;
  final List<Map<String, dynamic>> participants;

  Chat({
    this.chatID,
    this.participants,
    @required this.participantsIDs,
  });

  Map<String, dynamic> toMap() {
    return {
      "chatID": chatID,
      "participantsIDs": participantsIDs,
      "participants": participants,
    };
  }

  Chat.froMap(Map<String, dynamic> map)
      : chatID = map["chatID"],
        participantsIDs = List<String>.from(map["participantsIDs"]),
        participants = List<Map<String, dynamic>>.from(map["participants"]);
}
