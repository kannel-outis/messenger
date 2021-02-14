import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/screens/profile/profile_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends HookWidget {
  final User user;

  const ProfileScreen({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _phoneTextController =
        useTextEditingController(text: user.phoneNumbers[0]);
    var _userNameTextController = useTextEditingController(text: user.userName);
    var _statusTextController = useTextEditingController(text: user.status);
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(
          User(
            id: user.id,
            phoneNumbers: user.phoneNumbers,
            photoUrl: user.photoUrl,
            status: _statusTextController.text,
            userName: _userNameTextController.text,
          ),
        );
        return true;
      },
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: _ProfileImageBuilder(profileUrl: user.photoUrl),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 25.0, horizontal: 25.0),
                  child: _Bottom(controllers: [
                    _phoneTextController,
                    _userNameTextController,
                    _statusTextController
                  ], enabled: false),
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
  final String profileUrl;

  const _ProfileImageBuilder({Key key, this.profileUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'profielImage',
      child: Container(
        height: MediaQuery.of(context).size.height / 2,
        width: double.infinity,
        color: Colors.grey,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(profileUrl),
            ),
          ),
        ),
      ),
    );
  }
}

class _Bottom extends StatelessWidget {
  final List<TextEditingController> controllers;
  final bool enabled;

  const _Bottom({Key key, this.controllers, this.enabled}) : super(key: key);
  Widget _buildTextField(TextEditingController controller, {bool enabled}) {
    return Expanded(
      child: TextFormField(
        controller: controller,
        enabled: enabled,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _profileProvider = Provider.of<ProfileProvider>(context);
    return Container(
      child: Column(
        children: [
          _buildTextField(controllers[0], enabled: enabled),
          _buildTextField(controllers[1]),
          _buildTextField(controllers[2]),
          InkWell(
            onTap: () {
              _profileProvider.updateAllDataInCloud(
                  status: controllers[2].text, username: controllers[1].text);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                height: 50,
                color: Colors.blue,
                child: Center(
                  child: Text(
                    'Update',
                    style: TextStyle(fontSize: 23, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
