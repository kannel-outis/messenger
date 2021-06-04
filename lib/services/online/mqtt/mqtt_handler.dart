import 'dart:async';

import 'package:messenger/models/message.dart';
import 'package:messenger/services/manager/mqtt.manager.dart';
import 'package:messenger/services/manager/manager.dart';
import 'package:mqtt_client/mqtt_client.dart';

class MQTThandler extends ManagerHandler<IMQTTManager> {
  MQTThandler() {
    MQTTManager? _newManager = MQTTManager.getInstance(
        // "broker.emqx.io",
        "broker.hivemq.com",
        user.id,
        user.id!.substring(0, 10),
        user.phoneNumbers![0].substring(0, 7));
    setManager(_newManager!);
  }
  // late MqttClient? _client;
  @override
  Manager? setManager(newManager) {
    return super.setManager(newManager as MQTTManager);
  }

  Future<void> connectToClient() async {
    await manager!.connectMQTTClient();
  }

  void disconnectClient() {
    manager!.disconnectMQTTClient();
  }

  Future<MqttClient?> login() async {
    // if (_client != null) return _client!;
    return await manager!.login();
    // return _client!;
  }

  Future<void> publish(String topic, Message message) async {
    manager!.publish(topic, message.toMap());
  }

  Future<bool> subscribe(String? topic) async {
    return manager!.subscribe(topic!);
  }

  @override
  dispose() {
    super.dispose();
  }

  Stream<Map<String, dynamic>?> get messageController =>
      (manager! as MQTTManager).messageStream;
}
