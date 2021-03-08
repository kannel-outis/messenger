import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'user.g.dart';

@immutable
@HiveType(typeId: 3)
class User {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? userName;
  @HiveField(2)
  final List<dynamic>? phoneNumbers;
  @HiveField(3)
  final String? photoUrl;
  @HiveField(4)
  final String? status;

  User({
    this.id,
    this.userName,
    this.phoneNumbers,
    this.photoUrl,
    this.status,
  });

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final User typedOther = other;
    return typedOther.id == id &&
        typedOther.phoneNumbers == phoneNumbers &&
        typedOther.photoUrl == photoUrl &&
        typedOther.status == status &&
        typedOther.userName == userName;
  }

  @override
  int get hashCode => hashValues(id, hashList(phoneNumbers));

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userName": userName,
      "phoneNumbers": phoneNumbers,
      "photoUrl": photoUrl,
      "status": status,
    };
  }

  User.empty()
      : id = null,
        phoneNumbers = null,
        photoUrl = null,
        status = null,
        userName = null;

  User.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        userName = map['userName'],
        phoneNumbers = List<String>.from(map['phoneNumbers']),
        photoUrl = map['photoUrl'],
        status = map['status'];
}
