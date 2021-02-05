import 'package:flutter/foundation.dart';
import 'package:messenger/models/message.dart';
import 'package:messenger/services/manager/mqtt.manager.dart';
import 'package:messenger/services/manager/manager.dart';
import 'package:mqtt_client/mqtt_client.dart';

class MQTThandler extends ManagerHandler<MQTTManager> {
  final String identifier;
  MQTThandler({
    @required this.identifier,
  }) {
    MQTTManager _newManager =
        MQTTManager(broker: "broker.emqx.io", clientIdentifier: identifier);
    setManager(_newManager);
  }
  @override
  MQTTManager setManager(MQTTManager newManager) {
    return super.setManager(newManager);
  }

  @override
  Future<void> connectToClient(String username, String password) async {
    await manager.connectMQTTClient(username, password);
  }

  @override
  void disconnectClient() {
    manager.disconnectMQTTClient();
  }

  @override
  Future<MqttClient> login() async {
    return await manager.login();
  }

  @override
  Future<void> publish(String topic, Message message) async {
    manager.publish(topic, message);
  }

  @override
  Future<bool> subscribe(String topic) async {
    return manager.subscribe(topic);
  }
}
