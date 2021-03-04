import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:messenger/models/chat.dart';
import 'package:messenger/models/contacts_model.dart';
import 'package:messenger/models/message.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/services/manager/hive.manager.dart';
import 'package:messenger/services/offline/hive.db/models/hive_chat.dart';
import 'package:messenger/services/offline/hive.db/models/hive_messages.dart';
import 'package:messenger/services/offline/shared_prefs/shared_prefs.dart';
import 'package:messenger/utils/constants.dart';
import 'package:mqtt_client/mqtt_client.dart';

abstract class Manager {
  void dispose() {}
  @override
  String toString() {
    return '${this.runtimeType}';
  }
}

abstract class ManagerHandler<T extends Manager> {
  T _manager;

  @protected
  T get manager => _manager;

  @protected
  @mustCallSuper
  T setManager(T newManager) {
    if (_manager == null) {
      _manager = newManager;
    }
    return _manager;
  }

  @mustCallSuper
  void dispose() {
    _manager.dispose();
  }

  User get user {
    final _rawData = SharedPrefs.instance.getString(OfflineConstants.MY_DATA);
    return User.fromMap(json.decode(_rawData));
  }

  Future<MqttClient> login() => throw UnimplementedError();
  Future<void> connectToClient() => throw UnimplementedError();
  void disconnectClient() => throw UnimplementedError();
  Future<bool> subscribe(String topic) => throw UnimplementedError();
  Future<void> publish(String topic, Message message) =>
      throw UnimplementedError();

// hive manager
  Future<void> saveChatToDB(Chat chat) => throw UnimplementedError();
  Future<void> saveMessages(Message message) => throw UnimplementedError();
  List<HiveMessages> getMessagesFromDB(String chatID) =>
      throw UnimplementedError();
  List<HiveChat> loadChatsFromDB() => throw UnimplementedError();
  bool checkIfchatExists(HiveChat hiveChat) => throw UnimplementedError();
  List<List<Map<String, dynamic>>> getContactsListFromDB() =>
      throw UnimplementedError();
  Future<void> saveContactsListToDB(List<List<PhoneContacts>> phoneContact) =>
      throw UnimplementedError();
  void updateUserInHive(User user, int index) => throw UnimplementedError();
  void updateUserOnContactsListInHive(User user, int index) =>
      throw UnimplementedError();
  bool get checkIfChatBoxExistAlready {
    if (_manager is HiveManager) {
      var _hiveManager = _manager as HiveManager;
      return _hiveManager.checkIfChatBoxExistAlready;
    } else {
      return false;
    }
  }
}
