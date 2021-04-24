// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keys.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyPublicKeyAdapter extends TypeAdapter<MyPublicKey> {
  @override
  final int typeId = 4;

  @override
  MyPublicKey read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyPublicKey(
      modulus: fields[0] as BigInt?,
      exponent: fields[1] as BigInt?,
    );
  }

  @override
  void write(BinaryWriter writer, MyPublicKey obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.modulus)
      ..writeByte(1)
      ..write(obj.exponent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyPublicKeyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MyPrivateKeyAdapter extends TypeAdapter<MyPrivateKey> {
  @override
  final int typeId = 5;

  @override
  MyPrivateKey read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyPrivateKey(
      modulus: fields[0] as BigInt?,
      p: fields[2] as BigInt?,
      privateExponent: fields[1] as BigInt?,
      q: fields[3] as BigInt?,
    );
  }

  @override
  void write(BinaryWriter writer, MyPrivateKey obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.modulus)
      ..writeByte(1)
      ..write(obj.privateExponent)
      ..writeByte(2)
      ..write(obj.p)
      ..writeByte(3)
      ..write(obj.q);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyPrivateKeyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
