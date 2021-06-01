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
                    child: Column(
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
                              image: CachedNetworkImageProvider(photoUrl ??
                                  GeneralConstants.DEFAULT_PHOTOURL),
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
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                        SizedBox(height: isGroupChat ? 10 : 0),
                        isGroupChat
                            ? Container(
                                width: (MediaQuery.of(context).size.width / 2) -
                                    50,
                                height: 90,
                                constraints: BoxConstraints(
                                    maxHeight: 90,
                                    minWidth: 200,
                                    maxWidth: 300,
                                    minHeight: 90),
                                // color: Colors.red,
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    Positioned(
                                      left: 30,
                                      child: Container(
                                        height: 70,
                                        width: 70,
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
                                      left: 70,
                                      child: Container(
                                        height: 70,
                                        width: 70,
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
                                      left: 110,
                                      child: Container(
                                        height: 70,
                                        width: 70,
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
                                      left: 140,
                                      child: Container(
                                        height: 70,
                                        width: 70,
                                        child: Center(
                                            child: Text("+" +
                                                (listOfParticipants!.length - 3)
                                                    .toString())),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : SizedBox(),
                      ],
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
  Size get preferredSize => Size(
      double.infinity,
      (MediaQuery.of(context).size.height / 5.5) +
          MediaQuery.of(context).padding.top);
}
