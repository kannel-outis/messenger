import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:messenger/screens/auth/auth_provider.dart';
import 'package:messenger/screens/contacts/contacts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:messenger/utils/utils.dart';
import 'package:provider/provider.dart';

class SetNameScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController? _userNameController =
        useTextEditingController();
    final _authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Center(
                //   child: Container(
                //     child: Text(
                //       'Set Your Username',
                //       style: TextStyle(
                //         color: Colors.grey,
                //         fontWeight: FontWeight.bold,
                //         fontSize: 25,
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(height: 30),
                FittedBox(
                  alignment: Alignment.center,
                  child: Text(
                    'Enter a name you want to go by. This name appers on your Profile.',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Center(
                  child: Container(
                    // height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Consumer<AuthProvider>(builder: (context, auth, child) {
                          return Stack(
                            children: [
                              Container(
                                height: Utils.blockHeight * 10,
                                width: Utils.blockHeight * 10,
                                constraints: BoxConstraints(
                                  minHeight: 50,
                                  minWidth: 50,
                                  maxHeight: 85,
                                  maxWidth: 85,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    width: 1,
                                    style: BorderStyle.solid,
                                    color: Colors.red,
                                  ),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: (auth.imageUrl == null &&
                                            auth.photoUrlFromUserDataPref ==
                                                null
                                        ? AssetImage('assets/person.png')
                                        : CachedNetworkImageProvider(
                                            auth.imageUrl ??
                                                auth.photoUrlFromUserDataPref!,
                                          )) as ImageProvider<Object>,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: -10,
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: IconButton(
                                    icon: Icon(Icons.camera_alt),
                                    onPressed: () {
                                      auth.pickeImageAndSaveToCloudStorage();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                        SizedBox(width: 20),
                        Expanded(
                          child: Container(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 190,
                              height: 35,
                              child: Container(
                                child: TextField(
                                  controller: _userNameController,
                                  decoration: InputDecoration(
                                    hintText: "Enter OTP to Verify",
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    focusColor: Colors.red,
                                    // contentPadding: EdgeInsets.only(bottom: 15),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // SizedBox(height: 25),
                Consumer<AuthProvider>(
                  builder: (context, auth, child) {
                    return auth.uploadingImageToStore != true
                        ? SizedBox()
                        : Text("Uploading to Store.Please wait.....");
                  },
                ),
                SizedBox(height: 15),
                Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(
                        Size(0, 40),
                      ),
                    ),
                    onPressed: _authProvider.uploadingImageToStore != true
                        ? () {
                            _authProvider
                                .saveNewUserToCloudAndSetPrefs(
                                    _userNameController!.text,
                                    handleExceptionInUi: (e) =>
                                        Fluttertoast.showToast(msg: e))
                                .then(
                              (value) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ContactsScreen(),
                                  ),
                                );
                              },
                            );
                            // _authProvider.signOut;
                          }
                        : null,
                    child: Center(
                      child: Consumer<AuthProvider>(
                        builder: (context, provider, child) {
                          final bool? isLoading = provider.isLoading;
                          return isLoading != true
                              ? Text(
                                  'Save',
                                  style: TextStyle(color: Colors.white),
                                )
                              : CircularProgressIndicator(
                                  // backgroundColor: Colors.white,
                                  // strokeWidth: 1.5,
                                  // value: 1.2,
                                  // // valueColor: AlwaysStoppedAnimation<Color>(
                                  // //     Colors.blue),
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
