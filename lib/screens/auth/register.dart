import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:messenger/customs/widgets/country_drop_down.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';

class RegistrationScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
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
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 15),
                              ),
                            ),
                          ),
                        ),
                      ],
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
