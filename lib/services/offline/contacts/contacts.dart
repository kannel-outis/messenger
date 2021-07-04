import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/models/contacts_model.dart';
import 'package:messenger/services/online/online.dart';
import 'package:messenger/utils/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart';

import '../offline.dart';

class Contacts extends Offline {
  final Online _cloud;

  Contacts(this._cloud);
  @override
  Future<PhoneContacts<RegisteredPhoneContacts, UnRegisteredPhoneContacts>>
      listOfRegisteredAndUnregisteredUsers() async {
    Set<RegisteredPhoneContacts> _registeredContacts = {};
    Set<UnRegisteredPhoneContacts> _unRegisteredContacts = {};
    await PermissionHandler.checkContactsPermission(
            permission: Permission.contacts)
        .then((value) async {
      if (value.isGranted) {
        Iterable<Contact> _getAllContacts = await ContactsService.getContacts();
        List<Contact> _listOfAllContacts = _getAllContacts.toList();

        for (var _contact in _listOfAllContacts) {
          final String _cleanContactNumber =
              _contact.phones!.toList().isNotEmpty
                  ? _contact.phones?.toList()[0].value as String
                  : "";
          final QuerySnapshot _result =
              await _cloud.queryMobileNumberORUsername(
                  _cleanNumber(_cleanContactNumber), 'phoneNumbers');

          final bool _isClean = _contact.phones!.toList().isNotEmpty &&
              _result.docs.isNotEmpty &&
              _result.docs[0]
                  .data()!['phoneNumbers']
                  .contains(_contact.phones!.toList()[0].value);
          if (_isClean) {
            print('Found Something');
            _registeredContacts.add(RegisteredPhoneContacts(
              contact: MyContact(
                name: _contact.displayName,
                name2: _contact.givenName,
                emails: _contact.emails!.map((e) => e.value).toList(),
                phones: _contact.phones!.map((e) => e.value).toList(),
              ),
              user: User.fromMap(_result.docs[0].data()!),
            ));
          } else {
            print('Found Nothing');
            _unRegisteredContacts.add(UnRegisteredPhoneContacts(
              contact: MyContact(
                name: _contact.displayName,
                name2: _contact.givenName,
                emails: _contact.emails!.map((e) => e.value).toList(),
                phones: _contact.phones!.map((e) => e.value).toList(),
              ),
            ));
          }
        }
      }
    });

    // return [_registeredContacts.toList(), _unRegisteredContacts.toList()];
    return PhoneContacts(
      firstList: _registeredContacts.toList(),
      lastList: _unRegisteredContacts.toList(),
    );
  }

  String _cleanNumber(String number) {
    return number.replaceAll(" ", "")..replaceAll("-", "");
  }
}
