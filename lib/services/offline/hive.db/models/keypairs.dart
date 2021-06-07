import 'package:hive/hive.dart';
part 'keypairs.g.dart';

@HiveType(typeId: 7)
class HiveKeyPair extends HiveObject {
  @HiveField(0)
  final String? privateKey;
  @HiveField(1)
  final String? publicKey;

  HiveKeyPair({this.privateKey, this.publicKey});
}
