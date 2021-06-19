import "dart:convert";

abstract class OnlineChat {}

class Chat extends OnlineChat {
  final String? chatID;
  final List<String?> participantsIDs;
  final List<Map<String, dynamic>?> participants;

  Chat({
    this.chatID,
    required this.participants,
    required this.participantsIDs,
  });

  Map<String, dynamic> get map {
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

class GroupChat extends OnlineChat {
  final String? groupID;
  final String groupName;
  final String? groupDescription;
  final String? groupPhotoUrl;
  final Map<String, dynamic> groupCreator;
  final DateTime? groupCreationTimeDate;
  final List<Map<String, dynamic>>? groupAdmins;
  final List<String?> participantsIDs;
  final List<Map<String, dynamic>?> participants;
  final List<String> usersEncrytedKey;
  GroupChat(
      {required this.groupName,
      this.groupDescription,
      this.groupPhotoUrl,
      required this.groupCreator,
      this.groupCreationTimeDate,
      this.groupAdmins,
      this.groupID,
      required this.participantsIDs,
      required this.participants,
      required this.usersEncrytedKey});

  // GroupChat.fromMap(Map<String, dynamic> map):

  GroupChat copyWith(
      {String? groupID,
      String? groupName,
      String? groupDescription,
      String? groupPhotoUrl,
      // String? groupCreator,
      Map<String, dynamic>? groupCreator,
      DateTime? groupCreationTimeDate,
      List<Map<String, dynamic>>? groupAdmins,
      List<String?>? participantsIDs,
      List<Map<String, dynamic>?>? participants,
      List<String>? usersEncrytedKey}) {
    return GroupChat(
      groupName: groupName ?? this.groupName,
      groupCreator: groupCreator ?? this.groupCreator,
      participantsIDs: participantsIDs ?? this.participantsIDs,
      participants: participants ?? this.participants,
      groupAdmins: groupAdmins ?? this.groupAdmins,
      groupCreationTimeDate:
          groupCreationTimeDate ?? this.groupCreationTimeDate,
      groupDescription: groupDescription ?? this.groupDescription,
      groupID: groupID ?? this.groupID,
      groupPhotoUrl: groupPhotoUrl ?? this.groupPhotoUrl,
      usersEncrytedKey: usersEncrytedKey ?? this.usersEncrytedKey,
    );
  }

  Map<String, dynamic> get map {
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
      "usersEncrytedKey": usersEncrytedKey,
    };
  }

  GroupChat.froMap(Map<String, dynamic> map)
      : groupID = map["groupID"],
        participantsIDs = List<String>.from(map["participantsIDs"]),
        participants = List<Map<String, dynamic>>.from(map["participants"]),
        groupAdmins = List<Map<String, dynamic>>.from(map["groupAdmins"]),
        groupCreationTimeDate =
            DateTime.parse(map["groupCreationTimeDate"] as String),
        groupCreator = map["groupCreator"],
        groupDescription = map['groupDescription'],
        groupName = map['groupName'],
        groupPhotoUrl = map['groupPhotoUrl'],
        usersEncrytedKey = List<String>.from(map['usersEncrytedKey']);
}
