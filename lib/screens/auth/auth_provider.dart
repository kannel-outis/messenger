import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:flutter/foundation.dart';
import 'package:messenger/services/encryption_class.dart';
import 'package:messenger/customs/error/error.dart';
import 'package:messenger/models/country_code.dart';
import 'package:messenger/services/offline/hive.db/hive_handler.dart';
import 'package:messenger/services/offline/hive.db/models/keypairs.dart';
import 'package:messenger/services/offline/image_picker.dart';
import 'package:messenger/services/offline/offline.dart';
import 'package:messenger/services/offline/shared_prefs/shared_prefs.dart';
import 'package:messenger/services/online/firebase/firebase_storage.dart';
import 'package:messenger/services/online/firebase/firestore_service.dart';
import 'package:messenger/services/online/online.dart';
import 'package:messenger/utils/codes.dart';
import 'package:messenger/services/online/firebase/firebase_auth.dart';
import 'package:messenger/utils/typedef.dart';

class AuthProvider extends ChangeNotifier {
  List<CountryCode> _listOfCCs =
      Codes.codes.map((e) => CountryCode.fromJson(e)).toList();
  CountryCode? _countryCode;
  String? _verificationId;
  String? _phoneNumberWithoutCC;
  String? _imageUrl;
  final Online _auth = FirebaseMAuth();
  final Online _fireStoreService = FireStoreService();
  final Offline _prefs = SharedPrefs.instance;
  final Online _firebaseStorage = MessengerFirebaseStorage();
  final _c = EncryptClassHandler();
  final _hiveHandler = HiveHandler();
  firebaseAuth.User? _firebaseUser;
  bool? _isLoading;
  bool? _isTryingToVerify;
  bool? _uploadingImageToStore;

  void dropDownOnChanged(CountryCode? c) {
    _countryCode = c;
    notifyListeners();
  }

  Future<void> verifyPhoneNumber(String phoneNumber,
      {VoidCallback? navigate,
      VoidCallback? timeOutFunction,
      required VoidExceptionCallBack? handleExceptionInUi}) async {
    _countryCode =
        listOfCCs.where((element) => element.dialCode == "+234").first;
    _isLoading = true;
    notifyListeners();
    try {
      await _auth.verifyPhoneNumber(
        _countryCode!.dialCode! + phoneNumber,
        setVerificationId: _setVerificationId,
        setPhoneAutoRetrieval: _setVerificationId,
        setFirebaseUser: _setFirebaseUser,
        handleException: (e) {
          handleExceptionInUi!(e);
          _isLoading = false;
          notifyListeners();
        },
        voidCallBack: () {
          navigate!();
          _isTryingToVerify = false;
          _isLoading = false;

          notifyListeners();
        },
        timeOutFunction: () {
          timeOutFunction!();
          _isTryingToVerify = false;
          notifyListeners();
        },
      );

      _phoneNumberWithoutCC = phoneNumber;
    } on MessengerError catch (e) {
      _isLoading = false;
      notifyListeners();
      handleExceptionInUi!(e.message);
    }
  }

  Future<void> verifyOTP(int otp, VoidCallback voidCallBack,
      {required VoidExceptionCallBack? handleExceptionInUi}) async {
    _isTryingToVerify = true;
    notifyListeners();
    try {
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
        _isTryingToVerify = true;
        notifyListeners();
        if (await Future.delayed(Duration(seconds: 2), () => _firebaseUser) !=
            null) {
          voidCallBack();
        }
      });
    } on MessengerError catch (e) {
      _isTryingToVerify = false;
      notifyListeners();
      handleExceptionInUi!(e.message);
    }
  }

  Future<void> saveNewUserToCloudAndSetPrefs(String username,
      {required VoidExceptionCallBack? handleExceptionInUi}) async {
    _isLoading = true;
    notifyListeners();
    try {
      final keyPair = _c.generateKeyPairs();
      HiveKeyPair _hiveKeyPair = HiveKeyPair(
          privateKey: _c.keyToString(key: keyPair.privateKey),
          publicKey: _c.keyToString(key: keyPair.publicKey));
      String? _publicKey = _c.keyToString(key: keyPair.publicKey);
      _hiveHandler.saveKeyPairs(_hiveKeyPair);
      await _fireStoreService
          .saveNewUserToCloud(
        user: _firebaseUser,
        userName: username,
        phoneNumberWithoutCC: _phoneNumberWithoutCC,
        userDataPref: _prefs.getUserData(),
        newPhotoUrlString: _imageUrl,
        publicKey: _publicKey!,
      )
          .then((value) {
        _isLoading = false;
        notifyListeners();
        _prefs.setUserData(value);

        _fireStoreService.updateUserInCloud(user: value);
      });
    } on MessengerError catch (e) {
      handleExceptionInUi!(e.message);
    }
  }

  void _setVerificationId(String newVerificationId, {bool? codeSent}) {
    _verificationId = newVerificationId;
    _isLoading = false;
    if (codeSent == true) _isTryingToVerify = true;
    notifyListeners();
  }

  void _setFirebaseUser(firebaseAuth.User newUser) {
    _firebaseUser = newUser;
    print(" from _setFirebaseUser method" +
        (_firebaseUser == null ? "Null" : _firebaseUser!.uid));
    notifyListeners();
  }

  Future<void> pickeImageAndSaveToCloudStorage() async {
    try {
      await MessengerImagePicker.pickeImage().then(
        (value) async {
          _uploadingImageToStore = true;
          notifyListeners();
          _firebaseStorage.saveImageToFireStore(_firebaseUser!.uid, value).then(
            (value) {
              _imageUrl = value;
              _uploadingImageToStore = false;
              notifyListeners();
            },
          );
        },
      );
    } on MessengerError catch (e) {
      print(e.message);
    }
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
      _prefs.getUserData().id == _firebaseUser?.uid
          ? _prefs.getUserData().photoUrl
          : null;
  bool? get isTryingToVerify => _isTryingToVerify;
  bool? get isLoading => _isLoading;
  bool? get uploadingImageToStore => _uploadingImageToStore;
}
