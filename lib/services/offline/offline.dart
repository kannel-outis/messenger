import 'package:messenger/models/user.dart';
import 'package:messenger/models/contacts_model.dart';

/// Handles all Offline operations
abstract class Offline {
  const Offline();

  // SharedPReferences: User Personal info and app Data

  String? getString(String key) {
    throw UnimplementedError();
  }

  bool? getBool(String key) {
    return false;
  }

  Future<bool> setString(String key, String value) async {
    return false;
  }

  Future<bool> setBool(String key, bool value) async {
    return false;
  }

  Future<bool> setUserData(User user) async {
    return false;
  }

  User get user => throw UnimplementedError();

  Future<PhoneContacts<RegisteredPhoneContacts, UnRegisteredPhoneContacts>>
      listOfRegisteredAndUnregisteredUsers() => throw UnimplementedError();
}
