import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/app/route/route.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/screens/profile/profile_info_page.dart';
import 'package:messenger/services/offline/hive.db/models/hive_chat.dart';
import 'package:messenger/utils/constants.dart';
import 'package:messenger/utils/utils.dart';
import 'package:messenger/utils/_extensions_.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final LocalChat chat;

  final BuildContext context;

  CustomAppBar({
    required this.context,
    required this.chat,
  });

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      return Size(
        double.infinity,
        70 + MediaQuery.of(context).padding.top,
      );
    }
    return Size(
        double.infinity,
        (Utils.blockHeight * 20 > 350
                ? 350
                : Utils.blockHeight * 20 < 200
                    ? 200
                    : Utils.blockHeight * 20) +
            MediaQuery.of(context).padding.top);
  }
}

class _CustomAppBarState extends State<CustomAppBar> {
  late final String? photoUrl;
  late final String? friendContactName;
  late final bool isGroupChat;
  late final List<User>? listOfParticipants;

  @override
  void initState() {
    super.initState();
    photoUrl = widget.chat.photoUrl;
    friendContactName = widget.chat.name;
    isGroupChat = widget.chat is HiveGroupChat;
    listOfParticipants = widget.chat.participants;
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.landscape) {
      return Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey,
          image: DecorationImage(
            image: CachedNetworkImageProvider(photoUrl!),
            fit: BoxFit.cover,
          ),
        ),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.3),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: !isGroupChat
                      ? Row(
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.grey,
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(photoUrl!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Text(
                              "${friendContactName!.capitalize()}",
                              style: TextStyle(
                                // fontSize: Utils.blockWidth * 4.5 > 30
                                //     ? 30
                                //     : Utils.blockWidth * 4.5 < 20
                                //         ? 20
                                //         : Utils.blockWidth * 4.5,
                                fontSize: 23,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.grey,
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            photoUrl!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    "${friendContactName!.capitalize()}",
                                    style: TextStyle(
                                      // fontSize: Utils.blockWidth * 4.5 > 30
                                      //     ? 30
                                      //     : Utils.blockWidth * 4.5 < 20
                                      //         ? 20
                                      //         : Utils.blockWidth * 4.5,
                                      fontSize: 23,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 100,
                              width: 200,
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  Positioned(
                                    left: 40,
                                    child: Container(
                                      height: Utils.blockWidth * 10,
                                      width: Utils.blockWidth * 10,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Colors.white,
                                          image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                  listOfParticipants![0]
                                                          .photoUrl ??
                                                      GeneralConstants
                                                          .DEFAULT_PHOTOURL),
                                              fit: BoxFit.cover)),
                                    ),
                                  ),
                                  Positioned(
                                    left: 60,
                                    child: Container(
                                      height: Utils.blockWidth * 10,
                                      width: Utils.blockWidth * 10,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Colors.white,
                                          image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                  listOfParticipants![1]
                                                          .photoUrl ??
                                                      GeneralConstants
                                                          .DEFAULT_PHOTOURL),
                                              fit: BoxFit.cover)),
                                    ),
                                  ),
                                  Positioned(
                                    left: 80,
                                    child: Container(
                                      height: Utils.blockWidth * 10,
                                      width: Utils.blockWidth * 10,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Colors.white,
                                          image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                  listOfParticipants![2]
                                                          .photoUrl ??
                                                      GeneralConstants
                                                          .DEFAULT_PHOTOURL),
                                              fit: BoxFit.cover)),
                                    ),
                                  ),
                                  Positioned(
                                    left: 100,
                                    child: Container(
                                      height: Utils.blockWidth * 10,
                                      width: Utils.blockWidth * 10,
                                      child: Center(
                                        child: Text(
                                          "+" +
                                              (listOfParticipants!.length - 3)
                                                  .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.white.withOpacity(0.8),
                                      ),
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
          ),
        ),
      );
    }
    return Stack(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        photoUrl ?? GeneralConstants.DEFAULT_PHOTOURL),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          LayoutBuilder(
                              // stream: null,
                              builder: (context, constrainsts) {
                            if (widget.preferredSize.height <= 130) {
                              return Container();
                            }
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 50),
                                Container(
                                  height: Utils.blockWidth * 22,
                                  width: Utils.blockWidth * 22,
                                  child: SizedBox(),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.black,
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          photoUrl ??
                                              GeneralConstants
                                                  .DEFAULT_PHOTOURL),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  friendContactName != null
                                      ? "${friendContactName!.capitalize()}"
                                      : "Null",
                                  style: TextStyle(
                                      // fontSize: Utils.blockWidth * 4 > 25
                                      //     ? 25
                                      //     : Utils.blockWidth * 4,
                                      fontSize: 23,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                                SizedBox(height: isGroupChat ? 7 : 0),
                                isGroupChat && widget.preferredSize.height > 150
                                    ? Container(
                                        width:
                                            (MediaQuery.of(context).size.width /
                                                    2) -
                                                50,
                                        height: Utils.blockWidth * 15,
                                        constraints: BoxConstraints(
                                          maxHeight: 90,
                                          minWidth: 200,
                                          maxWidth: 300,
                                          minHeight: 50,
                                        ),
                                        // color: Colors.red,
                                        child: Stack(
                                          alignment: Alignment.centerLeft,
                                          children: [
                                            Positioned(
                                              left: 40,
                                              child: Container(
                                                height: Utils.blockWidth * 15,
                                                width: Utils.blockWidth * 15,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    color: Colors.white,
                                                    image: DecorationImage(
                                                        image: CachedNetworkImageProvider(
                                                            listOfParticipants![
                                                                        0]
                                                                    .photoUrl ??
                                                                GeneralConstants
                                                                    .DEFAULT_PHOTOURL),
                                                        fit: BoxFit.cover)),
                                              ),
                                            ),
                                            Positioned(
                                              left: 60,
                                              child: Container(
                                                height: Utils.blockWidth * 15,
                                                width: Utils.blockWidth * 15,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    color: Colors.white,
                                                    image: DecorationImage(
                                                        image: CachedNetworkImageProvider(
                                                            listOfParticipants![
                                                                        1]
                                                                    .photoUrl ??
                                                                GeneralConstants
                                                                    .DEFAULT_PHOTOURL),
                                                        fit: BoxFit.cover)),
                                              ),
                                            ),
                                            Positioned(
                                              left: 80,
                                              child: Container(
                                                height: Utils.blockWidth * 15,
                                                width: Utils.blockWidth * 15,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    color: Colors.white,
                                                    image: DecorationImage(
                                                        image: CachedNetworkImageProvider(
                                                            listOfParticipants![
                                                                        2]
                                                                    .photoUrl ??
                                                                GeneralConstants
                                                                    .DEFAULT_PHOTOURL),
                                                        fit: BoxFit.cover)),
                                              ),
                                            ),
                                            Positioned(
                                              left: 100,
                                              child: Container(
                                                height: Utils.blockWidth * 15,
                                                width: Utils.blockWidth * 15,
                                                child: Center(
                                                  child: Text(
                                                    "+" +
                                                        (listOfParticipants!
                                                                    .length -
                                                                3)
                                                            .toString(),
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            );
                          }),
                          widget.preferredSize.height <= 150 && isGroupChat
                              ? Positioned(
                                  right: 20,
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      // color: Colors.white,
                                      image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              listOfParticipants![0].photoUrl ??
                                                  GeneralConstants
                                                      .DEFAULT_PHOTOURL),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.6),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "+${(listOfParticipants!.length - 1).toString()}",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top,
          child: Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: Icon(CupertinoIcons.back),
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.white,
              iconSize: 30,
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top,
          right: 20,
          child: Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: Icon(CupertinoIcons.info_circle_fill),
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  RouteGenerator.profileInfoPage,
                  arguments: ProfileInfoPageArguments(chat: widget.chat),
                );
              },
              color: Colors.white,
              iconSize: 30,
            ),
          ),
        ),
      ],
    );
  }

  // lowest 200
  // highest 350
}

