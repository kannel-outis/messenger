import 'package:flutter/material.dart';
import 'package:messenger/services/offline/hive.db/models/hive_chat.dart';
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
    return Scaffold(
      appBar: CustomAppBar(
        height: 150,
        friendContactName: hiveChat.participants[1].userName,
        photoUrl: hiveChat.participants[1].photoUrl,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
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
