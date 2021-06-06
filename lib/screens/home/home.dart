import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:messenger/screens/contacts/first_launch_contact.dart';
import 'package:messenger/screens/group/create_group_screen.dart';
import 'package:messenger/screens/home/home_provider.dart';
import 'package:provider/provider.dart';
import '../../screens/settings/settings.dart';
import 'home_chats.dart';
import 'home_groups.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late final PageController _pageController;
  late final StreamController<int?> _streamControllerC;
  late final StreamController<int?> _streamControllerG;
  String? count;
  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _streamControllerC = StreamController<int?>.broadcast();
    _streamControllerG = StreamController<int?>.broadcast();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    context.read<HomeProvider>().iniState();
  }

  @override
  void dispose() {
    _streamControllerC.close();
    _streamControllerG.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _homeProvider = Provider.of<HomeProvider>(context);

    ValueNotifier<bool> isDialOpen = ValueNotifier(false);
    final size = MediaQuery.of(context).size.height / 100;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: size * 7 > 100 ? 100 : size * 7,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        title: Text(
          '',
          style: TextStyle(
              fontSize: 35, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() => selectedIndex = index);
        },
        controller: _pageController,
        children: [
          HomeChats(_homeProvider, _streamControllerC),
          HomeGroup(_homeProvider, _streamControllerG),
        ],
      ),
      floatingActionButton: SpeedDial(
        marginEnd: 18,
        marginBottom: 20,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        icon: Icons.add,
        activeIcon: Icons.remove, openCloseDial: isDialOpen,
        useRotationAnimation: true,

        buttonSize: 56.0,
        visible: true,
        closeManually: true,

        /// If true overlay will render no matter what.
        renderOverlay: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8.0,
        shape: CircleBorder(),

        children: [
          SpeedDialChild(
            child: Icon(Icons.settings),
            backgroundColor: Colors.red,
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              isDialOpen.value = false;
              Navigator.of(context)
                  .push(CupertinoPageRoute(builder: (_) => SettingsScreen()));
            },
            onLongPress: () => print('FIRST CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: Icon(Icons.add_comment),
            backgroundColor: Colors.green,
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              isDialOpen.value = false;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => FirstLaunchContactScreen(fromHome: true),
                ),
              );
            },
            onLongPress: () => print('FIRST CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: Icon(Icons.group_add),
            backgroundColor: Colors.blue,
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              isDialOpen.value = false;
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => CreateGroupScreen(), fullscreenDialog: true));
            },
            onLongPress: () => print('SECOND CHILD LONG PRESS'),
          ),
        ],
      ),
      bottomNavigationBar: StreamBuilder<int?>(
        stream: _streamControllerC.stream,
        initialData: 0,
        builder: (context, snap) {
          return StreamBuilder<int?>(
            stream: _streamControllerG.stream,
            initialData: 0,
            builder: (context, shot) {
              return BottomNavigationBar(
                currentIndex: selectedIndex,
                selectedItemColor: Colors.deepOrange,
                onTap: (value) {
                  setState(() => selectedIndex = value);
                  _pageController.animateToPage(selectedIndex,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.chat),
                      label:
                          "Chats ${snap.data == 0 ? ("") : "(${snap.data})"}"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.group),
                      label:
                          "Groups ${shot.data == 0 ? ("") : "(${shot.data})"}"),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
