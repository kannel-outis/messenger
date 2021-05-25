import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:messenger/screens/contacts/first_launch_contact.dart';
import 'package:messenger/screens/group/create_group_screen.dart';
import 'package:messenger/screens/home/home_provider.dart';
import 'package:messenger/customs/double_listenable.dart';
import 'package:messenger/services/offline/hive.db/hive_init.dart';
import 'package:messenger/services/offline/hive.db/models/hive_chat.dart';
import 'package:messenger/services/offline/hive.db/models/hive_messages.dart';
import '../../screens/chats/chats.dart';
import 'package:provider/provider.dart';
import '../../screens/settings/settings.dart';
import '../../utils/_extensions_.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // context.read<HomeProvider>().iniState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<HomeProvider>().iniState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _indexOf(List<String> iDs, HomeProvider _homeProvider,
      {bool isMe = true}) {
    if (!isMe)
      return iDs.indexWhere((element) => _homeProvider.user.id != element);
    return iDs.indexWhere((element) => _homeProvider.user.id == element);
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> isDialOpen = ValueNotifier(false);

    final _homeProvider = Provider.of<HomeProvider>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: SizedBox(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Messages',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                Expanded(child: SizedBox()),
                IconButton(
                  icon: Icon(Icons.add_comment),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            FirstLaunchContactScreen(fromHome: true),
                      ),
                    );
                  },
                )
              ],
            ),
            DoubleValueListenableBuilder<Box<HiveChat>, Box<HiveMessages>>(
              valueListenable:
                  Hive.box<HiveChat>(HiveInit.chatBoxName).listenable(),
              valueListenable2:
                  Hive.box<HiveMessages>(HiveInit.messagesBoxName).listenable(),
              builder: (context, hiveChat, hiveMessage, child) {
                final List<HiveChat> hiveChats =
                    hiveChat!.values.where((element) {
                  final List<String>? _iDs = [
                    element.participants![0].id!,
                    element.participants![1].id!
                  ];
                  return _homeProvider.isme(_iDs);
                }).toList();

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: hiveChats.length,
                  itemBuilder: (context, index) {
                    final List<String>? _iDs = [
                      hiveChats[index].participants![0].id!,
                      hiveChats[index].participants![1].id!
                    ];
                    final List<HiveMessages> hiveMessages = hiveMessage!.values
                        .where((element) =>
                            element.chatID == hiveChats[index].chatId)
                        .toList()
                        .reversed
                        .toList();
                    final List<HiveMessages> isReadMessages = hiveMessages
                        .where((element) => element.isRead == false)
                        .toList();
                    return ListTile(
                      title: Text(
                        hiveChats[index]
                                .participants![
                                    _indexOf(_iDs!, _homeProvider, isMe: false)]
                                .userName!
                                .capitalize() ??
                            'Null',
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: hiveMessages.isNotEmpty
                          ? Text(
                              hiveMessages[0].msg ?? "cannot load this message",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: hiveMessages[0].isRead == false
                                    ? FontWeight.w900
                                    : FontWeight.normal,
                                color: hiveMessages[0].isRead == false
                                    ? Colors.black
                                    : Colors.grey,
                                fontSize: 16,
                              ),
                            )
                          : null,
                      trailing: hiveMessages.isNotEmpty
                          ? Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: hiveMessages[0].isRead == false
                                    ? Colors.yellow
                                    : Colors.white,
                                borderRadius: hiveMessages[0].isRead == false
                                    ? BorderRadius.circular(50)
                                    : null,
                              ),
                              child: Center(
                                child: hiveMessages[0].isRead == false
                                    ? Text(
                                        "${isReadMessages.length}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      )
                                    : SizedBox(),
                              ),
                            )
                          : SizedBox(),
                      onTap: () {
                        print(hiveChats[index]
                            .participants![_indexOf(_iDs, _homeProvider)]
                            .id);
                        print(hiveChats[index]
                            .participants![
                                _indexOf(_iDs, _homeProvider, isMe: false)]
                            .id);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ChatsScreen(hiveChats[index]),
                          ),
                        );
                      },
                      onLongPress: () {
                        _homeProvider
                            .deleteChatAndRemovePrintsFromDB(hiveChats[index]);
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      // floatingActionButton: InkWell(
      //   onTap: () {
      // Navigator.of(context)
      //     .push(CupertinoPageRoute(builder: (_) => SettingsScreen()));
      //   },
      //   child: Container(
      //     height: 60,
      //     width: 60,
      //     decoration: BoxDecoration(
      //       color: Colors.yellow,
      //       borderRadius: BorderRadius.circular(5),
      //     ),
      //     child: Center(
      //       child: Icon(Icons.settings),
      //     ),
      //   ),
      // ),
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
            child: Icon(Icons.group),
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
    );
  }
}
