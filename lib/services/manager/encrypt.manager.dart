import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:messenger/customs/error/error.dart';
import 'package:messenger/services/offline/hive.db/models/keys.dart';
import 'package:messenger/services/manager/manager.dart';
import 'package:pointycastle/export.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';

class EncryptClass implements IEncryptManager {
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
    try {
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
    } catch (e) {
      throw MessengerError("Something went wrong" + " ${e.toString()}");
    }
  }

  @override
  Uint8List rsaEncrypt(RSAPublicKey myPublic, String dataToEncrypt) {
    try {
      final encryptor = OAEPEncoding(RSAEngine())
        ..init(
            true, PublicKeyParameter<RSAPublicKey>(myPublic)); // true=encrypt

      return _processInBlocks(
          encryptor, Uint8List.fromList(dataToEncrypt.codeUnits));
    } catch (e) {
      throw MessengerError("Something went wrong" + " ${e.toString()}");
    }
  }

  @override
  Uint8List rsaDecrypt(RSAPrivateKey myPrivate, String cipherText) {
    try {
      print(cipherText);
      final decryptor = OAEPEncoding(RSAEngine())
        ..init(false,
            PrivateKeyParameter<RSAPrivateKey>(myPrivate)); // false=decrypt

      return _processInBlocks(
          decryptor, Uint8List.fromList(cipherText.codeUnits));
    } catch (e) {
      throw MessengerError("Something went wrong" + " ${e.toString()}");
    }
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

  // ///////////////////////////////////////////////
  Uint8List _aesCbcEncrypt(
      Uint8List key, Uint8List iv, Uint8List paddedPlaintext) {
    final cbc = CBCBlockCipher(AESFastEngine())
      ..init(true, ParametersWithIV(KeyParameter(key), iv));

    final cipherText = Uint8List(paddedPlaintext.length);

    var offset = 0;
    while (offset < paddedPlaintext.length) {
      offset += cbc.processBlock(paddedPlaintext, offset, cipherText, offset);
    }
    assert(offset == paddedPlaintext.length);

    return cipherText;
  }

  Uint8List _aesCbcDecrypt(Uint8List key, Uint8List iv, Uint8List cipherText) {
    final cbc = CBCBlockCipher(AESFastEngine())
      ..init(false, ParametersWithIV(KeyParameter(key), iv));

    final paddedPlainText = Uint8List(cipherText.length);

    var offset = 0;
    while (offset < cipherText.length) {
      offset += cbc.processBlock(cipherText, offset, paddedPlainText, offset);
    }
    assert(offset == cipherText.length);

    return paddedPlainText;
  }

  Uint8List _pad(Uint8List bytes, int blockSize) {
    final padLength = blockSize - (bytes.length % blockSize);

    final padded = Uint8List(bytes.length + padLength)..setAll(0, bytes);
    PKCS7Padding().addPadding(padded, bytes.length);

    return padded;
  }

  Uint8List _unpad(Uint8List padded) =>
      padded.sublist(0, padded.length - PKCS7Padding().padCount(padded));

  Uint8List _passphraseToKey(String passPhrase,
      {String salt = '', int iterations = 30000, required int bitLength}) {
    final numBytes = bitLength ~/ 8;

    final kd = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64))
      ..init(Pbkdf2Parameters(
          utf8.encode(salt) as Uint8List, iterations, numBytes));

    return kd.process(utf8.encode(passPhrase) as Uint8List);
  }

  Uint8List? _generateRandomBytes(int numBytes, {SecureRandom? secureRandom}) {
    if (secureRandom == null) {
      secureRandom = FortunaRandom();

      final seedSource = Random.secure();
      final seeds = <int>[];
      for (var i = 0; i < 32; i++) {
        seeds.add(seedSource.nextInt(255));
      }
      secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));
    }

    final iv = secureRandom.nextBytes(numBytes);
    return iv;
  }

  @override
  Uint8List aesEncrypt(String plaintext, String passPhrase) {
    final randomSalt = latin1.decode(_generateRandomBytes(32)!);

    final iv = _generateRandomBytes(128 ~/ 8)!;
    return _aesCbcEncrypt(
        _passphraseToKey(passPhrase, salt: randomSalt, bitLength: 256),
        iv,
        _pad(utf8.encode(plaintext) as Uint8List, 128));
  }

  @override
  String aesDecrypt(Uint8List cypherStringText, String passPhrase) {
    final randomSalt = latin1.decode(_generateRandomBytes(32)!);

    final iv = _generateRandomBytes(128 ~/ 8)!;

    final decrypted = _aesCbcDecrypt(
        _passphraseToKey(passPhrase, salt: randomSalt, bitLength: 256),
        iv,
        cypherStringText);
    final decryptedBytes = _unpad(decrypted);
    return utf8.decode(decryptedBytes);
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
