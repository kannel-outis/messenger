import 'dart:math';
import 'dart:typed_data';

import 'package:messenger/services/manager/encrypt.manager.dart';
import 'package:messenger/services/manager/manager.dart';
import "package:pointycastle/export.dart";

abstract class EncryptionC extends Manager {
  AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateKeyPairs(
      {SecureRandom? secureRandom, int bitLength = 2048});

  Uint8List rsaEncrypt(RSAPublicKey myPublic, Uint8List dataToEncrypt);
  Uint8List rsaDecrypt(RSAPrivateKey myPrivate, Uint8List cipherText);
}

class EncryptClassHandler extends ManagerHandler<EncryptClass> {
  @override
  Uint8List rsaEncrypt(RSAPublicKey myPublic, Uint8List dataToEncrypt) {
    return manager!.rsaEncrypt(myPublic, dataToEncrypt);
  }

  @override
  Uint8List rsaDecrypt(RSAPrivateKey myPrivate, Uint8List cipherText) {
    return manager!.rsaDecrypt(myPrivate, cipherText);
  }

  @override
  AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateKeyPairs(
      {SecureRandom? secureRandom, int bitLength = 2048}) {
    return manager!.generateKeyPairs(
        secureRandom: secureRandom ?? super.exampleSecureRandom());
  }
}
