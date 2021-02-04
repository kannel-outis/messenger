import 'package:flutter/foundation.dart';
import 'package:messenger/models/chat.dart';
import 'package:messenger/models/message.dart';
import 'package:messenger/services/offline/hive.db/models/hive_chat.dart';
import 'package:mqtt_client/mqtt_client.dart';

abstract class Manager {
  @override
  String toString() {
    return '${this.runtimeType}';
  }
}

abstract class ManagerHandler<T extends Manager> {
  T _manager;

  // MQTTOnline(this._manager);
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

  Future<MqttClient> login() => throw UnimplementedError();
  Future<void> connectToClient(String username, String password) =>
      throw UnimplementedError();
  void disconnectClient() => throw UnimplementedError();
  Future<bool> subscribe(String topic) => throw UnimplementedError();
  Future<void> publish(String topic, Message message) =>
      throw UnimplementedError();
// hive manager
  Future<void> saveChatToDB(Chat chat) => throw UnimplementedError();
  Future<void> saveMessages(Message message) => throw UnimplementedError();
  List<Message> getMessagesFromDB(String chatID) => throw UnimplementedError();
  List<HiveChat> loadChatsFromDB() => throw UnimplementedError();
}
