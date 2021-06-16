import 'dart:ui';

import 'package:hive/hive.dart';
import 'package:messenger/models/user.dart' as u;
import 'package:messenger/models/user.dart';

import 'hive_group_chat_saltiv.dart';
part 'hive_chat.g.dart';

abstract class LocalChat with HiveObjectMixin {
  // String? name = "";
  final String? id;

  LocalChat({this.id});
}

@HiveType(typeId: 1)
class HiveChat extends LocalChat {
  @HiveField(0)
  final String? chatId;
  @HiveField(1)
  final List<u.User>? participants;

  HiveChat({
    this.chatId,
    this.participants,
  }) : super(id: chatId);

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final HiveChat typedOther = other;
    return typedOther.chatId == chatId &&
        typedOther.participants == participants;
  }

  @override
  String toString() {
    return "${this.chatId} ..... ${this.participants![0].publicKey} .....${this.participants![1].publicKey}";
  }

  @override
  int get hashCode => hashValues(chatId, hashList(participants));
}

@HiveType(typeId: 10)
class HiveGroupChat extends LocalChat {
  @HiveField(0)
  final String? groupID;
  @HiveField(1)
  final String groupName;
  @HiveField(2)
  final String? groupDescription;
  @HiveField(3)
  final String? groupPhotoUrl;
  @HiveField(4)
  final User groupCreator;
  @HiveField(5)
  final DateTime? groupCreationTimeDate;
  @HiveField(6)
  final List<u.User>? groupAdmins;
  @HiveField(7)
  final List<u.User>? participants;
  @HiveField(8)
  final HiveGroupChatSaltIV? hiveGroupChatSaltIV;

  HiveGroupChat({
    this.groupID,
    required this.groupName,
    this.groupDescription,
    this.groupPhotoUrl,
    required this.groupCreator,
    this.groupCreationTimeDate,
    this.groupAdmins,
    required this.participants,
    required this.hiveGroupChatSaltIV,
  }) : super(id: groupID);

  HiveGroupChat copyWith({
    String? groupID,
    String? groupName,
    String? groupDescription,
    String? groupPhotoUrl,
    User? groupCreator,
    DateTime? groupCreationTimeDate,
    List<u.User>? groupAdmins,
    List<u.User>? participants,
    HiveGroupChatSaltIV? hiveGroupChatSaltIV,
  }) {
    return HiveGroupChat(
      groupName: groupName ?? this.groupName,
      groupCreator: groupCreator ?? this.groupCreator,
      participants: participants ?? this.participants,
      hiveGroupChatSaltIV: hiveGroupChatSaltIV ?? this.hiveGroupChatSaltIV,
      groupAdmins: groupAdmins ?? this.groupAdmins,
      groupCreationTimeDate:
          groupCreationTimeDate ?? this.groupCreationTimeDate,
      groupDescription: groupDescription ?? this.groupDescription,
      groupID: groupID ?? this.groupID,
      groupPhotoUrl: groupPhotoUrl ?? this.groupPhotoUrl,
    );
  }

  @override
  int get hashCode => hashValues(groupID, hashList(participants));

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final HiveGroupChat typedOther = other;
    return typedOther.groupID == groupID &&
        typedOther.groupAdmins == groupAdmins &&
        typedOther.groupDescription == groupDescription &&
        typedOther.groupName == groupName &&
        typedOther.groupPhotoUrl == groupPhotoUrl &&
        typedOther.groupCreator == groupCreator &&
        typedOther.participants == participants &&
        typedOther.hiveGroupChatSaltIV == hiveGroupChatSaltIV;
  }
}
