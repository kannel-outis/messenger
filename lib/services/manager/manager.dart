import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:messenger/models/chat.dart';
import 'package:messenger/models/contacts_model.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/services/manager/hive.manager.dart';
import 'package:messenger/services/offline/hive.db/models/hive_chat.dart';
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

  Future<MqttClient?> login() => throw UnimplementedError();
  Future<void> connectMQTTClient() => throw UnimplementedError();
  void disconnectMQTTClient() => throw UnimplementedError();
  bool subscribe(String topic) => throw UnimplementedError();
  Future<void> publish(String topic, Map<String, dynamic> message) =>
      throw UnimplementedError();

// hive manager
  Future<void> saveChatToDB(OnlineChat chat) => throw UnimplementedError();
  // Future<void> saveGroupChatToDB(GroupChat newGroupChat) =>
  //     throw UnimplementedError();
  void updateAllGroupInfo(HiveGroupChat group) => throw UnimplementedError();
  Future<void> saveMessages(HiveMessages message) => throw UnimplementedError();
  void updateMessageIsRead(HiveMessages message) => throw UnimplementedError();
  List<HiveMessages> getMessagesFromDB(String chatID) =>
      throw UnimplementedError();
  List<HiveChat> loadChatsFromLocalDB() => throw UnimplementedError();
  bool checkIfChatExists(LocalChat hiveChat) => throw UnimplementedError();
  List<List<Map<String, dynamic>>> getContactsListFromDB() =>
      throw UnimplementedError();
  Future<void> saveContactsListToDB(List<List<PhoneContacts>> phoneContact) =>
      throw UnimplementedError();
  void updateUserInHive(User user) => throw UnimplementedError();
  void updateUserOnContactsListInHive(User user, int index) =>
      throw UnimplementedError();
  Future<void> deleteChatAndMessagesFromLocalStorage(HiveChat hiveChat) async =>
      throw UnimplementedError();

  Future<HiveKeyPair?> saveKeyPairs(HiveKeyPair hiveKeyPairs) =>
      throw UnimplementedError();
  MyPrivateKey get getPrivateKeyFromDB => throw UnimplementedError();

  //EncryptClass
  Uint8List rsaEncrypt(RSAPublicKey myPublic, String dataToEncrypt) =>
      throw UnimplementedError();
  Uint8List rsaDecrypt(RSAPrivateKey myPrivate, String cipherText) =>
      throw UnimplementedError();
  AsymmetricKeyPair<MyPublicKey, MyPrivateKey> generateKeyPairs(
          {SecureRandom? secureRandom, int bitLength = 2048}) =>
      throw UnimplementedError();

  String? keyToString({RSAAsymmetricKey? key}) => throw UnimplementedError();
  RSAAsymmetricKey keysFromString({String? key, required bool isPrivate}) =>
      throw UnimplementedError();
}

abstract class ManagerHandler<T extends Manager?> {
  Manager? _manager;

  @protected
  Manager? get manager => _manager;

  @protected
  @mustCallSuper
  Manager? setManager(Manager? newManager) {
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
