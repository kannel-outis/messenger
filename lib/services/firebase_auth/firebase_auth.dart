import 'package:firebase_auth/firebase_auth.dart';

abstract class IFirebaseMAuth {
  Future<void> verifyPhoneNumber(String phoneNumber,
      {Function(String) setVerificationId});
}

class FirebaseMAuth extends IFirebaseMAuth {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> verifyPhoneNumber(String phoneNumber,
      {Function(String) setVerificationId}) async {
    PhoneVerificationCompleted _phoneVerificationCompleted =
        (PhoneAuthCredential _) async {
      await _auth.signInWithCredential(_);
      print('Phone number already verified');
    };

    PhoneVerificationFailed _phoneVerificationFailed =
        (FirebaseAuthException authException) {};

    PhoneCodeSent _phoneCodeSent =
        (String verificationId, [int forceResendingToken]) async {
      setVerificationId(verificationId);
      print('VerifyId::::::::::::::::::: $verificationId');
    };
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 10),
        verificationCompleted: _phoneVerificationCompleted,
        verificationFailed: _phoneVerificationFailed,
        codeSent: _phoneCodeSent,
        codeAutoRetrievalTimeout: null,
      );
    } catch (e) {
      print("Verify Exception:::::::::::::::::::: ${e.toString()}");
    }
  }
}
