import 'dart:async';

import 'package:messenger/models/message.dart';
import 'package:messenger/services/manager/mqtt.manager.dart';
import 'package:messenger/services/manager/manager.dart';
import 'package:mqtt_client/mqtt_client.dart';

class MQTThandler extends ManagerHandler<MQTTManager?> {
  MQTThandler() {
    MQTTManager? _newManager = MQTTManager.getInstance(
        "broker.emqx.io",
        user.id,
        user.id!.substring(0, 10),
        user.phoneNumbers![0].substring(0, 7));
    setManager(_newManager);
  }
  @override
  MQTTManager? setManager(MQTTManager? newManager) {
    return super.setManager(newManager);
  }

  @override
  Future<void> connectToClient() async {
    await manager!.connectMQTTClient();
  }

  @override
  void disconnectClient() {
    manager!.disconnectMQTTClient();
  }

  @override
  Future<MqttClient> login() async {
    return await manager!.login();
  }

  @override
  Future<void> publish(String topic, Message message) async {
    manager!.publish(topic, message.toMap());
  }

  @override
  Future<bool> subscribe(String? topic) async {
    return manager!.subscribe(topic);
  }

  @override
  dispose() {
    super.dispose();
  }

  Stream<Map<String, dynamic>?> get messageController => manager!.messageStream;
}
