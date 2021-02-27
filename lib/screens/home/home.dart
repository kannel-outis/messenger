import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:messenger/screens/home/home_provider.dart';
import 'package:messenger/services/offline/hive.db/hive_init.dart';
import 'package:messenger/services/offline/hive.db/models/hive_chat.dart';
import 'package:messenger/services/online/mqtt/mqtt_handler.dart';
import '../../screens/chats/chats.dart';
import 'package:provider/provider.dart';
import '../../screens/settings/settings.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MQTThandler().login().then((value) {
      context.read<HomeProvider>().listenTocloudStreamAndSubscribeTopic();
    });
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
                    onPressed: () => print('Icon Pressed'))
              ],
            ),
            ValueListenableBuilder<Box<HiveChat>>(
              valueListenable:
                  Hive.box<HiveChat>(HiveInit.chatBoxName).listenable(),
              builder: (context, box, child) {
                final List<HiveChat> hiveChats = box.values
                    .where((element) =>
                        _homeProvider.isme(element.participants[0].id))
                    .toList();
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: hiveChats.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                          hiveChats[index].participants[1].userName ?? 'Null'),
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
            )
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
