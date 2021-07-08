import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/screens/home/home_provider.dart';
import 'package:messenger/utils/constants.dart';
import 'package:provider/provider.dart';
import '../../customs/custom_route.dart';
import '../../screens/profile/profile_page.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    User? user = context.read<HomeProvider>().user;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            _TopAppBar(),
            SizedBox(height: 10),
            _ProfileTopSec(user: user),
            InkWell(
              onTap: () async {
                User? returnUserValue = await Navigator.of(context).push(
                  CustomRoute<User>(
                    builder: (_) => ProfileScreen(user: user),
                  ),
                );
                if (user != returnUserValue) {
                  setState(() {
                    user = returnUserValue;
                  });
                }
              },
              child: Container(
                height: 40,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Edit',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Icon(Icons.edit, color: Colors.white),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _TopAppBar extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      // height: 30,
      // width: double.infinity,
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Row(
        children: [
          IconButton(
            icon: Icon(CupertinoIcons.back),
            iconSize: 30,
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}

class _ProfileTopSec extends StatelessWidget {
  final User? user;

  const _ProfileTopSec({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Hero(
              tag: 'profielImage',
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                      color: Colors.red, style: BorderStyle.solid, width: 2),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      user!.photoUrl ?? GeneralConstants.DEFAULT_PHOTOURL,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: Column(
              children: [
                SizedBox(height: 15),
                Container(
                  child: Text(
                    user!.userName ?? "username",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  child: Text(
                    user!.phoneNumbers![0] ?? "phoneNumber",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
