import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:messenger/services/offline/hive.db/hive_init.dart';
import 'package:messenger/services/offline/hive.db/models/hive_chat.dart';
import 'package:messenger/services/offline/hive.db/models/hive_messages.dart';
import 'package:provider/provider.dart';
import '../../customs/widgets/custom_appbar.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'chats_provider.dart';

class ChatsScreen extends HookWidget {
  final HiveChat hiveChat;

  ChatsScreen(this.hiveChat);
  @override
  Widget build(BuildContext context) {
    final _textController = useTextEditingController();
    final _chatsProvider = Provider.of<ChatsProvider>(context);
    print(hiveChat.chatId);
    return Scaffold(
      appBar: CustomAppBar(
        height: 150,
        friendContactName: hiveChat.participants[1].userName,
        photoUrl: hiveChat.participants[1].photoUrl,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ValueListenableBuilder<Box<HiveMessages>>(
            valueListenable:
                Hive.box<HiveMessages>(HiveInit.messagesBoxName).listenable(),
            builder: (context, box, child) {
              final List<HiveMessages> hiveMessages = box.values
                  .where((element) => element.chatID == hiveChat.chatId)
                  .toList();
              return ListView.builder(
                shrinkWrap: true,
                itemCount: hiveMessages.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: Text(hiveMessages[index].msg),
                  );
                },
              );
            },
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: TextFormField(
                    controller: _textController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          print(_textController.text);
                          String msg = _textController.text;
                          _chatsProvider.sendMessage(
                              hiveChat: hiveChat, msg: msg);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
