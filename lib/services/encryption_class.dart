import 'dart:math';
import 'dart:typed_data';

import 'package:messenger/customs/error/error.dart';
import 'package:messenger/services/offline/hive.db/models/keys.dart';
import 'package:messenger/services/manager/encrypt.manager.dart';
import 'package:messenger/services/manager/manager.dart';
import "package:pointycastle/export.dart";

class EncryptClassHandler extends ManagerHandler<IEncryptManager?> {
  EncryptClassHandler() {
    setManager(EncryptClass.instance);
  }

  Manager? setManager(newManager) {
    return super.setManager(newManager as EncryptClass);
  }

  Uint8List rsaEncrypt(RSAPublicKey myPublic, String dataToEncrypt) {
    try {
      return manager!.rsaEncrypt(myPublic, dataToEncrypt);
    } on MessengerError {
      rethrow;
    }
  }

  Uint8List rsaDecrypt(RSAPrivateKey myPrivate, String cipherText) {
    try {
      return manager!.rsaDecrypt(myPrivate, cipherText);
    } on MessengerError {
      rethrow;
    }
  }

  AsymmetricKeyPair<MyPublicKey, MyPrivateKey> generateKeyPairs(
      {SecureRandom? secureRandom, int bitLength = 2048}) {
    try {
      return manager!.generateKeyPairs(secureRandom: _exampleSecureRandom());
    } catch (e) {
      rethrow;
    }
  }

  Uint8List? generateRandomBytes(int numBytes, {SecureRandom? secureRandom}) {
    return manager!.generateRandomBytes(numBytes,
        secureRandom: secureRandom ?? _exampleSecureRandom());
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

  RSAAsymmetricKey keysFromString({String? key, required bool isPrivate}) {
    return manager!.keysFromString(isPrivate: isPrivate, key: key);
  }

  String? keyToString({RSAAsymmetricKey? key}) {
    return manager!.keyToString(key: key);
  }

  Uint8List aesEncrypt(String plaintext, String passPhrase,
      {required String randomSalt, required Uint8List iv}) {
    return manager!
        .aesEncrypt(plaintext, passPhrase, randomSalt: randomSalt, iv: iv);
  }

  String aesDecrypt(Uint8List cypherStringText, String passPhrase,
      {required String randomSalt, required Uint8List iv}) {
    return manager!.aesDecrypt(cypherStringText, passPhrase,
        randomSalt: randomSalt, iv: iv);
  }
}
