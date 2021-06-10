import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:messenger/screens/auth/verify_otp.dart';
import 'package:messenger/screens/auth/set_name_screen.dart';
import 'package:messenger/utils/utils.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
import '../../customs/widgets/country_drop_down.dart';
import 'auth_provider.dart';

class RegistrationScreen extends HookWidget {
  void _checkPlatformAndExecute(AuthProvider _authProvider,
      BuildContext context, TextEditingController? _phoneController) {
    if (Platform.isAndroid) {
      _authProvider.verifyPhoneNumber("${_phoneController!.text.toString()}",
          navigate: () async {
        if (await Future.delayed(
            Duration(seconds: 2), () => _authProvider.firebaseUser != null)) {
          print(_authProvider.firebaseUser!.phoneNumber);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => SetNameScreen()));
        } else {
          print("Something Went Wrong");
        }
      }, timeOutFunction: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => VerifyOTPScreen()));
      }, handleExceptionInUi: (eMessage) {
        Fluttertoast.showToast(msg: eMessage);
      });
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => VerifyOTPScreen()));
    }
  }

  String? isloadinState(bool isLoading, bool isTryingToverify) {
    if (isLoading == true) {
      return "Loading...";
    } else if (isTryingToverify == true) {
      return "Trying to Verify...";
    } else {
      return "Send SMS";
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController? _phoneController = useTextEditingController();
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
                        color: Colors.grey,
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
                      mainAxisAlignment: MainAxisAlignment.center,
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
                          width: 150,
                          height: 40,
                          child: Container(
                            child: TextField(
                              keyboardType: TextInputType.phone,
                              controller: _phoneController,
                              maxLength: 11,
                              maxLengthEnforcement:
                                  MaxLengthEnforcement.enforced,
                              buildCounter: (
                                context, {
                                int? currentLength,
                                int? maxLength,
                                bool? isFocused,
                              }) {
                                return SizedBox();
                              },
                              decoration: InputDecoration(
                                hintText: "Enter phone number",
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                                focusColor: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(
                        Size(0, 40),
                      ),
                    ),
                    onPressed: () {
                      _checkPlatformAndExecute(
                          _authProvider, context, _phoneController);

                      print(
                          "${_authProvider.countrycode.dialCode}${_phoneController!.text.toString()}");
                    },
                    child: Center(
                      child: Consumer<AuthProvider>(
                          builder: (context, provider, child) {
                        String _label = isloadinState(
                            provider.isLoading ?? false,
                            provider.isTryingToVerify ?? false)!;
                        return Text(
                          _label,
                          style: TextStyle(color: Colors.white),
                        );
                      }),
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

// class Classss extends StatefulWidget {
//   @override
//   _ClassssState createState() => _ClassssState();
// }

// class _ClassssState extends State<Classss> {
//   @override
//   void didUpdateWidget(covariant Classss oldWidget) {
//     // TODO: implement didUpdateWidget
//     super.didUpdateWidget(oldWidget);
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Container(

//     );
//   }
// }
