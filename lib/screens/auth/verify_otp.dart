import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:messenger/screens/auth/auth_provider.dart';
import 'package:messenger/screens/auth/set_name_screen.dart';
import 'package:messenger/utils/utils.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class VerifyOTPScreen extends HookWidget {
  double? height;
  @override
  Widget build(BuildContext context) {
    final TextEditingController? _otpController = useTextEditingController();
    final _authProvider = Provider.of<AuthProvider>(context);
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      height = Utils.blockWidth * 100 - MediaQuery.of(context).padding.top;
    } else {
      height = Utils.blockHeight * 100 - MediaQuery.of(context).padding.top;
    }
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
            height: height,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    child: Text(
                      'Verify OTP',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
                // SizedBox(height: 30),
                SizedBox(height: 30),
                Center(
                  child: Container(
                    child: SizedBox(
                      width: Utils.blockWidth * 100,
                      // height: 35,
                      child: Container(
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          controller: _otpController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: "Enter OTP to Verify",
                            border: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            focusColor: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(
                        Size(0, 50),
                      ),
                    ),
                    onPressed: () {
                      _authProvider.verifyOTP(int.parse(_otpController!.text),
                          () {
                        Fluttertoast.showToast(msg: "Verification Successfull");
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => SetNameScreen(),
                          ),
                        );
                      }, handleExceptionInUi: (e) {
                        Fluttertoast.showToast(
                            msg: e, toastLength: Toast.LENGTH_LONG);
                      });
                    },
                    child: Center(
                      child: Consumer<AuthProvider>(
                        builder: (context, authProvider, child) {
                          final bool? isVerifying =
                              authProvider.isTryingToVerify;
                          return isVerifying == true
                              ? Text(
                                  'Verifying...',
                                  style: TextStyle(color: Colors.white),
                                )
                              : Text(
                                  'Confirm',
                                  style: TextStyle(color: Colors.white),
                                );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
