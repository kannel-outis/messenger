import 'package:hive/hive.dart';
import 'package:pointycastle/asymmetric/api.dart';

@HiveType(typeId: 7)
class HiveKeyPair extends HiveObject {
  @HiveField(0)
  final RSAPrivateKey? privateKey;
  @HiveField(1)
  final RSAPublicKey? publicKey;

  HiveKeyPair({this.privateKey, this.publicKey});
}

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
      privateKey: fields[0] as RSAPrivateKey?,
      publicKey: fields[1] as RSAPublicKey?,
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
