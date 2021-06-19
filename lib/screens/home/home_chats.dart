import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:messenger/customs/double_listenable.dart';
import 'package:messenger/customs/widgets/custom_chat_list_tile.dart';
import 'package:messenger/customs/widgets/modal_dialog.dart';
import 'package:messenger/screens/chats/chats.dart';
import 'package:messenger/services/offline/hive.db/hive_init.dart';
import 'package:messenger/services/offline/hive.db/models/hive_chat.dart';
import 'package:messenger/services/offline/hive.db/models/hive_messages.dart';
import 'package:messenger/utils/constants.dart';
import '../../utils/_extensions_.dart';
import 'home_provider.dart';

class HomeChats extends StatelessWidget {
  final HomeProvider homeProvider;
  final StreamController<int?> streamController;
  final StreamController<int?> streamControllerG;
  const HomeChats(
      this.homeProvider, this.streamController, this.streamControllerG);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SizedBox(),
          ),
          Expanded(
            child:
                DoubleValueListenableBuilder<Box<HiveChat>, Box<HiveMessages>>(
              valueListenable:
                  Hive.box<HiveChat>(HiveInit.chatBoxName).listenable(),
              valueListenable2:
                  Hive.box<HiveMessages>(HiveInit.messagesBoxName).listenable(),
              builder: (context, hiveChat, hiveMessage, child) {
                final List<HiveChat> hiveChats = hiveChat!.values
                    .where((element) => element.participants!.containsUser())
                    .toList();
                streamControllerG.sink
                    .add(messages(message: hiveMessage!, isGroup: true).length);
                streamController.sink
                    .add(messages(message: hiveMessage).length);

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: hiveChats.length,
                  itemBuilder: (context, index) {
                    final List<String>? _iDs = hiveChats[index]
                        .participants!
                        .map((e) => e.id!)
                        .toList();
                    final List<HiveMessages> hiveMessages = hiveMessage.values
                        .where((element) =>
                            element.chatID == hiveChats[index].chatId)
                        .toList()
                        .reversed
                        .toList();
                    final List<HiveMessages> isReadMessages = hiveMessages
                        .where((element) => element.isRead == false)
                        .toList();

                    final title = hiveChats[index]
                        .participants![
                            _indexOf(_iDs!, homeProvider, isMe: false)]
                        .userName!
                        .capitalize();
                    final photoUrl = hiveChats[index]
                            .participants![
                                _indexOf(_iDs, homeProvider, isMe: false)]
                            .photoUrl ??
                        GeneralConstants.DEFAULT_PHOTOURL;

                    return CustomChatListTile(
                      title: title,
                      subtitle: hiveMessages.isNotEmpty
                          ? hiveMessages[0].msg
                          : "Tap to Start a direct message with $title",
                      messageCount:
                          hiveMessages.isNotEmpty ? isReadMessages.length : 0,
                      photoUrl: photoUrl,
                      isRead: hiveMessages.isNotEmpty
                          ? hiveMessages[0].isRead
                          : null,
                      dateTime: hiveMessages.isNotEmpty
                          ? hiveMessages[0].dateTime
                          : null,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ChatsScreen(hiveChats[index]),
                          ),
                        );
                      },
                      onLongPress: () async {
                        await showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return BottomModalSheet(chat: hiveChats[index]);
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
    );
  }
}

int _indexOf(List<String> iDs, HomeProvider homeProvider, {bool isMe = true}) {
  if (!isMe) {
    return iDs.indexWhere((element) {
      return homeProvider.user.id != element;
    });
  }
  return iDs.indexWhere((element) => homeProvider.user.id == element);
}

Set<String> messages(
    {bool isGroup = false, required Box<HiveMessages> message}) {
  return message.values.isNotEmpty
      ? message.values
          .where((e) => e.isRead == false && e.isGroup == false)
          .toList()
          .map((e) => e.chatID!)
          .toSet()
      : Set<String>();
}
