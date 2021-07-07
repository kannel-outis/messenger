part of 'profile_info_page.dart';

class _GroupProfileInfoPage extends StatefulWidget {
  final LocalChat chat;
  _GroupProfileInfoPage(this.chat);
  __GroupProfileInfoPageState createState() => __GroupProfileInfoPageState();
}

class __GroupProfileInfoPageState extends State<_GroupProfileInfoPage> {
  late HiveGroupChat _chat;
  late final String delete;

  @override
  void initState() {
    super.initState();
    _chat = widget.chat as HiveGroupChat;
    delete = _chat.participants!.containsUser() ? "Delete" : "Leave";
  }

  @override
  Widget build(BuildContext context) {
    final _profileInfoProvider = Provider.of<ProfileInfoProvider>(context);
    final message =
        _profileInfoProvider.getLastMessage(chatId: _chat.id!, isGroup: true);

    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      return _LandScape(
          chat: _chat,
          message: message,
          removeFromChat: () => _removeFromChat(_profileInfoProvider),
          delete: delete);
    }

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                CustomProfileInfoAppBar(
                  orientation: Orientation.portrait,
                  name: _chat.groupName.capitalize(),
                  isGroupChat: true,
                  canEdit: _chat.groupAdmins!.containsUser() &&
                      _chat.participants!.containsUser(),
                  photoUrl: _chat.groupPhotoUrl!,
                  lastMessage: message == null
                      ? "No messages yet"
                      : "Last message: ${message.msg}",
                  onPressed: () async {
                    final chat = await Navigator.pushNamed<HiveGroupChat?>(
                      context,
                      RouteGenerator.updateGroupInfo,
                      arguments: UpdateGroupInfoArgument(hiveGroupChat: _chat),
                    );
                    if (chat != null) {
                      _chat = chat;
                      setState(() => null);
                    }
                  },
                ),
                SizedBox(height: 20),
                Container(
                  // color: Colors.yellow,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "About",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: Utils.blockWidth * 6 > 45
                              ? 50
                              : Utils.blockWidth * 6 < 30
                                  ? 30
                                  : Utils.blockWidth * 6,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: Utils.blockHeight * 10,
                        width: double.infinity,
                        // color: Colors.red,
                        constraints: BoxConstraints(
                          maxHeight: 250,
                          maxWidth: double.infinity,
                          minWidth: double.infinity,
                          minHeight: 150,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 30),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  CupertinoIcons.info,
                                  color: Colors.red,
                                  size: Utils.blockWidth * 3.3 > 25
                                      ? 25
                                      : Utils.blockWidth * 3.3 < 18
                                          ? 18
                                          : Utils.blockWidth * 3.3,
                                ),
                                SizedBox(width: 30),
                                Expanded(
                                  child: Text(
                                    _chat.groupDescription!,
                                    style: TextStyle(
                                        fontSize: Utils.blockWidth * 3.3 > 25
                                            ? 25
                                            : Utils.blockWidth * 3.3 < 18
                                                ? 18
                                                : Utils.blockWidth * 3.3),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  CupertinoIcons.calendar,
                                  color: Colors.red,
                                  size: Utils.blockWidth * 3.3 > 25
                                      ? 25
                                      : Utils.blockWidth * 3.3 < 18
                                          ? 18
                                          : Utils.blockWidth * 3.3,
                                ),
                                SizedBox(width: 30),
                                Text(
                                  "Created on: ${_chat.groupCreationTimeDate.toString()}",
                                  style: TextStyle(
                                    fontSize: Utils.blockWidth * 3.3 > 25
                                        ? 25
                                        : Utils.blockWidth * 3.3 < 18
                                            ? 18
                                            : Utils.blockWidth * 3.3,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(height: 20),
                      // kjsgbjsbdkjdbsfkjbskdhbksjdf
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Text(
                        "Participants(${_chat.participants!.length})",
                        style: TextStyle(
                          fontSize: Utils.blockWidth * 3 > 20
                              ? 20
                              : Utils.blockWidth * 3 < 17
                                  ? 17
                                  : Utils.blockWidth * 3,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      ..._chat.participants!.map(
                        (e) => _BuildParticipantsTile(
                          e,
                          _chat.groupAdmins!.containsUser(e),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () {
                          _removeFromChat(_profileInfoProvider);
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.delete,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Text(
                              delete,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 10,
            top: Utils.blockHeight * 47,
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  RouteGenerator.chatScreen,
                  arguments: ChatsScreenArgument(_chat),
                );
              },
              child: Container(
                alignment: Alignment.bottomRight,
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Icon(CupertinoIcons.chat_bubble),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<User> _manageGroupAdmin(
      List<User> groupAdmins, List<User> groupParticipants) {
    final List<String> pIds = groupParticipants.map((e) => e.id!).toList();
    final List<String> aIds = groupAdmins.map((e) => e.id!).toList();
    late final Set<String> newAdmins;
    for (var id in aIds) {
      if (!pIds.contains(id) && aIds.length == 1) {
        newAdmins = {pIds.first};
      } else {
        newAdmins = {...aIds};
      }
    }
    return groupParticipants
        .where((element) => newAdmins.contains(element.id))
        .toList();
  }

  void _removeFromChat(ProfileInfoProvider _profileInfoProvider) {
    bool stillaParticipant = _chat.participants!.containsUser();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "SlideBarrierLabel",
      transitionDuration: Duration(milliseconds: 200),
      transitionBuilder: (context, ani1, ani2, child) {
        return FadeTransition(
          opacity: ani1,
          child: ScaleTransition(
            scale: ani1,
            child: child,
          ),
        );
      },
      pageBuilder: (context, ani1, ani2) {
        return alert.AlertDialog(
          title: stillaParticipant ? "Delete Group Chat" : "Leave Group Chat",
          details: stillaParticipant
              ? "You will no longer be able to send message to this group. You will no longer listen to updates from this group"
              : "All chats and messages related to this group will be deleted .you will no longer receive messages",
          rightButtonChild: stillaParticipant
              ? null
              : Row(
                  children: [
                    Icon(Icons.exit_to_app_rounded, size: 20),
                    SizedBox(width: 10),
                    Text(
                      'Leave',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
          rightButtonAction: () {
            if (stillaParticipant) {
              _chat.participants!.removeWhere((element) =>
                  element.id == _profileInfoProvider.userPrefData.id);
              _chat.groupAdmins =
                  _manageGroupAdmin(_chat.groupAdmins!, _chat.participants!);
              setState(() {});
              _profileInfoProvider
                  .leaveGroupChat(_chat)
                  .then((value) => _chat.save());
              Fluttertoast.showToast(msg: "Removed From Group");
              Navigator.pop(context);
            } else {
              _profileInfoProvider.deleteChatsAndMsssagesFromDB(_chat);
              Fluttertoast.showToast(msg: "Group deleted");
              Navigator.popUntil(context, (route) => route.isFirst);
            }
          },
        );
      },
    );
  }
}

class _LandScape extends StatefulWidget {
  final HiveMessages? message;
  final HiveGroupChat chat;
  final VoidCallback removeFromChat;
  final String? delete;
  // final List<String?> listOfIds;

  const _LandScape({
    Key? key,
    required this.message,
    required this.chat,
    required this.removeFromChat,
    this.delete,
    // required this.listOfIds,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => __LandScapeState();
}

class __LandScapeState extends State<_LandScape> {
  late final HiveMessages? message;
  late HiveGroupChat _chat;
  @override
  void initState() {
    super.initState();
    message = widget.message;
    _chat = widget.chat;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              CustomProfileInfoAppBar(
                orientation: Orientation.landscape,
                name: _chat.groupName.capitalize(),
                isGroupChat: true,
                canEdit: _chat.groupAdmins!.containsUser() &&
                    _chat.participants!.containsUser(),
                photoUrl: _chat.groupPhotoUrl!,
                lastMessage: message == null
                    ? "No messages yet"
                    : "Last message: ${message!.msg}",
                onPressed: () async {
                  final chat = await Navigator.pushNamed<HiveGroupChat?>(
                    context,
                    RouteGenerator.updateGroupInfo,
                    arguments: UpdateGroupInfoArgument(hiveGroupChat: _chat),
                  );
                  if (chat != null) {
                    _chat = chat;
                    setState(() => null);
                  }
                },
              ),
              Expanded(
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "About",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: Utils.blockWidth * 6 > 45
                                      ? 50
                                      : Utils.blockWidth * 6 < 30
                                          ? 30
                                          : Utils.blockWidth * 6,
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                width: Utils.blockHeight * 100,
                                height: Utils.blockWidth * 10,
                                constraints: BoxConstraints(
                                  maxHeight: 250,
                                  maxWidth: double.infinity,
                                  minWidth: double.infinity,
                                  minHeight: 120,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            CupertinoIcons.info,
                                            color: Colors.red,
                                            size: Utils.blockWidth * 3.3 > 25
                                                ? 25
                                                : Utils.blockWidth * 3.3 < 18
                                                    ? 18
                                                    : Utils.blockWidth * 3.3,
                                          ),
                                          SizedBox(width: 30),
                                          Expanded(
                                            child: Text(
                                              _chat.groupDescription!,
                                              style: TextStyle(
                                                  fontSize: Utils.blockWidth *
                                                              3.3 >
                                                          25
                                                      ? 25
                                                      : Utils.blockWidth * 3.3 <
                                                              18
                                                          ? 18
                                                          : Utils.blockWidth *
                                                              3.3),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 30),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          CupertinoIcons.calendar,
                                          color: Colors.red,
                                          size: Utils.blockWidth * 3.3 > 25
                                              ? 25
                                              : Utils.blockWidth * 3.3 < 18
                                                  ? 18
                                                  : Utils.blockWidth * 3.3,
                                        ),
                                        SizedBox(width: 30),
                                        Text(
                                          "Created on: ${_chat.groupCreationTimeDate.toString()}",
                                          style: TextStyle(
                                            fontSize: Utils.blockWidth * 3.3 >
                                                    25
                                                ? 25
                                                : Utils.blockWidth * 3.3 < 18
                                                    ? 18
                                                    : Utils.blockWidth * 3.3,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              Text(
                                "Participants(${_chat.participants!.length})",
                                style: TextStyle(
                                  fontSize: Utils.blockWidth * 3 > 20
                                      ? 20
                                      : Utils.blockWidth * 3 < 17
                                          ? 17
                                          : Utils.blockWidth * 3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              ..._chat.participants!.map(
                                (e) => _BuildParticipantsTile(
                                  e,
                                  _chat.groupAdmins!.containsUser(e),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              SizedBox(height: 15),
                              ElevatedButton(
                                onPressed: widget.removeFromChat,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      CupertinoIcons.delete,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      widget.delete!,
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          Positioned(
            bottom: 10,
            right: Utils.blockHeight * 47,
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  RouteGenerator.chatScreen,
                  arguments: ChatsScreenArgument(_chat),
                );
                // Navigator.pop(context);
              },
              child: Container(
                alignment: Alignment.bottomRight,
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Icon(CupertinoIcons.chat_bubble),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
