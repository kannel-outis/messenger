import 'dart:convert';
import 'dart:typed_data';

import 'package:messenger/services/offline/hive.db/models/keys.dart';
import 'package:messenger/services/manager/manager.dart';
import 'package:pointycastle/export.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'dart:developer';

class EncryptClass extends Manager {
  static EncryptClass? _instance;
  EncryptClass._();

  static EncryptClass get instance {
    if (_instance == null) {
      _instance = EncryptClass._();
    }
    return _instance!;
  }

  final _keyHelper = RsaKeyHelper();

  @override
  AsymmetricKeyPair<MyPublicKey, MyPrivateKey> generateKeyPairs(
      {SecureRandom? secureRandom, int bitLength = 2048}) {
    print("Start");
    final keyGen = RSAKeyGenerator()
      ..init(ParametersWithRandom(
          RSAKeyGeneratorParameters(BigInt.parse('65537'), bitLength, 64),
          secureRandom!));
    final keyPair = keyGen.generateKeyPair();

    final RSAPublicKey _publicKey = keyPair.publicKey as RSAPublicKey;
    final RSAPrivateKey _privateKey = keyPair.privateKey as RSAPrivateKey;

    return AsymmetricKeyPair<MyPublicKey, MyPrivateKey>(
        MyPublicKey(
            modulus: _publicKey.modulus!, exponent: _publicKey.exponent!),
        MyPrivateKey(
            modulus: _privateKey.modulus!,
            privateExponent: _privateKey.privateExponent!,
            p: _privateKey.p,
            q: _privateKey.q));
  }

  @override
  Uint8List rsaEncrypt(RSAPublicKey myPublic, String dataToEncrypt) {
    final encryptor = OAEPEncoding(RSAEngine())
      ..init(true, PublicKeyParameter<RSAPublicKey>(myPublic)); // true=encrypt

    return _processInBlocks(
        encryptor, Uint8List.fromList(dataToEncrypt.codeUnits));
  }

  @override
  Uint8List rsaDecrypt(RSAPrivateKey myPrivate, String cipherText) {
    print(cipherText);
    final decryptor = OAEPEncoding(RSAEngine())
      ..init(false,
          PrivateKeyParameter<RSAPrivateKey>(myPrivate)); // false=decrypt

    return _processInBlocks(
        decryptor, Uint8List.fromList(cipherText.codeUnits));
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

  @override
  String? keyToString({RSAAsymmetricKey? key}) {
    if (key is RSAPrivateKey) {
      return _keyHelper
          .removePemHeaderAndFooter(_keyHelper.encodePrivateKeyToPemPKCS1(key));
    } else if (key is RSAPublicKey) {
      return _keyHelper
          .removePemHeaderAndFooter(_keyHelper.encodePublicKeyToPemPKCS1(key));
    }
    return null;
  }

  @override
  RSAAsymmetricKey keysFromString({String? key, required bool isPrivate}) {
    if (isPrivate == true) {
      return _keyHelper.parsePrivateKeyFromPem(key);
    } else {
      return _keyHelper.parsePublicKeyFromPem(key);
    }
  }
}
