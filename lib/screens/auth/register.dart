import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:messenger/screens/auth/verify_otp.dart';
import 'package:messenger/screens/set_name/set_name_screen.dart';
import 'package:provider/provider.dart';
import '../../customs/widgets/country_drop_down.dart';
import 'auth_provider.dart';

class RegistrationScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _phoneController = useTextEditingController();
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
                      'Verify Your PhoneNumber',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Center(
                  child: Text('Enter your Phone Number'),
                ),
                SizedBox(height: 30),
                Center(
                  child: Container(
                    child: Row(
                      children: [
                        Consumer<AuthProvider>(
                          builder: (context, provider, _) {
                            return CountryDropDown(
                              listOfCodes: _authProvider.listOfCCs,
                              value: _authProvider.countrycode,
                              onChanged: provider.dropDownOnChanged,
                            );
                          },
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 200,
                          height: 35,
                          child: Container(
                            // color: Colors.black,
                            child: TextField(
                              keyboardType: TextInputType.phone,
                              controller: _phoneController,
                              maxLength: 11,
                              maxLengthEnforced: true,
                              buildCounter: (
                                context, {
                                int currentLength,
                                int maxLength,
                                bool isFocused,
                              }) {
                                return SizedBox();
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 15),
                              ),
                              // onChanged: (value) {
                              //   print(value);
                              // },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      _authProvider.verifyPhoneNumber(
                          "${_authProvider.countrycode.dialCode}${_phoneController.text.toString()}",
                          () async {
                        if (await Future.delayed(Duration(seconds: 2),
                            () => _authProvider.firebaseUser != null)) {
                          print(_authProvider.firebaseUser.phoneNumber);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => SetNameScreen()));
                        } else {
                          print("Something Went Wrong");
                        }
                      });
                      // print(_authProvider.firebaseUser.uid);

                      // _authProvider.signOut;
                      print(
                          "${_authProvider.countrycode.dialCode}${_phoneController.text.toString()}");
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.width / 9,
                      width: MediaQuery.of(context).size.width / 3,
                      color: Colors.blue,
                      child: Center(
                        child: Text(
                          'Send SMS',
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
