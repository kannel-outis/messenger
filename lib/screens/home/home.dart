import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:messenger/screens/home/home_provider.dart';
import 'package:messenger/services/offline/hive.db/hive_init.dart';
import 'package:messenger/services/offline/hive.db/models/hive_chat.dart';
import '../../screens/chats/chats.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
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
                  // final HiveChat hiveChat = box.get(keys[index]);

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
    ));
  }
}
