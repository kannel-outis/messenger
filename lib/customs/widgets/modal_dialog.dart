import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/screens/profile/profile_info_page.dart';
import 'package:messenger/services/offline/hive.db/models/hive_chat.dart';
import 'package:messenger/utils/utils.dart';
import 'custom_alert_dialog.dart' as alert;

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
                      fontSize: Utils.blockWidth * 3 > 25
                          ? 25
                          : Utils.blockWidth * 3 < 19
                              ? 19
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
              isGroup != null && isGroup == true
                  ? null
                  : showGeneralDialog(
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
                          : Utils.blockWidth * 3 < 19
                              ? 19
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
