// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_messages.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveMessagesAdapter extends TypeAdapter<HiveMessages> {
  @override
  final int typeId = 0;

  @override
  HiveMessages read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveMessages(
      chatID: fields[0] as String?,
      msg: fields[1] as String?,
      messageType: fields[2] as String?,
      dateTime: fields[3] as DateTime?,
      senderID: fields[4] as String?,
      receiverIDs: (fields[5] as List?)?.cast<String>(),
      messageID: fields[6] as String?,
      isRead: fields[7] as bool?,
      isGroup: fields[8] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveMessages obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.chatID)
      ..writeByte(1)
      ..write(obj.msg)
      ..writeByte(2)
      ..write(obj.messageType)
      ..writeByte(3)
      ..write(obj.dateTime)
      ..writeByte(4)
      ..write(obj.senderID)
      ..writeByte(5)
      ..write(obj.receiverIDs)
      ..writeByte(6)
      ..write(obj.messageID)
      ..writeByte(7)
      ..write(obj.isRead)
      ..writeByte(8)
      ..write(obj.isGroup);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveMessagesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
