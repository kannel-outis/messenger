import 'dart:isolate';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:messenger/models/contacts_model.dart';

mixin ContactsIsolate_C<T extends StatefulWidget> on State<T> {
  Isolate? _isolate;
  ReceivePort? _receivePort;
  bool refreshing = false;

  Future<PhoneContacts<RegisteredPhoneContacts, UnRegisteredPhoneContacts?>?>
      isolateSpawn(
          PhoneContacts<Map<String, dynamic>, Map<String, dynamic>> list,
          bool firstListOnly) async {
    final completer = Completer<
        PhoneContacts<RegisteredPhoneContacts, UnRegisteredPhoneContacts>>();
    final completer2 = Completer<
        PhoneContacts<RegisteredPhoneContacts, UnRegisteredPhoneContacts?>>();
    _receivePort = ReceivePort();
    Map map = {
      "list": list,
      "port": _receivePort!.sendPort,
      "firstListOnly": firstListOnly,
    };
    _isolate =
        await Isolate.spawn<Map>(_decodeAndCreateContactsListFromJson, map);
    _receivePort!.listen((message) {
      if (!firstListOnly) {
        final list = message as PhoneContacts<RegisteredPhoneContacts,
            UnRegisteredPhoneContacts>;
        completer.complete(list);
        print(list.lastList!.length);
      }
      final list = message
          as PhoneContacts<RegisteredPhoneContacts, UnRegisteredPhoneContacts?>;

      completer2.complete(list);

      print(list.firstList!.length);
    });

    return !firstListOnly ? completer.future : completer2.future;
  }

  static void _decodeAndCreateContactsListFromJson(map) async {
    PhoneContacts<Map<String, dynamic>, Map<String, dynamic>> list =
        map['list'];
    SendPort sendPort = map['port'];
    bool firstListOnly = map['firstListOnly'];
    List<RegisteredPhoneContacts> registered = [];
    List<UnRegisteredPhoneContacts> unRegistered = [];

    if (!firstListOnly) {
      for (var e in list.firstList!) {
        final r = RegisteredPhoneContacts.fromMap(e);
        registered.add(r);
      }
      for (var e in list.lastList!) {
        final r = UnRegisteredPhoneContacts.fromMap(e);
        unRegistered.add(r);
      }
      sendPort
          .send(PhoneContacts(firstList: registered, lastList: unRegistered));
    } else {
      print("start");
      for (var e in list.firstList!) {
        final r = RegisteredPhoneContacts.fromMap(e);
        registered.add(r);
      }
      sendPort.send(
          PhoneContacts<RegisteredPhoneContacts, UnRegisteredPhoneContacts>(
              firstList: registered, lastList: null));
    }
  }

  void disposeIsolate() {
    _isolate!.kill();
  }
}

mixin ContactsIsolate_CC {
  Isolate? _isolate;
  ReceivePort? _receivePort;

  Future<PhoneContacts<RegisteredPhoneContacts, UnRegisteredPhoneContacts?>?>
      isolateSpawn(
          PhoneContacts<Map<String, dynamic>, Map<String, dynamic>>
              list) async {
    final completer = Completer<
        PhoneContacts<RegisteredPhoneContacts, UnRegisteredPhoneContacts?>>();
    _receivePort = ReceivePort();
    Map map = {
      "list": list,
      "port": _receivePort!.sendPort,
    };
    _isolate =
        await Isolate.spawn<Map>(_decodeAndCreateContactsListFromJson, map);
    _receivePort!.listen((message) {
      final list = message
          as PhoneContacts<RegisteredPhoneContacts, UnRegisteredPhoneContacts?>;

      completer.complete(list);

      print(list.firstList!.length);
    });
    return completer.future;
  }

  static void _decodeAndCreateContactsListFromJson(map) async {
    PhoneContacts<Map<String, dynamic>, Map<String, dynamic>> list =
        map['list'];
    SendPort sendPort = map['port'];
    List<RegisteredPhoneContacts> registered = [];

    print("start");
    for (var e in list.firstList!) {
      final r = RegisteredPhoneContacts.fromMap(e);
      registered.add(r);
    }
    sendPort.send(
        PhoneContacts<RegisteredPhoneContacts, UnRegisteredPhoneContacts>(
            firstList: registered, lastList: null));
  }

  void disposeIsolate() {
    _isolate!.kill();
  }
}
