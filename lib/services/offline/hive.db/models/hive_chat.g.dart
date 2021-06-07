// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_chat.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveChatAdapter extends TypeAdapter<HiveChat> {
  @override
  final int typeId = 1;

  @override
  HiveChat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveChat(
      chatId: fields[0] as String?,
      participants: (fields[1] as List?)?.cast<User>(),
    );
  }

  @override
  void write(BinaryWriter writer, HiveChat obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.chatId)
      ..writeByte(1)
      ..write(obj.participants);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveChatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

//
class HiveGroupChatAdapter extends TypeAdapter<HiveGroupChat> {
  @override
  final int typeId = 10;

  @override
  HiveGroupChat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveGroupChat(
      groupID: fields[0] as String?,
      groupName: fields[1] as String,
      groupDescription: fields[2] as String?,
      groupPhotoUrl: fields[3] as String?,
      // groupCreator: fields[4] as User,
      groupCreator: fields[4] as User,
      groupCreationTimeDate: fields[5] as DateTime?,
      groupAdmins: (fields[6] as List?)?.cast<User>(),
      participants: (fields[7] as List?)?.cast<User>(),
      hiveGroupChatSaltIV: fields[8] as HiveGroupChatSaltIV?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveGroupChat obj) {
    writer
      // ..writeByte(2)
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.groupID)
      ..writeByte(1)
      ..write(obj.groupName)
      ..writeByte(2)
      ..write(obj.groupDescription)
      ..writeByte(3)
      ..write(obj.groupPhotoUrl)
      ..writeByte(4)
      ..write(obj.groupCreator)
      ..writeByte(5)
      ..write(obj.groupCreationTimeDate)
      ..writeByte(6)
      ..write(obj.groupAdmins)
      ..writeByte(7)
      ..write(obj.participants)
      ..writeByte(8)
      ..write(obj.hiveGroupChatSaltIV);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveGroupChatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
