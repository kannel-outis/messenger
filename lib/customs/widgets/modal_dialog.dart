import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:messenger/screens/home/home_provider.dart';
import 'package:messenger/screens/profile/profile_info_page.dart';
import 'package:messenger/services/offline/hive.db/models/hive_chat.dart';
import 'package:messenger/utils/utils.dart';
import 'package:provider/provider.dart';

import '../custom_route.dart';

class BottomModalSheet extends StatelessWidget {
  final LocalChat? chat;
  final bool? isGroup;
  const BottomModalSheet({
    this.chat,
    this.isGroup,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                CustomNoFadePageRoute(
                  builder: (context) => ProfileInfoPage(chat: chat!),
                ),
              );
            },
            child: Container(
              height: 70,
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "View Profile",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: Utils.blockWidth * 3 > 20
                          ? 25
                          : Utils.blockWidth * 3 < 18
                              ? 18
                              : Utils.blockWidth * 3,
                    ),
                  ),
                  Icon(
                    CupertinoIcons.info_circle_fill,
                    color: Colors.grey,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
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
                  return _AlertDialog(
                    hiveChat: chat!,
                    isGroup: isGroup ?? false,
                  );
                },
              );
            },
            child: Container(
              height: 70,
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Delete Conversation",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: Utils.blockWidth * 3 > 25
                          ? 25
                          : Utils.blockWidth * 3 < 25
                              ? 25
                              : Utils.blockWidth * 3,
                    ),
                  ),
                  Icon(
                    CupertinoIcons.delete_simple,
                    color: Colors.red,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertDialog extends StatelessWidget {
  final LocalChat hiveChat;
  final bool isGroup;
  const _AlertDialog({
    required this.hiveChat,
    required this.isGroup,
  });
  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    print((Utils.blockWidth * 85 > 368.0));
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        height: 300,
        width: Utils.blockWidth * 85,
        constraints: BoxConstraints(
          maxWidth: 500,
          maxHeight: 300,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 30,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Text(
                "Delete Conversation",
                style: TextStyle(
                    fontSize: 35,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                "This will permanently remove this conversation. This process cannot be undone.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            ),
            (Utils.blockWidth * 85) > 368.0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(150, 40),
                          primary: Colors.grey,
                        ),
                        child: Center(
                          child: Row(
                            children: [
                              Icon(CupertinoIcons.multiply_circle, size: 20),
                              SizedBox(width: 10),
                              Text(
                                'Cancel',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                          homeProvider
                              .deleteChatAndRemovePrintsFromDB(hiveChat,
                                  isGroup: isGroup)
                              .then(
                                (value) => Fluttertoast.showToast(
                                    msg: "Conversation Deleted"),
                              );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(150, 40),
                        ),
                        child: Center(
                          child: Row(
                            children: [
                              Icon(CupertinoIcons.delete, size: 20),
                              SizedBox(width: 10),
                              Text(
                                'Delete',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(150, 40),
                          primary: Colors.grey,
                        ),
                        child: Center(
                          child: Row(
                            children: [
                              Icon(CupertinoIcons.multiply_circle, size: 20),
                              SizedBox(width: 10),
                              Text('Cancel'),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                          homeProvider
                              .deleteChatAndRemovePrintsFromDB(hiveChat,
                                  isGroup: isGroup)
                              .then(
                                (value) => Fluttertoast.showToast(
                                    msg: "Conversation Deleted"),
                              );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(150, 40),
                        ),
                        child: Center(
                          child: Row(
                            children: [
                              Icon(CupertinoIcons.delete, size: 20),
                              SizedBox(width: 10),
                              Text('Delete'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
