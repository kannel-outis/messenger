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
  @HiveField(3)
  final String photoUrl;
  @HiveField(4)
  final String status;

  User({
    this.id,
    this.userName,
    this.phoneNumbers,
    this.photoUrl,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userName": userName,
      "phoneNumbers": phoneNumbers,
      "photoUrl": photoUrl,
      "status": status,
    };
  }

  User.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        userName = map['userName'],
        phoneNumbers = List<String>.from(map['phoneNumbers']),
        photoUrl = map['photoUrl'],
        status = map['status'];
}
