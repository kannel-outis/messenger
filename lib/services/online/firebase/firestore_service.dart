import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:flutter/foundation.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/models/chat.dart';
import 'package:messenger/services/online/online.dart';
import 'package:messenger/utils/constants.dart';

class FireStoreService extends Online {
  final _cloud = FirebaseFirestore.instance;
  @override
  Future<User> saveNewUserToCloud(
      {String userName,
      @required String phoneNumberWithoutCC,
      firebaseAuth.User user,
      @required User userDataPref,
      @required String newPhotoUrlString}) async {
    User _newUser = User(
      id: user?.uid,
      phoneNumbers: [user?.phoneNumber, phoneNumberWithoutCC],
      photoUrl: user?.uid == userDataPref.id && newPhotoUrlString == null
          ? userDataPref?.photoUrl
          : user?.photoURL ??
              newPhotoUrlString ??
              GeneralConstants.DEFAULT_PHOTOURL,
      userName: userName,
      status: GeneralConstants.DEFAULT_STATUS,
    );
    print(_newUser.photoUrl);

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
    String query,
    String field,
  ) async {
    return await _cloud
        .collection(OnlineConstants.FIRESTORE_USER_REF)
        .where(
          field,
          arrayContains: query,
        )
        .get();
  }

  @override
  Future<QuerySnapshot> queryInfo(dynamic query, String field,
      {@required String path}) async {
    return await _cloud
        .collection(path)
        .where(
          field,
          // isEqualTo: query,
          isEqualTo: query,
        )
        .get();
  }

  @override
  Future<void> createNewChat(Chat newChat) async {
    return _cloud
        .collection(OnlineConstants.FIRESTORE_ONGOING_CHATS)
        .doc(newChat.chatID)
        .set(newChat.toMap());
  }

  @override
  Stream<QuerySnapshot> getAllOnGoingchats() {
    return _cloud
        .collection(OnlineConstants.FIRESTORE_ONGOING_CHATS)
        .snapshots();
  }

  @override
  Stream<QuerySnapshot> listenWhenAUserInitializesAChat(User user) {
    return _cloud
        .collection(OnlineConstants.FIRESTORE_ONGOING_CHATS)
        .where('participants.id', isEqualTo: user.id)
        .snapshots();
  }
}
