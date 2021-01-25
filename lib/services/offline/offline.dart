import 'package:contacts_service/contacts_service.dart';
import 'package:messenger/models/user.dart';

/// Handles all Offline operations
abstract class Offline {
  const Offline();

  // SharedPReferences: User Personal info and app Data

  String getString(String key) {
    return null;
  }

  bool getBool(String key) {
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

  User getUserData() => throw UnimplementedError();

  ///Loads all contacts from phone and filters registered from unregistered  contacts
  // Future<Iterable<Contact>> loadAllContacts() async =>
  //     throw UnimplementedError();
  Future<List<List<Contact>>> listOfRegisteredAndUnregisteredUsers() async =>
      throw UnimplementedError();
}