class CustomProfileInfoAppBar extends StatelessWidget {
  final VoidCallback onPressed;
  final String photoUrl;
  final String name;
  final String lastMessage;
  final bool canEdit;
  final bool isGroupChat;
  final Orientation orientation;

  CustomProfileInfoAppBar({
    Key? key,
    required this.onPressed,
    required this.photoUrl,
    required this.name,
    required this.lastMessage,
    required this.canEdit,
    required this.isGroupChat,
    required this.orientation,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: orientation == Orientation.portrait
                ? Utils.blockHeight * 50
                : double.infinity,
            width: orientation == Orientation.portrait
                ? double.infinity
                : Utils.blockHeight * 50,
            decoration: BoxDecoration(
              color: Colors.grey,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(photoUrl),
              ),
            ),
          ),
          Container(
            height: 100,
            width: orientation == Orientation.portrait
                ? double.infinity
                : Utils.blockHeight * 50,
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
                  name,
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
                  lastMessage,
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
          Positioned(
            top: 20 + MediaQuery.of(context).padding.top,
            left: 15,
            child: IconButton(
              icon: Icon(
                CupertinoIcons.back,
                size: 35,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          canEdit && isGroupChat
              ? Positioned(
                  top: 20 + MediaQuery.of(context).padding.top,
                  right: 15,
                  child: IconButton(
                    icon: Icon(
                      Icons.edit,
                      size: 35,
                      color: Colors.white,
                    ),
                    onPressed: onPressed,
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
