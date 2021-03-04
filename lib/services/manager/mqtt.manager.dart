import 'dart:async';
import 'dart:convert';
// import '../../models/message.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'manager.dart';

class MQTTManager implements Manager {
  final String broker;
  final String clientIdentifier;
  final String username;
  final String password;

  MQTTManager._(
      this.broker, this.clientIdentifier, this.password, this.username);
  static MQTTManager _instance;
  static MQTTManager getInstance(String broker, String clientIdentifier,
      String username, String password) {
    if (_instance == null) {
      _instance = MQTTManager._(broker, clientIdentifier, password, username);
    }
    return _instance;
  }

  MqttServerClient _client;
  bool isConnected;
  StreamController<Map<String, dynamic>> _streamController =
      StreamController<Map<String, dynamic>>.broadcast();

  Future<MqttClient> login() async {
    _client = MqttServerClient(broker, clientIdentifier);
    // _client.logging(on: true);
    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
        .keepAliveFor(60)
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .withWillRetain()
        // .startClean()
        .withWillQos(MqttQos.exactlyOnce);
    _client.connectionMessage = connMess;
    await connectMQTTClient().then((value) {
      _client.onDisconnected = () => print(":::::::disconnected ::::::::");
    });
    return _client;
  }

  Future<void> connectMQTTClient() async {
    try {
      if (_client.connectionStatus.state != MqttConnectionState.connected) {
        await _client.connect(username, password).then((value) {
          if (value.state != MqttConnectionState.connected) {
            disconnectMQTTClient();
            _client.autoReconnect = true;
            _client.onAutoReconnect = () => print('Reconnecting');
            _client.onAutoReconnected = () => print('Reconnected');
            _client.onDisconnected = () => print('discconnected');
          } else {
            print("Connected");
            _client.onConnected = () => isConnected = true;
            _client.updates.listen((event) {
              final MqttPublishMessage payLoad = event[0].payload;
              String data = MqttPublishPayload.bytesToStringAsString(
                  payLoad.payload.message);
              Map<String, dynamic> dataPayload = json.decode(data);
              print(dataPayload);
              _streamController.add(dataPayload);
            });
          }
        });
      }
    } catch (e) {
      disconnectMQTTClient();

      print(
          "something went wrong and there is nothing we can do about it ::: $e");
    }
  }

  void disconnectMQTTClient() {
    _client.disconnect();
  }

  // Future<bool> _checkConnection() async {
  //   await login().then((value) {
  //     if (value == null) {
  //       isConnected = false;
  //     } else {
  //       isConnected = true;
  //     }
  //   });
  //   return isConnected;
  // }

  bool subscribe(String topic) {
    if (_client.connectionStatus.state == MqttConnectionState.connected) {
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

  @override
  void dispose() {
    _streamController.close();
    print("disposed");
  }

  Future<void> publish(String topic, Map<String, dynamic> message) async {
    print(_client.connectionStatus.toString());
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(json.encode(message));
    _client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload);
  }

  Stream<Map<String, dynamic>> get messageStream => _streamController.stream;
}
