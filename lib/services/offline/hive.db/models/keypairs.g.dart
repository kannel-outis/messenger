// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keypairs.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveKeyPairAdapter extends TypeAdapter<HiveKeyPair> {
  @override
  final int typeId = 7;

  @override
  HiveKeyPair read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveKeyPair(
      privateKey: fields[0] as String?,
      publicKey: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveKeyPair obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.privateKey)
      ..writeByte(1)
      ..write(obj.publicKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveKeyPairAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
