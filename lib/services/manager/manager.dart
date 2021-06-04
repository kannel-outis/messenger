import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:messenger/models/chat.dart';
import 'package:messenger/models/contacts_model.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/services/manager/hive.manager.dart';
import 'package:messenger/services/offline/hive.db/models/hive_chat.dart';
import 'package:messenger/services/offline/hive.db/models/hive_group_chat_saltiv.dart';
import 'package:messenger/services/offline/hive.db/models/hive_messages.dart';
import 'package:messenger/services/offline/hive.db/models/keypairs.dart';
import 'package:messenger/services/offline/hive.db/models/keys.dart';
import 'package:messenger/services/offline/shared_prefs/shared_prefs.dart';
import 'package:messenger/utils/constants.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:pointycastle/export.dart';

abstract class Manager {
  void dispose() {}
  @override
  String toString() {
    return '${this.runtimeType}';
  }

// hive manager

  //EncryptClass

}

abstract class IEncryptManager extends Manager {
  // RSA Encyption for one-on-one Chats
  Uint8List rsaEncrypt(RSAPublicKey myPublic, String dataToEncrypt);
  Uint8List rsaDecrypt(RSAPrivateKey myPrivate, String cipherText);
  AsymmetricKeyPair<MyPublicKey, MyPrivateKey> generateKeyPairs(
      {SecureRandom? secureRandom, int bitLength = 2048});

  String? keyToString({RSAAsymmetricKey? key});
  RSAAsymmetricKey keysFromString({String? key, required bool isPrivate});

  // AES-CBC encryption for group chats
  Uint8List aesEncrypt(String plaintext, String passPhrase,
      {required String randomSalt, required Uint8List iv});
  String aesDecrypt(Uint8List cypherStringText, String passPhrase,
      {required String randomSalt, required Uint8List iv});
  Uint8List? generateRandomBytes(int numBytes, {SecureRandom? secureRandom});
}

abstract class IMQTTManager extends Manager {
  Future<MqttClient?> login();
  Future<void> connectMQTTClient();
  void disconnectMQTTClient();
  bool subscribe(String topic);
  Future<void> publish(String topic, Map<String, dynamic> message);
}

abstract class IHiveManager extends Manager {
  Future<void> saveChatToDB(OnlineChat chat,
      {HiveGroupChatSaltIV? hiveGroupChatSaltIV});
  void updateAllGroupInfo(HiveGroupChat group);
  Future<void> saveMessages(HiveMessages message);
  LocalChat loadSingleChat(String id, {bool? isGroupChat});
  void updateMessageIsRead(HiveMessages message);
  List<HiveMessages> getMessagesFromDB(String chatID);
  List<HiveChat> loadChatsFromLocalDB();
  bool checkIfChatExists(LocalChat hiveChat);
  List<List<Map<String, dynamic>>> getContactsListFromDB();
  Future<void> saveContactsListToDB(List<List<PhoneContacts>> phoneContact);
  void updateUserInHive(User user);
  void updateUserOnContactsListInHive(User user, int index);
  Future<void> deleteChatAndMessagesFromLocalStorage(LocalChat hiveChat);

  Future<HiveKeyPair?> saveKeyPairs(HiveKeyPair hiveKeyPairs);
  MyPrivateKey get getPrivateKeyFromDB => throw UnimplementedError();
}

abstract class ManagerHandler<T extends Manager?> {
  T? _manager;

  @protected
  T? get manager => _manager;

  @protected
  @mustCallSuper
  Manager? setManager(T? newManager) {
    if (_manager == null) {
      _manager = newManager;
    }
    return _manager;
  }

  @mustCallSuper
  void dispose() {
    _manager!.dispose();
  }

  User get user {
    final _rawData = SharedPrefs.instance.getString(OfflineConstants.MY_DATA);
    return User.fromMap(json.decode(_rawData!));
  }

  bool get checkIfChatBoxExistAlready {
    if (_manager is HiveManager) {
      var _hiveManager = _manager as HiveManager;
      return _hiveManager.checkIfChatBoxExistAlready;
    } else {
      return false;
    }
  }
}
