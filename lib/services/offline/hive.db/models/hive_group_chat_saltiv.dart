import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 11)
class HiveGroupChatSaltIV {
  @HiveField(0)
  final String? salt;
  @HiveField(1)
  final Uint8List? iv;

  HiveGroupChatSaltIV({
    this.salt,
    this.iv,
  });

  factory HiveGroupChatSaltIV.fromMap(Map<String, String> map) {
    return HiveGroupChatSaltIV(
      iv: Uint8List.fromList(map['iv']!.codeUnits),
      salt: map['salt'],
    );
  }

  @override
  int get hashCode => hashValues(salt, hashList(salt!.codeUnits));

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final HiveGroupChatSaltIV typedOther = other;
    return typedOther.iv == iv && typedOther.salt == salt;
  }
}

class HiveGroupChatSaltIVAdapter extends TypeAdapter<HiveGroupChatSaltIV> {
  @override
  final int typeId = 11;

  @override
  HiveGroupChatSaltIV read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveGroupChatSaltIV(
      salt: String.fromCharCodes(fields[0]),
      iv: Uint8List.fromList((fields[1] as String).codeUnits),
    );
  }

  @override
  void write(BinaryWriter writer, HiveGroupChatSaltIV obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.iv)
      ..writeByte(1)
      ..write(obj.salt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveGroupChatSaltIVAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
