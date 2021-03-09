import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:messenger/screens/contacts/first_launch_contact.dart';
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
    context.read<HomeProvider>().iniState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // MQTThandler().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                final List<HiveChat> hiveChats = hiveChat!.values
                    .where((element) =>
                        _homeProvider.isme(element.participants![0].id))
                    .toList();

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: hiveChats.length,
                  itemBuilder: (context, index) {
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
                                .participants![1]
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ChatsScreen(hiveChats[index]),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.of(context)
              .push(CupertinoPageRoute(builder: (_) => SettingsScreen()));
        },
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Icon(Icons.settings),
          ),
        ),
      ),
    );
  }
}
