import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger/services/online/online.dart';
import '../../../customs/error/error.dart';

class FirebaseMAuth extends Online {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Future<void> verifyPhoneNumber(
    phoneNumber, {
    setVerificationId,
    setPhoneAutoRetrieval,
    setFirebaseUser,
    voidCallBack,
    timeOutFunction,
  }) async {
    PhoneVerificationCompleted _phoneVerificationCompleted =
        (PhoneAuthCredential _) async {
      try {
        await _auth.signInWithCredential(_).then((value) {
          fireBaseUserOnChanged().listen((user) {
            setFirebaseUser!(user!);
          });
        }).then((value) {
          voidCallBack!();
        });
      } catch (e) {
        print(e.toString());
      }
    };

    PhoneVerificationFailed _phoneVerificationFailed =
        (FirebaseAuthException authException) {
      print(authException.message);
    };

    PhoneCodeSent _phoneCodeSent =
        (String verificationId, [int? forceResendingToken]) async {
      print("::::::::::::::::" + forceResendingToken.toString());
      print('VerifyId::::::::::::::::::: $verificationId');
      setVerificationId!(verificationId);
    };

    PhoneCodeAutoRetrievalTimeout _phoneCodeAutoRetrievalTimeout =
        (String verificationId) {
      print('auto Verification Timed Out');
      timeOutFunction!();
      setPhoneAutoRetrieval!(verificationId);
    };
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 20),
        verificationCompleted: _phoneVerificationCompleted,
        verificationFailed: _phoneVerificationFailed,
        codeSent: _phoneCodeSent,
        codeAutoRetrievalTimeout: _phoneCodeAutoRetrievalTimeout,
      );
    } catch (e) {
      throw MessengerError(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<void> verifyOTP({String? verificationID, int? otp}) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID!,
        smsCode: otp.toString(),
      );
      await _auth.signInWithCredential(credential);
    } catch (e) {
      print(e.toString());
    }
  }
}
