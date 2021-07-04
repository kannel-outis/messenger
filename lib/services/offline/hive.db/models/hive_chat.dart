import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:messenger/models/user.dart' as u;
import 'package:messenger/models/user.dart';
import 'package:messenger/services/offline/shared_prefs/shared_prefs.dart';

import 'hive_group_chat_saltiv.dart';
part 'hive_chat.g.dart';

var _user = SharedPrefs.instance.user;

abstract class LocalChat with HiveObjectMixin {
  // String? name = "";
  String? id;
  String? photoUrl;
  List<User>? participants;
  String? name;
  DateTime? lastMessageUpdateTime;

  LocalChat(
      {this.id,
      this.name,
      this.participants,
      this.photoUrl,
      @required this.lastMessageUpdateTime});
}

@HiveType(typeId: 1)
class HiveChat extends LocalChat {
  @HiveField(0)
  final String? chatId;
  @HiveField(1)
  final List<u.User>? participants;
  @HiveField(2)
  DateTime? lastMessageUpdateTime;

  void setSuper() {
    super.id = chatId;
    super.name = participants!
        .where((element) => _user.id != element.id)
        .single
        .userName;
    super.participants = participants;
    super.photoUrl = participants!
        .where((element) => _user.id != element.id)
        .single
        .photoUrl;
    super.lastMessageUpdateTime = lastMessageUpdateTime!;
  }

  HiveChat({
    this.chatId,
    this.participants,
    required this.lastMessageUpdateTime,
  }) : super(
          id: chatId,
          name: participants!
              .where((element) => _user.id != element.id)
              .single
              .userName,
          participants: participants,
          photoUrl: participants
              .where((element) => _user.id != element.id)
              .single
              .photoUrl,
          lastMessageUpdateTime: lastMessageUpdateTime,
        );

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
  List<u.User>? groupAdmins;
  @HiveField(7)
  final List<u.User>? participants;

  @HiveField(8)
  final HiveGroupChatSaltIV? hiveGroupChatSaltIV;
  @HiveField(9)
  DateTime? lastMessageUpdateTime;

  void setSuper() {
    super.id = groupID;
    super.name = groupName;
    super.participants = participants;
    super.photoUrl = groupPhotoUrl;
    super.lastMessageUpdateTime = lastMessageUpdateTime;
  }

  HiveGroupChat({
    this.groupID,
    required this.groupName,
    this.groupDescription,
    this.groupPhotoUrl,
    required this.groupCreator,
    this.groupCreationTimeDate,
    this.groupAdmins,
    required this.lastMessageUpdateTime,
    required this.participants,
    required this.hiveGroupChatSaltIV,
  }) : super(
          id: groupID,
          name: groupName,
          participants: participants,
          photoUrl: groupPhotoUrl,
          lastMessageUpdateTime: lastMessageUpdateTime,
        );

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
    DateTime? lastMessageUpdateTime,
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
      lastMessageUpdateTime: lastMessageUpdateTime,
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
