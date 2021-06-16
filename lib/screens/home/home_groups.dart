import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:messenger/customs/double_listenable.dart';
import 'package:messenger/customs/widgets/custom_chat_list_tile.dart';
import 'package:messenger/customs/widgets/modal_dialog.dart';
import 'package:messenger/screens/chats/chats.dart';
import 'package:messenger/screens/home/home_provider.dart';
import 'package:messenger/services/offline/hive.db/hive_init.dart';
import 'package:messenger/services/offline/hive.db/models/hive_chat.dart';
import 'package:messenger/services/offline/hive.db/models/hive_messages.dart';
import '../../utils/_extensions_.dart';

class HomeGroup extends StatelessWidget {
  final HomeProvider homeProvider;
  // final StreamController<int?> _streamController;
  const HomeGroup(this.homeProvider);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SizedBox(),
            ),
            Expanded(
              child: DoubleValueListenableBuilder<Box<HiveGroupChat>,
                  Box<HiveMessages>>(
                valueListenable:
                    Hive.box<HiveGroupChat>(HiveInit.hiveGroupChatsBoxName)
                        .listenable(),
                valueListenable2:
                    Hive.box<HiveMessages>(HiveInit.messagesBoxName)
                        .listenable(),
                builder: (context, hiveChat, hiveMessage, child) {
                  // final List<HiveGroupChat> hiveGroupChats =
                  //     hiveChat!.values.where((element) {
                  //   final List<String> _iDs =
                  //       element.participants!.map((e) => e.id!).toList();
                  //   return homeProvider.contains(_iDs);
                  // }).toList();
                  final List<HiveGroupChat> hiveGroupChats =
                      hiveChat!.values.toList();

                  // final l = hiveMessage!.values.isNotEmpty
                  //     ? hiveMessage.values
                  //         .where((e) => e.isRead == false && e.isGroup == true)
                  //         .toList()
                  //         .map((e) => e.chatID!)
                  //         .toSet()
                  //     : Set<String>();
                  // _streamController.sink.add(l.length);

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: hiveGroupChats.length,
                    itemBuilder: (context, index) {
                      final List<HiveMessages> hiveMessages = hiveMessage!
                          .values
                          .where((element) =>
                              element.chatID == hiveGroupChats[index].groupID)
                          .toList()
                          .reversed
                          .toList();
                      final List<HiveMessages> isReadMessages = hiveMessages
                          .where((element) => element.isRead == false)
                          .toList();

                      final title =
                          hiveGroupChats[index].groupName.capitalize();
                      final photoUrl = hiveGroupChats[index].groupPhotoUrl;
                      return CustomChatListTile(
                        title: title,
                        subtitle: hiveMessages.isNotEmpty
                            ? hiveMessages[0].senderID == homeProvider.user.id
                                ? "you: ${hiveMessages[0].msg}"
                                : "${hiveGroupChats[index].participants!.where((element) => element.id == hiveMessages[0].senderID).single.userName}: ${hiveMessages[0].msg}"
                            : null,
                        photoUrl: photoUrl,
                        dateTime: hiveMessages.isNotEmpty
                            ? hiveMessages[0].dateTime
                            : null,
                        isRead: hiveMessages.isNotEmpty
                            ? hiveMessages[0].isRead
                            : null,
                        messageCount:
                            hiveMessages.isNotEmpty ? isReadMessages.length : 0,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  ChatsScreen(hiveGroupChats[index]),
                            ),
                          );
                        },
                        onLongPress: () async {
                          await showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return BottomModalSheet(
                                  chat: hiveGroupChats[index], isGroup: true);
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
