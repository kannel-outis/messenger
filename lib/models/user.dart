import 'package:flutter/foundation.dart';

@immutable
class User {
  final String id;
  final String userName;
  final List<dynamic> phoneNumbers;
  // final String phoneNumberWithoutCC;
  final String photoUrl;

  User({
    this.id,
    this.userName,
    this.phoneNumbers,
    this.photoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userName": userName,
      "phoneNumbers": phoneNumbers,
      // "phoneWithoutCC": phoneNumberWithoutCC,
      "photoUrl": photoUrl,
    };
  }

  User.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        userName = map['userName'],
        phoneNumbers = List<String>.from(map['phoneNumbers']),
        // phoneNumberWithoutCC = map['phoneWithoutCC'],
        photoUrl = map['photoUrl'];
}
