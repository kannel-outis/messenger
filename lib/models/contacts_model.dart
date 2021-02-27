import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:messenger/models/user.dart' as model;
part 'contacts_model.g.dart';

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

  Map<String, Map<String, dynamic>> toMap() {
    print(user.toMap());
    return {
      'contact': contact.toMap().cast<String, dynamic>(),
      'user': user.toMap(),
    };
  }

  static RegisteredPhoneContacts fromMap(Map<String, dynamic> map) {
    final newMap = map
        .map((key, value) => MapEntry(key, Map<String, dynamic>.from(value)));

    return RegisteredPhoneContacts(
      contact: Contact.fromMap(
        newMap['contact'],
      ),
      user: model.User.fromMap(
        newMap['user'],
      ),
    );
  }
}

class UnRegisteredPhoneContacts extends PhoneContacts {
  final Contact contact;
  UnRegisteredPhoneContacts({this.contact}) : super(contact);

  Map<String, Map<String, dynamic>> toMap() {
    return {
      'contact': contact.toMap().cast<String, dynamic>(),
    };
  }

  static UnRegisteredPhoneContacts fromMap(Map<String, dynamic> map) {
    final newMap = map
        .map((key, value) => MapEntry(key, Map<String, dynamic>.from(value)));
    return UnRegisteredPhoneContacts(
      contact: Contact.fromMap(
        newMap['contact'],
      ),
    );
  }
}

@HiveType(typeId: 6)
class HivePhoneContactsList extends PhoneContacts with HiveObject {
  @HiveField(0)
  List<List<Map<String, dynamic>>> phoneContacts;
  HivePhoneContactsList({
    @required this.phoneContacts,
  }) : super(Contact.fromMap(phoneContacts[0][0]));
}
