import 'dart:math';
import 'dart:typed_data';

import 'package:messenger/services/offline/hive.db/models/keys.dart';
import 'package:messenger/services/manager/encrypt.manager.dart';
import 'package:messenger/services/manager/manager.dart';
import "package:pointycastle/export.dart";

abstract class EncryptionC {
  AsymmetricKeyPair<MyPublicKey, MyPrivateKey> generateKeyPairs(
      {SecureRandom? secureRandom, int bitLength = 2048});

  Uint8List rsaEncrypt(RSAPublicKey myPublic, Uint8List dataToEncrypt);
  Uint8List rsaDecrypt(RSAPrivateKey myPrivate, Uint8List cipherText);
  String? keyToString({RSAAsymmetricKey? key});
}

class EncryptClassHandler extends ManagerHandler<EncryptClass?> {
  EncryptClassHandler() {
    setManager(EncryptClass.instance);
  }
  @override
  EncryptClass? setManager(EncryptClass? newManager) {
    return super.setManager(newManager);
  }

  @override
  Uint8List rsaEncrypt(RSAPublicKey myPublic, Uint8List dataToEncrypt) {
    return manager!.rsaEncrypt(myPublic, dataToEncrypt);
  }

  @override
  Uint8List rsaDecrypt(RSAPrivateKey myPrivate, Uint8List cipherText) {
    return manager!.rsaDecrypt(myPrivate, cipherText);
  }

  @override
  AsymmetricKeyPair<MyPublicKey, MyPrivateKey> generateKeyPairs(
      {SecureRandom? secureRandom, int bitLength = 2048}) {
    return manager!.generateKeyPairs(secureRandom: _exampleSecureRandom());
  }

  SecureRandom _exampleSecureRandom() {
    final secureRandom = FortunaRandom();

    final seedSource = Random.secure();
    final seeds = <int>[];
    for (int i = 0; i < 32; i++) {
      seeds.add(seedSource.nextInt(255));
    }
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));

    return secureRandom;
  }

  @override
  String? keyToString({RSAAsymmetricKey? key}) {
    return manager!.keyToString(key: key);
  }
}
