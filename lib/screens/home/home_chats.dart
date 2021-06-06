import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:messenger/customs/double_listenable.dart';
import 'package:messenger/screens/chats/chats.dart';
import 'package:messenger/services/offline/hive.db/hive_init.dart';
import 'package:messenger/services/offline/hive.db/models/hive_chat.dart';
import 'package:messenger/services/offline/hive.db/models/hive_messages.dart';
import '../../utils/_extensions_.dart';
import 'home_provider.dart';

class HomeChats extends StatelessWidget {
  final HomeProvider homeProvider;
  final StreamController<int?> streamController;
  const HomeChats(this.homeProvider, this.streamController);

  int _indexOf(List<String> iDs, HomeProvider homeProvider,
      {bool isMe = true}) {
    if (!isMe) {
      return iDs.indexWhere((element) {
        print(homeProvider.user.id != element);
        return homeProvider.user.id != element;
      });
    }
    return iDs.indexWhere((element) => homeProvider.user.id == element);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: SizedBox(),
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
                return homeProvider.isme(_iDs);
              }).toList();

              final l = hiveMessage!.values.isNotEmpty
                  ? hiveMessage.values
                      .where((e) => e.isRead == false)
                      .toList()
                      .map((e) => e.chatID!)
                      .toSet()
                  : Set<String>();
              streamController.sink.add(l.length);

              return ListView.builder(
                shrinkWrap: true,
                itemCount: hiveChats.length,
                itemBuilder: (context, index) {
                  final List<String>? _iDs =
                      hiveChats[index].participants!.map((e) => e.id!).toList();
                  final List<HiveMessages> hiveMessages = hiveMessage.values
                      .where((element) =>
                          element.chatID == hiveChats[index].chatId)
                      .toList()
                      .reversed
                      .toList();
                  final List<HiveMessages> isReadMessages = hiveMessages
                      .where((element) => element.isRead == false)
                      .toList();
                  // print(l.length);
                  return ListTile(
                    title: Text(
                      hiveChats[index]
                          .participants![
                              _indexOf(_iDs!, homeProvider, isMe: false)]
                          .userName!
                          .capitalize(),
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
                                  : Theme.of(context).scaffoldBackgroundColor,
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
                          .participants![_indexOf(_iDs, homeProvider)]
                          .userName);
                      print(hiveChats[index]
                          .participants![
                              _indexOf(_iDs, homeProvider, isMe: false)]
                          .userName);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ChatsScreen(hiveChats[index]),
                        ),
                      );
                    },
                    onLongPress: () {
                      homeProvider
                          .deleteChatAndRemovePrintsFromDB(hiveChats[index]);
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
