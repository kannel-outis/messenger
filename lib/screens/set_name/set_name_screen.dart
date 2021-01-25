import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:messenger/screens/auth/auth_provider.dart';
import 'package:messenger/screens/contacts/first_launch_contact.dart';
import 'package:provider/provider.dart';

class SetNameScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _userNameController = useTextEditingController();
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
                      'Set Your Username',
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
                  child: Text(
                    'Enter a name you want to go by. This name appers on your Profile.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Center(
                  child: Container(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 120,
                      height: 35,
                      child: Container(
                        child: TextField(
                          controller: _userNameController,
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
                      _authProvider
                          .saveNewUserToCloudAndSetPrefs(
                              _userNameController.text)
                          .then((value) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => FirstLaunchContactScreen()));
                      });
                      // _authProvider.signOut;
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.width / 9,
                      width: MediaQuery.of(context).size.width / 3,
                      color: Colors.blue,
                      child: Center(
                        child: Text(
                          'Save',
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
