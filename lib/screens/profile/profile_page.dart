import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/screens/profile/profile_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends HookWidget {
  final User? user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController? _phoneTextController =
        useTextEditingController(text: user!.phoneNumbers![0]);
    TextEditingController? _userNameTextController =
        useTextEditingController(text: user!.userName!);
    TextEditingController? _statusTextController =
        useTextEditingController(text: user!.status!);
    var _profileProvider = Provider.of<ProfileProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(
          User(
            id: user!.id,
            phoneNumbers: user!.phoneNumbers,
            photoUrl: _profileProvider.imageUrl ?? user!.photoUrl,
            status: _statusTextController.text,
            userName: _userNameTextController.text,
            publicKey: user!.publicKey,
          ),
        );
        return true;
      },
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: Consumer<ProfileProvider>(
                    builder: (context, provider, child) {
                  return _ProfileImageBuilder(
                    profileUrl: provider.imageUrl ?? user!.photoUrl,
                    profileProvider: provider,
                    user: user,
                  );
                }),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 25.0, horizontal: 25.0),
                  child: _Bottom(
                    controllers: [
                      _phoneTextController,
                      _userNameTextController,
                      _statusTextController
                    ],
                    enabled: false,
                    profileProvider: _profileProvider,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileImageBuilder extends StatelessWidget {
  final String? profileUrl;
  final ProfileProvider? profileProvider;
  final User? user;

  const _ProfileImageBuilder({
    Key? key,
    this.profileUrl,
    this.profileProvider,
    this.user,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'profielImage',
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2,
            width: double.infinity,
            color: Colors.grey,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(profileUrl!),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Material(
              child: IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: () {
                  profileProvider!.pickeImageAndSaveToCloudStorage(user);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bottom extends StatelessWidget {
  final List<TextEditingController?>? controllers;
  final bool? enabled;
  final ProfileProvider? profileProvider;

  const _Bottom(
      {Key? key, this.controllers, this.enabled, this.profileProvider})
      : super(key: key);
  Widget _buildTextField(TextEditingController? controller, {bool? enabled}) {
    return Expanded(
      child: TextFormField(
        controller: controller,
        enabled: enabled,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _buildTextField(controllers![0], enabled: enabled),
          _buildTextField(controllers![1]),
          _buildTextField(controllers![2]),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(
                    Size(0, 50),
                  ),
                ),
                onPressed: () {
                  profileProvider!.updateAllDataInCloud(
                    status: controllers![2]!.text,
                    username: controllers![1]!.text,
                  );
                },
                child: Center(
                  child: Text("Update"),
                ),
              )),
        ],
      ),
    );
  }
}
