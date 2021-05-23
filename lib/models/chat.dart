class Chat {
  final String? chatID;
  final List<String?> participantsIDs;
  final List<Map<String, dynamic>?> participants;

  Chat({
    this.chatID,
    required this.participants,
    required this.participantsIDs,
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

class GroupChat {
  final String? groupID;
  final String groupName;
  final String? groupDescription;
  final String? groupPhotoUrl;
  final String groupCreator;
  final DateTime? groupCreationTimeDate;
  final List<String>? groupAdmins;
  final List<String?> participantsIDs;
  final List<Map<String, dynamic>?> participants;
  GroupChat(
      {required this.groupName,
      this.groupDescription,
      this.groupPhotoUrl,
      required this.groupCreator,
      this.groupCreationTimeDate,
      this.groupAdmins,
      this.groupID,
      required this.participantsIDs,
      required this.participants});

  // GroupChat.fromMap(Map<String, dynamic> map):

  Map<String, dynamic> toMap() {
    return {
      "groupID": groupID,
      "participantsIDs": participantsIDs,
      "participants": participants,
      "groupName": groupName,
      "groupPhotoUrl": groupPhotoUrl,
      "groupAdmins": groupAdmins,
      "groupCreator": groupCreator,
      "groupCreationTimeDate": groupCreationTimeDate.toString(),
      "groupDescription": groupDescription,
    };
  }

  GroupChat.froMap(Map<String, dynamic> map)
      : groupID = map["groupID"],
        participantsIDs = List<String>.from(map["participantsIDs"]),
        participants = List<Map<String, dynamic>>.from(map["participants"]),
        groupAdmins = List<String>.from(map["groupAdmins"]),
        groupCreationTimeDate =
            DateTime.parse(map["groupCreationTimeDate"] as String),
        groupCreator = map["groupCreator"],
        groupDescription = map['groupDescription'],
        groupName = map['groupName'],
        groupPhotoUrl = map['groupPhotoUrl'];
}
