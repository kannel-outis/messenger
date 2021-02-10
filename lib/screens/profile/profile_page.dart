import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:messenger/models/user.dart';

class ProfileScreen extends HookWidget {
  final User user;

  const ProfileScreen({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            _ProfileImageBuilder(profileUrl: user.photoUrl),
          ],
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
