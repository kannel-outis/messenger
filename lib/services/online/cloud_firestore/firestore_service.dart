import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:messenger/models/user.dart';
import 'package:messenger/services/online/online.dart';
import 'package:messenger/utils/constants.dart';

class FireStoreService extends Online {
  final _cloud = FirebaseFirestore.instance;
  @override
  Future<User> saveNewUserToCloud(
      {String userName, firebaseAuth.User user}) async {
    User _newUser = User(
      id: user?.uid,
      phoneNumber: user.phoneNumber,
      photoUrl: user.photoURL ?? "",
      userName: userName,
    );
    await _cloud
        .collection(OnlineConstants.FIRESTORE_USER_REF)
        .doc(_newUser?.id)
        .set(_newUser.toMap());
    return _newUser;
  }

  @override
  Future<User> getUserFromCloud(firebaseAuth.User user) async {
    DocumentSnapshot _docSnapshot = await _cloud
        .collection(OnlineConstants.FIRESTORE_USER_REF)
        .doc(user.uid)
        .get();
    return User.fromMap(_docSnapshot.data());
  }

  @override
  Future<QuerySnapshot> queryMobileNumberORUsername(
      String query, String field) async {
    return await _cloud
        .collection(OnlineConstants.FIRESTORE_USER_REF)
        .where(field, isEqualTo: query)
        .get();
  }
}
