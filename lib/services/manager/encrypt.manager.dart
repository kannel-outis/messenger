import 'dart:math';
import 'dart:typed_data';

import 'package:messenger/app/e2e/encryption_class.dart';
import 'package:messenger/services/manager/manager.dart';
import 'package:pointycastle/export.dart';

class EncryptClass extends EncryptionC {
  static EncryptClass? _instance;
  EncryptClass._();

  static EncryptClass get instance {
    if (_instance == null) {
      _instance = EncryptClass._();
    }
    return _instance!;
  }

  @override
  AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateKeyPairs(
      {SecureRandom? secureRandom, int bitLength = 2048}) {
    final keyGen = RSAKeyGenerator()
      ..init(ParametersWithRandom(
          RSAKeyGeneratorParameters(BigInt.parse('65537'), bitLength, 64),
          secureRandom!));
    final keyPair = keyGen.generateKeyPair();

    final RSAPublicKey _publicKey = keyPair.publicKey as RSAPublicKey;
    final RSAPrivateKey _privateKey = keyPair.privateKey as RSAPrivateKey;

    return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(
        _publicKey, _privateKey);
  }

  @override
  Uint8List rsaEncrypt(RSAPublicKey myPublic, Uint8List dataToEncrypt) {
    final encryptor = OAEPEncoding(RSAEngine())
      ..init(true, PublicKeyParameter<RSAPublicKey>(myPublic)); // true=encrypt

    return _processInBlocks(encryptor, dataToEncrypt);
  }

  @override
  Uint8List rsaDecrypt(RSAPrivateKey myPrivate, Uint8List cipherText) {
    final decryptor = OAEPEncoding(RSAEngine())
      ..init(false,
          PrivateKeyParameter<RSAPrivateKey>(myPrivate)); // false=decrypt

    return _processInBlocks(decryptor, cipherText);
  }

  Uint8List _processInBlocks(AsymmetricBlockCipher engine, Uint8List input) {
    final numBlocks = input.length ~/ engine.inputBlockSize +
        ((input.length % engine.inputBlockSize != 0) ? 1 : 0);

    final output = Uint8List(numBlocks * engine.outputBlockSize);

    var inputOffset = 0;
    var outputOffset = 0;
    while (inputOffset < input.length) {
      final chunkSize = (inputOffset + engine.inputBlockSize <= input.length)
          ? engine.inputBlockSize
          : input.length - inputOffset;

      outputOffset += engine.processBlock(
          input, inputOffset, chunkSize, output, outputOffset);

      inputOffset += chunkSize;
    }

    return (output.length == outputOffset)
        ? output
        : output.sublist(0, outputOffset);
  }
}
