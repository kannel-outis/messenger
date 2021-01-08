import 'package:flutter/foundation.dart';
import 'package:messenger/models/country_code.dart';
import 'package:messenger/utils/codes.dart';
import 'package:messenger/services/firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  List<CountryCode> _listOfCCs =
      Codes.codes.map((e) => CountryCode.fromJson(e)).toList();
  CountryCode _countryCode;
  String _verificationId;
  String _shitHole;
  final IFirebaseMAuth _auth = FirebaseMAuth();

  void dropDownOnChanged(CountryCode c) {
    _countryCode = c;
    notifyListeners();
  }

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    await _auth.verifyPhoneNumber(phoneNumber,
        setVerificationId: _setVerificationId,
        setPhoneAutoRetrieval: _setVerificationId);
  }

  Future<void> confirmOtp(String otp) async {
    await _auth
        .confirmOtp(
          otp: otp,
          verificationId: _verificationId,
        )
        .then((value) => print(value.user.uid));
  }

  void _setVerificationId(String newVerificationId) {
    _verificationId = newVerificationId;
    notifyListeners();
  }

  void setShit(String name) {
    _shitHole = name;
    notifyListeners();
  }

  List<CountryCode> get listOfCCs => _listOfCCs;
  CountryCode get countrycode => _countryCode ?? listOfCCs[0];
  String get verificationId => _verificationId;
  String get shitHole => _shitHole;
}
