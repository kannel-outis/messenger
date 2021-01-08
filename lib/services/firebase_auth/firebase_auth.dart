import 'package:firebase_auth/firebase_auth.dart';
import '../../customs/error/error.dart';

abstract class IFirebaseMAuth {
  Future<void> verifyPhoneNumber(String phoneNumber,
      {Function(String) setVerificationId,
      Function(String) setPhoneAutoRetrieval});
  Future<UserCredential> confirmOtp({String otp, String verificationId});
}

class FirebaseMAuth extends IFirebaseMAuth {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> verifyPhoneNumber(String phoneNumber,
      {Function(String) setVerificationId,
      Function(String) setPhoneAutoRetrieval}) async {
    PhoneVerificationCompleted _phoneVerificationCompleted =
        (PhoneAuthCredential _) async {
      await _auth.signInWithCredential(_);
      print('Phone number already verified');
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
  Future<UserCredential> confirmOtp({String otp, String verificationId}) async {
    UserCredential _user;
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      _user = await _auth.signInWithCredential(credential);
      return _user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
