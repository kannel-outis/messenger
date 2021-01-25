import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:messenger/services/online/online.dart';
import 'package:messenger/utils/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart';

import '../offline.dart';

class Contacts extends Offline {
  final Online _cloud;

  const Contacts(this._cloud) : super();
  @override
  Future<List<List<Contact>>> listOfRegisteredAndUnregisteredUsers() async {
    List<Contact> _registeredContacts = [];
    List<Contact> _unRegisteredContacts = [];
    await PermissionHandler.checkContactsPermission().then((value) async {
      if (value.isGranted) {
        Iterable<Contact> _getAllContacts = await ContactsService.getContacts();
        List<Contact> _listOfAllContacts = _getAllContacts.toList();

        for (var _contact in _listOfAllContacts) {
          final String _cleanContactNumber = _contact.phones.toList().isNotEmpty
              ? _contact.phones?.toList()[0].value
              : "";
          final QuerySnapshot _result =
              await _cloud.queryMobileNumberORUsername(
                  _cleanNumber(_cleanContactNumber), 'phone');
          final bool _isClean = _contact.phones.toList().isNotEmpty &&
              _result.docs.isNotEmpty &&
              _result.docs[0]?.data()['phone'] ==
                  _contact.phones.toList()[0]?.value;
          if (_isClean) {
            print('Found Something');
            _registeredContacts?.add(_contact);
          } else {
            print('Found Nothing');
            _unRegisteredContacts?.add(_contact);
          }
        }
      }
    });

    return [_registeredContacts, _unRegisteredContacts];
  }

  String _cleanNumber(String number) => number.replaceAll(" ", "");
}
