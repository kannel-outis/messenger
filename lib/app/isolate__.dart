import 'dart:isolate';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:messenger/models/contacts_model.dart';

mixin ContactsIsolate_<T extends StatefulWidget> on State<T> {
  late final Isolate _isolate;
  late final ReceivePort _receivePort;

  Future<PhoneContacts<RegisteredPhoneContacts, UnRegisteredPhoneContacts>?>
      isolateSpawn(
          PhoneContacts<Map<String, dynamic>, Map<String, dynamic>>
              list) async {
    final completer = Completer<
        PhoneContacts<RegisteredPhoneContacts, UnRegisteredPhoneContacts>>();
    _receivePort = ReceivePort();
    Map map = {
      "list": list,
      "port": _receivePort.sendPort,
    };
    _isolate =
        await Isolate.spawn<Map>(_decodeAndCreateContactsListFromJson, map);
    _receivePort.listen((message) {
      final list = message
          as PhoneContacts<RegisteredPhoneContacts, UnRegisteredPhoneContacts>;

      completer.complete(list);
      print(list.lastList!.length);
    });
    return completer.future;
  }

  static void _decodeAndCreateContactsListFromJson(map) async {
    PhoneContacts<Map<String, dynamic>, Map<String, dynamic>> list =
        map['list'];
    SendPort sendPort = map['port'];
    List<RegisteredPhoneContacts> registered = [];
    List<UnRegisteredPhoneContacts> unRegistered = [];

    for (var e in list.firstList!) {
      final r = RegisteredPhoneContacts.fromMap(e);
      registered.add(r);
    }
    for (var e in list.lastList!) {
      final r = UnRegisteredPhoneContacts.fromMap(e);
      unRegistered.add(r);
    }

    // return _listOfContact = [registered, unRegistered];
    // return _phoneContacts =
    sendPort.send(PhoneContacts(firstList: registered, lastList: unRegistered));
  }

  @override
  void dispose() {
    _isolate.kill();
    super.dispose();
  }
}
