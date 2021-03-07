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
