import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:messenger/services/offline/hive.db/hive_init.dart';
import 'package:messenger/services/offline/hive.db/models/hive_chat.dart';
import 'package:messenger/services/offline/hive.db/models/hive_messages.dart';
import 'package:provider/provider.dart';
import '../../customs/widgets/custom_appbar.dart';
import '../../utils/utils.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'chats_provider.dart';

// ignore: must_be_immutable
class ChatsScreen extends StatelessWidget {
  final LocalChat _localChat;

  ChatsScreen(this._localChat);

  @override
  Widget build(BuildContext context) {
    // print((_localChat as HiveGroupChat).groupAdmins![0].id);

    if (_localChat is HiveChat) {
      final hiveChat = _localChat as HiveChat;
      return _ChatScreen(
        hiveChat: hiveChat,
      );
    } else {
      final hiveGroupChat = _localChat as HiveGroupChat;
      return _HiveGroupChatPage(
        hiveGroupChat: hiveGroupChat,
      );

      // return Scaffold();
    }
  }
}

class _ChatScreen extends HookWidget {
  final HiveChat hiveChat;

  const _ChatScreen({Key? key, required this.hiveChat}) : super(key: key);

  int _indexOf(ChatsProvider _chatsProvider, {bool isMe = true}) {
    final List<String> iDs = [
      hiveChat.participants![0].id!,
      hiveChat.participants![1].id!
    ];
    if (isMe == false)
      return iDs.indexWhere((element) => _chatsProvider.user.id != element);
    return iDs.indexWhere((element) => _chatsProvider.user.id == element);
  }

