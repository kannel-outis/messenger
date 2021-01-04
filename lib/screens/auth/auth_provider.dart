import 'package:flutter/foundation.dart';
import 'package:messenger/models/country_code.dart';
import 'package:messenger/utils/codes.dart';

class AuthProvider extends ChangeNotifier {
  List<CountryCode> _listOfCCs =
      Codes.codes.map((e) => CountryCode.fromJson(e)).toList();
  CountryCode _countryCode;

  void dropDownOnChanged(CountryCode c) {
    _countryCode = c;
    notifyListeners();
  }

  List<CountryCode> get listOfCCs => _listOfCCs;
  CountryCode get countrycode => _countryCode;
}
