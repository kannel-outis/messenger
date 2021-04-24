import 'package:hive/hive.dart';
import 'package:messenger/services/offline/hive.db/models/keys.dart';
part 'keypairs.g.dart';

@HiveType(typeId: 7)
class HiveKeyPair extends HiveObject {
  @HiveField(0)
  final MyPrivateKey? privateKey;
  @HiveField(1)
  final MyPublicKey? publicKey;

  HiveKeyPair({this.privateKey, this.publicKey});
}
