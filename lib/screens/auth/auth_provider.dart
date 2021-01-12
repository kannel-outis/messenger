import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:flutter/foundation.dart';
import 'package:messenger/customs/error/error.dart';
import 'package:messenger/models/country_code.dart';
import 'package:messenger/services/offline/offline.dart';
import 'package:messenger/services/offline/shared_prefs/shared_prefs.dart';
import 'package:messenger/services/online/cloud_firestore/firestore_service.dart';
import 'package:messenger/services/online/online.dart';
import 'package:messenger/utils/codes.dart';
import 'package:messenger/services/online/firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  List<CountryCode> _listOfCCs =
      Codes.codes.map((e) => CountryCode.fromJson(e)).toList();
  CountryCode _countryCode;
  String _verificationId;
  final Online _auth = FirebaseMAuth();
  final Online _fireStoreService = FireStoreService();
  final Offline _offline = SharedPrefs.instance;
  firebaseAuth.User _firebaseUser;

  void dropDownOnChanged(CountryCode c) {
    _countryCode = c;
    notifyListeners();
  }

  Future<void> verifyPhoneNumber(String phoneNumber,
      {VoidCallback navigate, VoidCallback timeOutFunction}) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber,
        setVerificationId: _setVerificationId,
        setPhoneAutoRetrieval: _setVerificationId,
        setFirebaseUser: _setFirebaseUser,
        voidCallBack: navigate,
        timeOutFunction: timeOutFunction,
      );
    } on MessengerError catch (e) {
      print(e.message);
    }
  }

  Future<void> verifyOTP(int otp, VoidCallback voidCallBack) async {
    await _auth
        .verifyOTP(
      otp: otp,
      verificationID: _verificationId,
    )
        .then((value) {
      _auth.firebaseUser.listen((newUser) {
        _setFirebaseUser(newUser);
      });
    }).then((value) async {
      if (await Future.delayed(Duration(seconds: 2), () => _firebaseUser) !=
          null) {
        voidCallBack();
      }
    });
  }

  Future<void> saveNewUserToCloud(String username) async {
    await _fireStoreService.saveNewUserToCloud(
      user: _firebaseUser,
      userName: username,
    );
  }

  void _setVerificationId(String newVerificationId) {
    _verificationId = newVerificationId;
    notifyListeners();
  }

  void _setFirebaseUser(firebaseAuth.User newUser) {
    _firebaseUser = newUser;
    print(" from _setFirebaseUser method" + _firebaseUser?.uid ?? 'Null ');
    notifyListeners();
  }

  List<CountryCode> get listOfCCs => _listOfCCs;
  CountryCode get countrycode => _countryCode ?? listOfCCs[0];
  String get verificationId => _verificationId;
  void get signOut => _auth.signOut();
  firebaseAuth.User get firebaseUser => _firebaseUser;
}
