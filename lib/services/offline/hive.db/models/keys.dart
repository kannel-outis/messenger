import 'package:pointycastle/asymmetric/api.dart';
import 'package:hive/hive.dart';
part 'keys.g.dart';

@HiveType(typeId: 20)
class MyPublicKey extends RSAPublicKey with HiveObjectMixin {
  @HiveField(0)
  final BigInt? modulus;
  @HiveField(1)
  final BigInt? exponent;
  MyPublicKey({this.modulus, this.exponent}) : super(modulus!, exponent!);
}

@HiveType(typeId: 21)
class MyPrivateKey extends RSAPrivateKey with HiveObjectMixin {
  @HiveField(0)
  final BigInt? modulus;
  @HiveField(1)
  final BigInt? privateExponent;
  @HiveField(2)
  final BigInt? p;
  @HiveField(3)
  final BigInt? q;
  MyPrivateKey({this.modulus, this.p, this.privateExponent, this.q})
      : super(modulus!, privateExponent!, p, q);
}

// class MyPublicKeyAdapter extends TypeAdapter<MyPublicKey> {
//   @override
//   final int typeId = 20;

//   @override
//   MyPublicKey read(BinaryReader reader) {
//     final numOfFields = reader.readByte();
//     final fields = <int, dynamic>{
//       for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return MyPublicKey(
//         modulus: fields[0] as BigInt?, exponent: fields[1] as BigInt?);
//   }

//   @override
//   void write(BinaryWriter writer, MyPublicKey obj) {
//     writer
//       ..writeByte(2)
//       ..writeByte(0)
//       ..write(obj.modulus)
//       ..writeByte(1)
//       ..write(obj.exponent);
//   }

//   @override
//   int get hashCode => typeId.hashCode;

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is MyPublicKeyAdapter &&
//           runtimeType == other.runtimeType &&
//           typeId == other.typeId;
// }

// class MyPrivateKeyAdapter extends TypeAdapter<MyPrivateKey> {
//   @override
//   final int typeId = 21;

//   @override
//   MyPrivateKey read(BinaryReader reader) {
//     final numOfFields = reader.readByte();
//     final fields = <int, dynamic>{
//       for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return MyPrivateKey(
//         modulus: fields[0] as BigInt?,
//         privateExponent: fields[1] as BigInt?,
//         p: fields[2] as BigInt?,
//         q: fields[3] as BigInt?);
//   }

//   @override
//   void write(BinaryWriter writer, MyPrivateKey obj) {
//     writer
//       ..writeByte(4)
//       ..writeByte(0)
//       ..write(obj.modulus)
//       ..writeByte(1)
//       ..write(obj.privateExponent)
//       ..writeByte(2)
//       ..write(obj.p)
//       ..writeByte(3)
//       ..write(obj.q);
//   }

//   @override
//   int get hashCode => typeId.hashCode;

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is MyPrivateKeyAdapter &&
//           runtimeType == other.runtimeType &&
//           typeId == other.typeId;
// }
