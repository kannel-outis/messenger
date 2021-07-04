import 'package:contacts_service/contacts_service.dart';
import 'package:hive/hive.dart';
import 'package:messenger/models/user.dart' as model;
part 'contacts_model.g.dart';

class PhoneContacts<T, R> {
  final List<T>? firstList;
  final List<R>? lastList;

  PhoneContacts({
    required this.firstList,
    required this.lastList,
  });
}

class MyContact {
  final String? name;
  final String? name2;
  final List<String?>? phones;
  final List<String?>? emails;
  MyContact({
    required this.name,
    required this.name2,
    required this.phones,
    required this.emails,
  });

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "name2": name2,
      "emails": emails,
      "phones": phones,
    };
  }

  static MyContact fromMap(Map<String, dynamic> map) {
    return MyContact(
      name: map['name'],
      name2: map['name2'],
      emails: List<String>.from(map['emails']),
      phones: List<String>.from(map['phones']),
    );
  }
}

class RegisteredPhoneContacts {
  final MyContact contact;
  final model.User user;
  RegisteredPhoneContacts({
    required this.contact,
    required this.user,
  });

  Map<String, Map<String, dynamic>> get map {
    print(user.map);
    return {
      'contact': contact.toMap(),
      'user': user.map,
    };
  }

  static RegisteredPhoneContacts fromMap(Map<String, dynamic> map) {
    final newMap = map
        .map((key, value) => MapEntry(key, Map<String, dynamic>.from(value)));

    return RegisteredPhoneContacts(
      contact: MyContact.fromMap(
        newMap['contact']!,
      ),
      user: model.User.fromMap(
        newMap['user']!,
      ),
    );
  }
}

class UnRegisteredPhoneContacts {
  final MyContact? contact;
  UnRegisteredPhoneContacts({this.contact});

  Map<String, Map<String, dynamic>> get map {
    return {
      'contact': contact!.toMap(),
    };
  }

  static UnRegisteredPhoneContacts fromMap(Map<String, dynamic> map) {
    final newMap = map
        .map((key, value) => MapEntry(key, Map<String, dynamic>.from(value)));
    return UnRegisteredPhoneContacts(
      contact: MyContact.fromMap(
        newMap['contact']!,
      ),
    );
  }
}

// @HiveType(typeId: 6)
class HivePhoneContactsList extends HiveObject {
  // @HiveField(0)
  // List<List<Map<String, dynamic>>> phoneContacts;
  List<Map<String, dynamic>>? registeredContactsToMap;
  List<Map<String, dynamic>>? unRegisteredContactsToMap;
  HivePhoneContactsList({
    required this.registeredContactsToMap,
    required this.unRegisteredContactsToMap,
  });
}
