import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:messenger/models/user.dart';
import 'package:messenger/utils/constants.dart';

abstract class IFireStoreService {
  Future<void> saveToNewUserCloud({String userName, firebaseAuth.User user});
}

class FireStoreService extends IFireStoreService {
  final _cloud = FirebaseFirestore.instance;
  @override
  Future<void> saveToNewUserCloud(
      {String userName, firebaseAuth.User user}) async {
    User _newUser = User(
      id: user.uid,
      phoneNumber: user.phoneNumber,
      photoUrl: user.photoURL ?? "",
      userName: userName,
    );
    await _cloud
        .collection(Constants.FIRESTORE_USER_REF)
        .doc(_newUser.id ?? "Emirdilony")
        .set(_newUser.toMap());
  }
}