import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:messenger/screens/auth/auth_provider.dart';
import 'package:messenger/screens/contacts/first_launch_contact.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                      width: 3,
                                      style: BorderStyle.solid,
                                      color: Colors.blue),
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
                                    contentPadding: EdgeInsets.only(bottom: 15),
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
                SizedBox(height: 25),
                Consumer<AuthProvider>(
                  builder: (context, auth, child) {
                    return auth.uploadingImageToStore != true
                        ? SizedBox()
                        : Text("Uploading to Store.Please wait.....");
                  },
                ),
                SizedBox(height: 15),
                Center(
                  child: GestureDetector(
                    onTap: _authProvider.uploadingImageToStore != true
                        ? () {
                            _authProvider
                                .saveNewUserToCloudAndSetPrefs(
                                    _userNameController!.text)
                                .then(
                              (value) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => FirstLaunchContactScreen(),
                                  ),
                                );
                              },
                            );
                            // _authProvider.signOut;
                          }
                        : null,
                    child: Container(
                      height: MediaQuery.of(context).size.width / 9,
                      width: MediaQuery.of(context).size.width / 3,
                      color: Colors.blue,
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
                                    backgroundColor: Colors.white,
                                    strokeWidth: 1.5,
                                    value: 1.2,
                                    // valueColor: AlwaysStoppedAnimation<Color>(
                                    //     Colors.blue),
                                  );
                          },
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
