part of 'profile_info_page.dart';

class _UserProfileInfoPage extends StatelessWidget {
  final LocalChat _chat;
  const _UserProfileInfoPage(this._chat);
  @override
  Widget build(BuildContext context) {
    final _providerInfoProvider = Provider.of<ProfileInfoProvider>(context);
    final user = _chat.participants!
        .where((element) => element.id != context.read<HomeProvider>().user.id)
        .single;
    final message = _providerInfoProvider.getLastMessage(
        userId: user.id!, chatId: _chat.id!);
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
                            image: CachedNetworkImageProvider(user.photoUrl!),
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
                              user.userName!.capitalize(),
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
                  width: Utils.blockHeight * 50 - 20,
                  height: Utils.blockWidth * 100,
                  // color: Colors.yellow,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
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
                                height: Utils.blockHeight * 15,
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
                                    SizedBox(height: 15),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          CupertinoIcons.phone,
                                          color: Colors.red,
                                          size: Utils.blockWidth * 3.3 > 25
                                              ? 25
                                              : Utils.blockWidth * 3.3 < 18
                                                  ? 18
                                                  : Utils.blockWidth * 3.3,
                                        ),
                                        SizedBox(width: 30),
                                        Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                user.phoneNumbers![0]
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: Utils.blockWidth *
                                                              3.3 >
                                                          25
                                                      ? 25
                                                      : Utils.blockWidth * 3.3 <
                                                              18
                                                          ? 18
                                                          : Utils.blockWidth *
                                                              3.3,
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              Text(
                                                user.phoneNumbers![1]
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: Utils.blockWidth *
                                                              3.3 >
                                                          25
                                                      ? 25
                                                      : Utils.blockWidth * 3.3 <
                                                              18
                                                          ? 18
                                                          : Utils.blockWidth *
                                                              3.3,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 30),
                                    Row(
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
                                          user.status!,
                                          style: TextStyle(
                                              fontSize: Utils.blockWidth * 3.3 >
                                                      25
                                                  ? 25
                                                  : Utils.blockWidth * 3.3 < 18
                                                      ? 18
                                                      : Utils.blockWidth * 3.3),
                                        ),
                                      ],
                                    ),
                                  ],
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                ),
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
          Column(
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
                          image: CachedNetworkImageProvider(user.photoUrl!),
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
                            user.userName!.capitalize(),
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
                height: Utils.blockHeight * 50 - 20,
                width: double.infinity,
                // color: Colors.yellow,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
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
                            height: Utils.blockHeight * 15,
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
                                SizedBox(height: 15),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      CupertinoIcons.phone,
                                      color: Colors.red,
                                      size: Utils.blockWidth * 3.3 > 25
                                          ? 25
                                          : Utils.blockWidth * 3.3 < 18
                                              ? 18
                                              : Utils.blockWidth * 3.3,
                                    ),
                                    SizedBox(width: 30),
                                    Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user.phoneNumbers![0].toString(),
                                            style: TextStyle(
                                              fontSize: Utils.blockWidth * 3.3 >
                                                      25
                                                  ? 25
                                                  : Utils.blockWidth * 3.3 < 18
                                                      ? 18
                                                      : Utils.blockWidth * 3.3,
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Text(
                                            user.phoneNumbers![1].toString(),
                                            style: TextStyle(
                                              fontSize: Utils.blockWidth * 3.3 >
                                                      25
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
                                      user.status!,
                                      style: TextStyle(
                                          fontSize: Utils.blockWidth * 3.3 > 25
                                              ? 25
                                              : Utils.blockWidth * 3.3 < 18
                                                  ? 18
                                                  : Utils.blockWidth * 3.3),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // ebkj.bdslk,gsdbujsgdbukj
                    Container(
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () => print("something"),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
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
            ],
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