  @override
  Widget build(BuildContext context) {
    var valueListener = useState<String?>("");
    final _chatsProvider = Provider.of<ChatsProvider>(context);
    final TextEditingController? textEditingController =
        useTextEditingController();
    final scrollController = useScrollController();
    return Scaffold(
      appBar: CustomAppBar(
        isGroupChat: false,
        context: context,
        friendContactName: hiveChat
            .participants![_indexOf(_chatsProvider, isMe: false)].userName,
        photoUrl: hiveChat
            .participants![_indexOf(_chatsProvider, isMe: false)].photoUrl,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: ValueListenableBuilder<Box<HiveMessages>>(
              valueListenable:
                  Hive.box<HiveMessages>(HiveInit.messagesBoxName).listenable(),
              builder: (context, box, child) {
                final List<HiveMessages> hiveMessages = box.values
                    .where((element) => element.chatID == hiveChat.chatId)
                    .toList()
                    .reversed
                    .toList();
                return ListView.builder(
                  itemCount: hiveMessages.length,
                  reverse: true,
                  controller: scrollController,
                  padding: const EdgeInsets.only(
                    bottom: 30,
                    top: 30,
                  ),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemBuilder: (context, index) {
                    //  scrollController.position

                    bool isMe =
                        hiveMessages[index].senderID == _chatsProvider.user.id;
                    _chatsProvider.updateMessageIsRead(hiveMessages[index]);
                    // print(hiveMessages[index])
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
                                    hiveMessages[index].msg!,
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
                                          hiveMessages[index].dateTime!.year,
                                          hiveMessages[index].dateTime!.month,
                                          hiveMessages[index].dateTime!.day,
                                          hiveMessages[index].dateTime!.hour,
                                          hiveMessages[index].dateTime!.minute,
                                          hiveMessages[index].dateTime!.second,
                                          hiveMessages[index]
                                              .dateTime!
                                              .millisecond,
                                          hiveMessages[index]
                                              .dateTime!
                                              .microsecond)
                                      .toLocal()),
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
                    controller: textEditingController,
                    onChanged: (value) {
                      valueListener.value = value;
                    },
                    style: TextStyle(
                        fontSize:
                            Utils.blockWidth * 4.0 //will give 18 by default,
                        ),
                    decoration: InputDecoration(
                      hintText: "Write a Message",
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(right: 20),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: valueListener.value!.length > 0
                      ? () {
                          // print(hiveChat
                          //     .participants![_indexOf(_chatsProvider)].id);
                          // print(hiveChat
                          //     .participants![
                          //         _indexOf(_chatsProvider, isMe: false)]
                          //     .id);
                          String? msg = valueListener.value;
                          _chatsProvider.sendMessage(
                              receiverID: hiveChat
                                  .participants![
                                      _indexOf(_chatsProvider, isMe: false)]
                                  .id!,
                              senderID: hiveChat
                                  .participants![_indexOf(_chatsProvider)].id!,
                              publicKey: hiveChat
                                  .participants![
                                      _indexOf(_chatsProvider, isMe: false)]
                                  .publicKey!,
                              chatId: hiveChat.chatId!,
                              msg: msg,
                              handleExceptionInUi: (e) =>
                                  Fluttertoast.showToast(msg: e));
                          textEditingController!.clear();
                          valueListener.value = "";
                        }
                      : () {
                          print(textEditingController!.text.length);
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

class _HiveGroupChatPage extends HookWidget {
  final HiveGroupChat hiveGroupChat;

  const _HiveGroupChatPage({
    Key? key,
    required this.hiveGroupChat,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(hiveGroupChat.groupCreator.userName);
    var valueListener = useState<String?>("");
    final _chatsProvider = Provider.of<ChatsProvider>(context);
    final TextEditingController? textEditingController =
        useTextEditingController();
    final scrollController = useScrollController();
    return Scaffold(
      appBar: CustomAppBar(
        isGroupChat: true,
        context: context,
        listOfParticipants: hiveGroupChat.participants,
        friendContactName: hiveGroupChat.groupName,
        photoUrl: hiveGroupChat.groupPhotoUrl,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: ValueListenableBuilder<Box<HiveMessages>>(
              valueListenable:
                  Hive.box<HiveMessages>(HiveInit.messagesBoxName).listenable(),
              builder: (context, box, child) {
                final List<HiveMessages> hiveMessages = box.values
                    .where((element) => element.chatID == hiveGroupChat.groupID)
                    .toList()
                    .reversed
                    .toList();
                return ListView.builder(
                  itemCount: hiveMessages.length,
                  reverse: true,
                  controller: scrollController,
                  padding: const EdgeInsets.only(
                    bottom: 30,
                    top: 30,
                  ),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemBuilder: (context, index) {
                    bool isMe =
                        hiveMessages[index].senderID == _chatsProvider.user.id;
                    _chatsProvider.updateMessageIsRead(hiveMessages[index]);
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
                                    hiveMessages[index].msg!,
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
                                          hiveMessages[index].dateTime!.year,
                                          hiveMessages[index].dateTime!.month,
                                          hiveMessages[index].dateTime!.day,
                                          hiveMessages[index].dateTime!.hour,
                                          hiveMessages[index].dateTime!.minute,
                                          hiveMessages[index].dateTime!.second,
                                          hiveMessages[index]
                                              .dateTime!
                                              .millisecond,
                                          hiveMessages[index]
                                              .dateTime!
                                              .microsecond)
                                      .toLocal()),
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
                    controller: textEditingController,
                    onChanged: (value) {
                      valueListener.value = value;
                    },
                    style: TextStyle(
                        fontSize:
                            Utils.blockWidth * 4.0 //will give 18 by default,
                        ),
                    decoration: InputDecoration(
                      hintText: "Write a Message",
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(right: 20),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: valueListener.value!.length > 0
                      ? () {
                          String? msg = valueListener.value;
                          Fluttertoast.showToast(msg: msg!);

                          //                         int _indexOf(ChatsProvider _chatsProvider, {bool isMe = true}) {
                          //   final List<String> iDs = hiveGroupChat.participants!.map((e) => e.id!).toList();
                          //   if (isMe == false){

                          //     return iDs.indexWhere((element) => _chatsProvider.user.id != element);
                          //   }
                          //   return iDs.indexWhere((element) => _chatsProvider.user.id == element);
                          // }

                          ///////////////////////////////////
                          _chatsProvider.sendMessageT(
                              receiverIDs: hiveGroupChat.participants!
                                  .map((e) => e.id!)
                                  .toList(),
                              senderID: hiveGroupChat
                                  .participants![hiveGroupChat.participants!
                                      .map((e) => e.id!)
                                      .toList()
                                      .indexWhere((element) =>
                                          _chatsProvider.user.id == element)]
                                  .id!,
                              chatId: hiveGroupChat.groupID!,
                              msg: msg,
                              handleExceptionInUi: (e) =>
                                  Fluttertoast.showToast(msg: e));
                          textEditingController!.clear();
                          valueListener.value = "";
                        }
                      : () {
                          print(textEditingController!.text.length);
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
