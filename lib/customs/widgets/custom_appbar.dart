import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/utils/constants.dart';
import 'package:messenger/utils/utils.dart';
import 'package:messenger/utils/_extensions_.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;
  final String? photoUrl;
  final String? friendContactName;
  const CustomAppBar(
      {required this.context, this.friendContactName, this.photoUrl});

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
                        Container(
                          height: Utils.blockWidth * 22,
                          width: Utils.blockWidth * 22,
                          child: SizedBox(),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
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
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Align(
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
      ],
    );
  }

  @override
  Size get preferredSize =>
      Size(double.infinity, MediaQuery.of(context).size.height / 5.5);
}
