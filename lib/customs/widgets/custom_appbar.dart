import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/utils/constants.dart';
import 'package:messenger/utils/utils.dart';
import 'package:messenger/utils/_extensions_.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;
  final String? photoUrl;
  final String? friendContactName;
  final bool isGroupChat;
  final List<User>? listOfParticipants;
  const CustomAppBar(
      {required this.context,
      this.friendContactName,
      this.photoUrl,
      this.listOfParticipants,
      required this.isGroupChat});
  // : assert(isGroupChat == true &&
  //       listOfParticipants != null &&
  //       listOfParticipants.length < 2);

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
                                          child: Text("+" +
                                              (listOfParticipants!.length - 3)
                                                  .toString())),
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
                            if (preferredSize.height <= 130) {
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
                                isGroupChat && preferredSize.height > 150
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
                                                    child: Text("+" +
                                                        (listOfParticipants!
                                                                    .length -
                                                                3)
                                                            .toString())),
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
                          preferredSize.height <= 150 && isGroupChat
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
      ],
    );
  }

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

  // lowest 200
  // highest 350
}
