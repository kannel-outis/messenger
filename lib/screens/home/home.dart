import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:messenger/screens/contacts/contacts.dart';
import 'package:messenger/screens/group/create_group_screen.dart';
import 'package:messenger/screens/home/home_provider.dart';
import 'package:messenger/utils/utils.dart';
import 'package:provider/provider.dart';
import '../../screens/settings/settings.dart';
import 'home_chats.dart';
import 'home_groups.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final StreamController<int?> _streamControllerC;
  late final StreamController<int?> _streamControllerG;
  late final FocusNode _focusNode;
  late final TextEditingController _textEditingController;
  String? count;
  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    context.read<HomeProvider>().iniState();
    _focusNode = FocusNode();
    _textEditingController = TextEditingController();
    _pageController = PageController();
    _streamControllerC = StreamController<int?>.broadcast();
    _streamControllerG = StreamController<int?>.broadcast();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // context.read<HomeProvider>().iniState();
  }

  @override
  void dispose() {
    _streamControllerC.close();
    _streamControllerG.close();
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _homeProvider = Provider.of<HomeProvider>(context);

    ValueNotifier<bool> isDialOpen = ValueNotifier(false);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight:
            Utils.blockHeight * 7 > 100 ? 100 : Utils.blockHeight * 7,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        title: Text(
          'Conversations',
          style: TextStyle(
              fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            // height: 100,
            // color: Colors.pink,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width / 100 * 80,
                padding: EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: TextField(
                  focusNode: _focusNode,
                  controller: _textEditingController,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    hintText: "Search Conversation",
                    alignLabelWithHint: true,
                    icon: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    focusedBorder:
                        UnderlineInputBorder(borderSide: BorderSide.none),
                    border: UnderlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() => selectedIndex = index);
              },
              controller: _pageController,
              children: [
                HomeChats(
                    _homeProvider, _streamControllerC, _streamControllerG),
                HomeGroup(_homeProvider),
              ],
            ),
          ),
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

        buttonSize: Utils.blockWidth * 15 > 56.0 ? 56.0 : Utils.blockWidth * 15,
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
                  builder: (_) => ContactsScreen(fromHome: true),
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
