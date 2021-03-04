import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:messenger/services/offline/hive.db/hive_init.dart';
import 'package:messenger/services/offline/hive.db/models/hive_chat.dart';
import 'package:messenger/services/offline/hive.db/models/hive_messages.dart';
import 'package:provider/provider.dart';
import '../../customs/widgets/custom_appbar.dart';
import '../../utils/utils.dart';
import '../../utils/_extensions_.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'chats_provider.dart';

class ChatsScreen extends HookWidget {
  final HiveChat hiveChat;

  ChatsScreen(this.hiveChat);
  @override
  Widget build(BuildContext context) {
    Utils.getBlockHeightAndWidth(context);
    final _textController = useTextEditingController();
    final _chatsProvider = Provider.of<ChatsProvider>(context);
    print(hiveChat.chatId);
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        friendContactName: hiveChat.participants[1].userName,
        photoUrl: hiveChat.participants[1].photoUrl,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: ValueListenableBuilder<Box<HiveMessages>>(
              valueListenable:
                  Hive.box<HiveMessages>(HiveInit.messagesBoxName).listenable(),
              builder: (context, box, child) {
                // DateTime().toLocal();
                final List<HiveMessages> hiveMessages = box.values
                    .where((element) => element.chatID == hiveChat.chatId)
                    .toList()
                    .reversed
                    .toList();
                return ListView.builder(
                  itemCount: hiveMessages.length,
                  reverse: true,
                  padding: const EdgeInsets.only(
                    bottom: 30,
                    top: 30,
                  ),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemBuilder: (context, index) {
                    bool isMe = hiveMessages[index].senderID ==
                        hiveChat.participants[0].id;
                    return Row(
                      mainAxisAlignment: isMe
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: Utils.blockWidth * 55,
                            minWidth: Utils.blockWidth * 15,
                          ),
                          child: Column(
                            children: [
                              Align(
                                alignment: !isMe
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxWidth: Utils.blockWidth * 55,
                                    minWidth: Utils.blockWidth * 15,
                                  ),
                                  padding: const EdgeInsets.only(
                                    top: 20,
                                    left: 20,
                                    bottom: 20,
                                    right: 30,
                                  ),
                                  decoration: BoxDecoration(
                                    color: !isMe
                                        ? Color(0xffFCE5DE)
                                        : Color(0xffDBDBFF),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Text(
                                    hiveMessages[index].msg,
                                    style: TextStyle(
                                        fontSize: Utils.blockWidth * 3.5),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              Container(
                                width: Utils.blockWidth * 45,
                                child: Text(
                                  DateFormat('HH:mm a').format(DateTime(
                                              hiveMessages[index].dateTime.year,
                                              hiveMessages[index]
                                                  .dateTime
                                                  .month,
                                              hiveMessages[index].dateTime.day,
                                              hiveMessages[index].dateTime.hour,
                                              hiveMessages[index]
                                                  .dateTime
                                                  .minute,
                                              hiveMessages[index]
                                                  .dateTime
                                                  .second,
                                              hiveMessages[index]
                                                  .dateTime
                                                  .millisecond,
                                              hiveMessages[index]
                                                  .dateTime
                                                  .microsecond)
                                          .toLocal()) ??
                                      "non",
                                  textAlign:
                                      isMe ? TextAlign.right : TextAlign.left,
                                  style: TextStyle(
                                      fontSize: Utils.blockWidth * 3.3),
                                ),
                              ),
                              SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  shrinkWrap: true,
                );
              },
            ),
          ),
          Container(
            height: 70,
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    style: TextStyle(
                        fontSize:
                            Utils.blockWidth * 4.0 //will give 18 by default,
                        ),
                    decoration: InputDecoration(
                      hintText: "Write a Message",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _textController.text.length > 0
                      ? () {
                          String msg = _textController.text;
                          _chatsProvider.sendMessage(
                              hiveChat: hiveChat, msg: msg);
                          _textController.clear();
                        }
                      : () {
                          print('Null pressed');
                        },
                  child: Container(
                    width: 100,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: Center(
                      child: Text(
                        'SEND',
                        style: TextStyle(
                          fontSize: Utils.blockWidth * 4.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
