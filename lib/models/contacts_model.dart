import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger/models/user.dart' as model;

abstract class PhoneContacts {
  final Contact contact;

  PhoneContacts(this.contact);
}

class RegisteredPhoneContacts extends PhoneContacts {
  final Contact contact;
  final model.User user;
  RegisteredPhoneContacts({
    @required this.contact,
    @required this.user,
  }) : super(contact);
}

class UnRegisteredPhoneContacts extends PhoneContacts {
  final Contact contact;
  UnRegisteredPhoneContacts({this.contact}) : super(contact);
}
