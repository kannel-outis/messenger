part of 'profile_info_page.dart';

class _GroupProfileInfoPage extends StatelessWidget {
  final HiveGroupChat _chat;
  const _GroupProfileInfoPage(this._chat);
  @override
  Widget build(BuildContext context) {
    final _providerInfoProvider = Provider.of<ProfileInfoProvider>(context);
    final message =
        _providerInfoProvider.getLastMessage(chatId: _chat.id!, isGroup: true);
    final l = _chat.groupAdmins!.map((e) => e.id).toList();

    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      return Scaffold(
        body: Stack(
          children: [
            Row(
              children: [
                Container(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        width: Utils.blockHeight * 50,
                        height: Utils.blockWidth * 100,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                                _chat.groupPhotoUrl!),
                          ),
                        ),
                      ),
                      Container(
                        height: 100,
                        width: Utils.blockHeight * 50,
                        // color: Colors.pink,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.3, 0.8],
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.25),
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _chat.groupName.capitalize(),
                              textScaleFactor: .7,
                              style: TextStyle(
                                fontSize: Utils.blockWidth * 4 > 25
                                    ? 25
                                    : Utils.blockWidth * 4 < 17
                                        ? 17
                                        : Utils.blockWidth * 4,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              message == null
                                  ? "No messages yet"
                                  : "Last message: ${message.msg}",
                              style: TextStyle(
                                fontSize: Utils.blockWidth * 3.3 > 25
                                    ? 25
                                    : Utils.blockWidth * 3.3 < 18
                                        ? 18
                                        : Utils.blockWidth * 3.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
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
                                  width: Utils.blockHeight * 100,
                                  height: Utils.blockWidth * 10,
                                  // color: Colors.red,
                                  constraints: BoxConstraints(
                                    maxHeight: 250,
                                    maxWidth: double.infinity,
                                    minWidth: double.infinity,
                                    minHeight: 120,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            Text(
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
                                // SizedBox(height: 20),
                                // kjsgbjsbdkjdbsfkjbskdhbksjdf
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
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
                                    l.contains(e.id),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () => print("something"),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        CupertinoIcons.slash_circle,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Block",
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15),
                                ElevatedButton(
                                  onPressed: () => print("something"),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        CupertinoIcons.delete,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Delete",
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ChatsScreen(_chat),
                    ),
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

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        height: Utils.blockHeight * 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                                _chat.groupPhotoUrl!),
                          ),
                        ),
                      ),
                      Container(
                        height: 100,
                        width: double.infinity,
                        // color: Colors.pink,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.3, 0.8],
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.25),
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _chat.groupName.capitalize(),
                              textScaleFactor: .7,
                              style: TextStyle(
                                fontSize: Utils.blockWidth * 4 > 25
                                    ? 25
                                    : Utils.blockWidth * 4 < 17
                                        ? 17
                                        : Utils.blockWidth * 4,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              message == null
                                  ? "No messages yet"
                                  : "Last message: ${message.msg}",
                              style: TextStyle(
                                fontSize: Utils.blockWidth * 3.3 > 25
                                    ? 25
                                    : Utils.blockWidth * 3.3 < 18
                                        ? 18
                                        : Utils.blockWidth * 3.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                                Text(
                                  _chat.groupDescription!,
                                  style: TextStyle(
                                      fontSize: Utils.blockWidth * 3.3 > 25
                                          ? 25
                                          : Utils.blockWidth * 3.3 < 18
                                              ? 18
                                              : Utils.blockWidth * 3.3),
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
                          l.contains(e.id),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // ElevatedButton(
                      //   onPressed: () => print("something"),
                      //   child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Icon(
                      //         CupertinoIcons.delete_right,
                      //         color: Colors.white,
                      //         size: 20,
                      //       ),
                      //       SizedBox(width: 10),
                      //       Text(
                      //         "leave Group",
                      //         style: TextStyle(
                      //           fontSize: 18,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () => print("something"),
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
                              "Delete",
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ChatsScreen(_chat),
                  ),
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

// Prefix	Mr.
// First Name	Afolabi
// Last Name	Kolawole
// Organization	comercial secondary school akure
// Position/Title	pricipal
// Relationship	boss
// Telephone	+234 803 479 1588
// Email	www.afolabikolawole@gmail.com
