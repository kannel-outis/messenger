import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:flutter/foundation.dart';
import 'package:messenger/customs/error/error.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/utils/typedef.dart';
import '../../models/chat.dart';

/// Handles all Online operations
abstract class Online {
  //firebaseAuth
  Future<void> verifyPhoneNumber(
    String phoneNumber, {
    VoidStringCallBack? setVerificationId,
    VoidStringCallBack? setPhoneAutoRetrieval,
    required VoidUserCallBack? setFirebaseUser,
    required VoidCallback? voidCallBack,
    required VoidCallback? timeOutFunction,
  }) async {}

  @protected
  Stream<firebaseAuth.User?> fireBaseUserOnChanged() =>
      firebaseAuth.FirebaseAuth.instance.authStateChanges();

  Future<void> signOut() async {}
  Future<void> verifyOTP({String? verificationID, int? otp}) =>
      throw UnimplementedError();
  Stream<firebaseAuth.User?> get firebaseUser => fireBaseUserOnChanged();

  ///////////////////////////

  // fireStore
  Future<User> saveNewUserToCloud(
          {String? userName,
          required String? phoneNumberWithoutCC,
          firebaseAuth.User? user,
          required User userDataPref,
          required String? newPhotoUrlString}) async =>
      throw UnimplementedError();
  Future<User> getUserFromCloud(firebaseAuth.User user) async =>
      throw UnimplementedError();
  @mustCallSuper
  // ignore: missing_return
  Future<bool> updateUserInCloud({User? user}) async {
    if (firebaseAuth.User == null) throw MessengerError('User is Null');
    return false;
  }

  Future<QuerySnapshot> queryMobileNumberORUsername(
    String query,
    String field,
  ) async =>
      throw UnimplementedError();
  Future<QuerySnapshot> queryInfo(dynamic query) => throw UnimplementedError();

  Future<void> createNewChat(Chat chat) => throw UnimplementedError();
  Stream<QuerySnapshot> getAllOnGoingchats() => throw UnimplementedError();
  Stream<QuerySnapshot> listenWhenAUserInitializesAChat(User user) =>
      throw UnimplementedError();

  ///firebase Storage for profile pics setUp
  Future<String> saveImageToFireStore(String? uid, File? file) =>
      throw UnimplementedError();
}

///Do listen for friend data change in firebase and apply changes to friend's data in hive db
