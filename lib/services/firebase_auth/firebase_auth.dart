import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../customs/error/error.dart';

abstract class IFirebaseMAuth {
  Future<void> verifyPhoneNumber(
    String phoneNumber, {
    Function(String) setVerificationId,
    Function(String) setPhoneAutoRetrieval,
    @required Function(User) setFirebaseUser,
  });
  // ignore: unused_element
  Stream<User> _fireBaseUserOnChanged();
  Future<void> signOut();
  Future<void> verifyOTP({String verificationID, int otp});
}

class FirebaseMAuth extends IFirebaseMAuth {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> verifyPhoneNumber(
    String phoneNumber, {
    Function(String) setVerificationId,
    Function(String) setPhoneAutoRetrieval,
    @required Function(User) setFirebaseUser,
  }) async {
    PhoneVerificationCompleted _phoneVerificationCompleted =
        (PhoneAuthCredential _) async {
      await _auth.signInWithCredential(_).then((value) {
        _fireBaseUserOnChanged().listen((user) {
          setFirebaseUser(user);
        });
      });
    };

    PhoneVerificationFailed _phoneVerificationFailed =
        (FirebaseAuthException authException) {
      print(authException.message);
    };

    PhoneCodeSent _phoneCodeSent =
        (String verificationId, [int forceResendingToken]) async {
      setVerificationId(verificationId);
      print('VerifyId::::::::::::::::::: $verificationId');
    };

    PhoneCodeAutoRetrievalTimeout _phoneCodeAutoRetrievalTimeout =
        (String verificationId) {
      print(verificationId);
      setPhoneAutoRetrieval(verificationId);
    };
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(minutes: 2),
        verificationCompleted: _phoneVerificationCompleted,
        verificationFailed: _phoneVerificationFailed,
        codeSent: _phoneCodeSent,
        codeAutoRetrievalTimeout: _phoneCodeAutoRetrievalTimeout,
      );
    } catch (e) {
      throw MessengerError(e.toString());
      // print("Verify Exception:::::::::::::::::::: ${e.toString()}");
    }
  }

  @override
  Stream<User> _fireBaseUserOnChanged() {
    return _auth.authStateChanges();
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<void> verifyOTP({String verificationID, int otp}) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID,
        smsCode: otp.toString(),
      );
      await _auth.signInWithCredential(credential);
    } catch (e) {
      print(e.toString());
    }
  }
}
