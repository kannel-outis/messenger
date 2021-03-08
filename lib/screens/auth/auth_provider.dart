import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:flutter/foundation.dart';
import 'package:messenger/customs/error/error.dart';
import 'package:messenger/models/country_code.dart';
import 'package:messenger/services/offline/image_picker.dart';
import 'package:messenger/services/offline/offline.dart';
import 'package:messenger/services/offline/shared_prefs/shared_prefs.dart';
import 'package:messenger/services/online/firebase/firebase_storage.dart';
import 'package:messenger/services/online/firebase/firestore_service.dart';
import 'package:messenger/services/online/online.dart';
import 'package:messenger/utils/codes.dart';
import 'package:messenger/services/online/firebase/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  List<CountryCode> _listOfCCs =
      Codes.codes.map((e) => CountryCode.fromJson(e)).toList();
  CountryCode? _countryCode;
  String? _verificationId;
  String? _phoneNumberWithoutCC;
  String? _imageUrl;
  final Online _auth = FirebaseMAuth();
  final Online _fireStoreService = FireStoreService();
  final Offline _offline = SharedPrefs.instance;
  final Online _firebaseStorage = MessengerFirebaseStorage();
  firebaseAuth.User? _firebaseUser;

  void dropDownOnChanged(CountryCode? c) {
    _countryCode = c;
    notifyListeners();
  }

  Future<void> verifyPhoneNumber(String phoneNumber,
      {VoidCallback? navigate, VoidCallback? timeOutFunction}) async {
    _countryCode =
        listOfCCs.where((element) => element.dialCode == "+234").first;
    try {
      await _auth.verifyPhoneNumber(
        _countryCode!.dialCode! + phoneNumber,
        setVerificationId: _setVerificationId,
        setPhoneAutoRetrieval: _setVerificationId,
        setFirebaseUser: _setFirebaseUser,
        voidCallBack: navigate,
        timeOutFunction: timeOutFunction,
      );
      _phoneNumberWithoutCC = phoneNumber;
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
        _setFirebaseUser(newUser!);
      });
    }).then((value) async {
      if (await Future.delayed(Duration(seconds: 2), () => _firebaseUser) !=
          null) {
        voidCallBack();
      }
    });
  }

  Future<void> saveNewUserToCloudAndSetPrefs(String username) async {
    await _fireStoreService
        .saveNewUserToCloud(
      user: _firebaseUser,
      userName: username,
      phoneNumberWithoutCC: _phoneNumberWithoutCC,
      userDataPref: _offline.getUserData(),
      newPhotoUrlString: _imageUrl,
    )
        .then((value) {
      _offline.setUserData(value);
      _fireStoreService.updateUserInCloud(user: value);
    });
  }

  void _setVerificationId(String newVerificationId) {
    _verificationId = newVerificationId;
    notifyListeners();
  }

  void _setFirebaseUser(firebaseAuth.User newUser) {
    _firebaseUser = newUser;
    print(" from _setFirebaseUser method" +
        (_firebaseUser == null ? "Null" : _firebaseUser!.uid));
    notifyListeners();
  }

  Future<void> pickeImageAndSaveToCloudStorage() async {
    await MessengerImagePicker.pickeImage().then(
      (value) async {
        _firebaseStorage.saveImageToFireStore(_firebaseUser!.uid, value).then(
          (value) {
            _imageUrl = value;
            print(_imageUrl);
            notifyListeners();
          },
        );
      },
    );
  }

  List<CountryCode> get listOfCCs => _listOfCCs;
  CountryCode get countrycode =>
      _countryCode ??
      listOfCCs.where((element) => element.dialCode == "+234").first;
  String? get verificationId => _verificationId;
  void get signOut => _auth.signOut();
  firebaseAuth.User? get firebaseUser => _firebaseUser;
  String? get phoneNumberWithoutCC => _phoneNumberWithoutCC;
  String? get imageUrl => _imageUrl;
  String? get photoUrlFromUserDataPref =>
      _offline.getUserData().id == _firebaseUser?.uid
          ? _offline.getUserData().photoUrl
          : null;
}
