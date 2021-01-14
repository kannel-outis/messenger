import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:flutter/foundation.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/utils/typedef.dart';

/// Handles all Online operations
abstract class Online {
  const Online();

  //firebaseAuth
  Future<void> verifyPhoneNumber(
    String phoneNumber, {
    VoidStringCallBack setVerificationId,
    VoidStringCallBack setPhoneAutoRetrieval,
    @required VoidUserCallBack setFirebaseUser,
    @required VoidCallback voidCallBack,
    @required VoidCallback timeOutFunction,
  }) async {}

  @protected
  Stream<firebaseAuth.User> fireBaseUserOnChanged() =>
      firebaseAuth.FirebaseAuth.instance.authStateChanges();

  Future<void> signOut() async {}
  Future<void> verifyOTP({String verificationID, int otp}) =>
      throw UnimplementedError();
  Stream<firebaseAuth.User> get firebaseUser => fireBaseUserOnChanged();

  ///////////////////////////

  // fireStore
  Future<User> saveNewUserToCloud(
          {String userName, firebaseAuth.User user}) async =>
      throw UnimplementedError();
  Future<User> getUserFromCloud(firebaseAuth.User user) async =>
      throw UnimplementedError();
  Future<QuerySnapshot> queryMobileNumberORUsername(
          String query, String field) async =>
      throw UnimplementedError();
}