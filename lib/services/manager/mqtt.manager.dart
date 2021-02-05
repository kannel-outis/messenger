import 'dart:convert';

import 'package:flutter/foundation.dart';
import '../../models/message.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'manager.dart';

class MQTTManager implements Manager {
  final String broker;
  final String clientIdentifier;
  final String username;
  final String password;

  MQTTManager(
      {@required this.broker,
      @required this.clientIdentifier,
      @required this.username,
      @required this.password});
  MqttServerClient _client;

  Future<MqttClient> login() async {
    _client = MqttServerClient(broker, clientIdentifier);
    _client.logging(on: true);
    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
        .keepAliveFor(60)
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .withWillRetain()
        .withWillQos(MqttQos.exactlyOnce);
    _client.connectionMessage = connMess;
    await connectMQTTClient();

    return _client;
  }

  Future<void> connectMQTTClient() async {
    try {
      if (_client.connectionStatus.state != MqttConnectionState.connected) {
        await _client.connect(username, password).then((value) {
          if (value.state == MqttConnectionState.disconnected &&
              value.state == MqttConnectionState.faulted) {
            print('::::::::::::::::::::::::::::::');
            _client.autoReconnect = true;
            _client.onAutoReconnect = () => print('Reconnecting');
            _client.onAutoReconnected = () => print('Reconnected');
          }
        });
      }
    } catch (e) {
      print(
          "something went wrong and there is nothing we can do about it ::: $e");
    }
  }

  void disconnectMQTTClient() {
    _client.disconnect();
  }

  Future<bool> _checkConnection() async {
    bool isConnected;
    await login().then((value) {
      if (value == null) {
        isConnected = false;
      } else {
        isConnected = true;
      }
    });
    return isConnected;
  }

  Future<bool> subscribe(String topic) async {
    if (await _checkConnection() == true &&
        _client.connectionStatus.state == MqttConnectionState.connected) {
      _client.onConnected = () {
        print('connected');
      };
      _client.onDisconnected = () {
        print('Disconnected');
      };
      _client.onSubscribed = (topic) => print(topic);

      _client.subscribe(topic, MqttQos.exactlyOnce);
      return true;
    } else {
      return false;
    }
  }

  Future<void> publish(String topic, Message message) async {
    // _client = MqttServerClient(broker, clientIdentifier);
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    Map<String, dynamic> _message = message.toMap();
    builder.addString(json.encode(_message));
    print(':::::::::::::::::' + json.encode(_message));
    // if (await _checkConnection()) {
    _client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload);
    // } else {
    // print('null');
    // }
  }
}
