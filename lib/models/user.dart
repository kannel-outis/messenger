import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
part 'user.g.dart';

@immutable
@HiveType(typeId: 3)
class User {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userName;
  @HiveField(2)
  final List<dynamic> phoneNumbers;
  // final String phoneNumberWithoutCC;
  @HiveField(3)
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
