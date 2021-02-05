import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:messenger/screens/auth/auth_provider.dart';
import 'package:messenger/screens/set_name/set_name_screen.dart';
import 'package:provider/provider.dart';

class VerifyOTPScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _otpController = useTextEditingController();
    final _authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    child: Text(
                      'Verify OTP',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                FittedBox(
                  alignment: Alignment.center,
                  child: Text('Enter Verification code.'),
                ),
                SizedBox(height: 30),
                Center(
                  child: Container(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 120,
                      height: 35,
                      child: Container(
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          controller: _otpController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 15),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      _authProvider.verifyOTP(
                        int.parse(_otpController.text),
                        () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => SetNameScreen(),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.width / 9,
                      width: MediaQuery.of(context).size.width / 3,
                      color: Colors.blue,
                      child: Center(
                        child: Text(
                          'Confirm',
                          style: TextStyle(color: Colors.white),
                        ),
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
