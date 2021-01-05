import 'package:flutter/foundation.dart';
import 'package:messenger/models/country_code.dart';
import 'package:messenger/utils/codes.dart';
import 'package:messenger/services/firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  List<CountryCode> _listOfCCs =
      Codes.codes.map((e) => CountryCode.fromJson(e)).toList();
  CountryCode _countryCode;
  String _otpCode;
  final IFirebaseMAuth _auth = FirebaseMAuth();

  void dropDownOnChanged(CountryCode c) {
    _countryCode = c;
    notifyListeners();
  }

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    await _auth.verifyPhoneNumber(phoneNumber, setVerificationId: _setOTP);
  }

  void _setOTP(String newOTP) {
    _otpCode = newOTP;
    notifyListeners();
  }

  List<CountryCode> get listOfCCs => _listOfCCs;
  CountryCode get countrycode => _countryCode;
  String get otpCode => _otpCode;
}
