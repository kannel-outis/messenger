import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:messenger/utils/utils.dart';
import 'package:timeago_flutter/timeago_flutter.dart';
// import 'package:timeago_flutter/timeago_flutter.dart';

class CustomChatListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final int? messageCount;
  final String? photoUrl;
  final DateTime? dateTime;
  final bool? isRead;
  final bool? isGroup;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  const CustomChatListTile({
    this.messageCount,
    this.photoUrl,
    this.subtitle,
    required this.title,
    this.dateTime,
    this.isRead,
    required this.onLongPress,
    required this.onTap,
    this.isGroup = false,
  });

  @override
  Widget build(BuildContext context) {
    print(title);
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onTap,
          onLongPress: onLongPress,
          child: Container(
            height: Utils.blockHeight * 7,
            constraints: BoxConstraints(
              minHeight: 70,
              maxHeight: 90,
            ),
            width: double.infinity,
            child: Row(
              children: [
                Container(
                  height: Utils.blockHeight * 7,
                  width: Utils.blockHeight * 7,
                  constraints: BoxConstraints(
                    maxHeight: 85,
                    maxWidth: 85,
                    minHeight: 60,
                    minWidth: 60,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.grey,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(photoUrl!),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    // color: Colors.pink,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            title,
                            textScaleFactor: .6,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 23),
                          ),
                        ),
                        // subtitle != null
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            subtitle ?? "",
                            textScaleFactor: .6,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: isRead == false
                                  ? FontWeight.w900
                                  : FontWeight.normal,
                              fontSize: 20,
                              // color: Theme.of(context).textTheme.caption!.color,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        // : SizedBox(),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      dateTime != null
                          ? Timeago(
                              date: dateTime!,
                              allowFromNow: true,
                              builder: (context, value) => Text(
                                value.contains("about")
                                    ? value.substring(6, value.length)
                                    : value,
                                textScaleFactor: .6,
                                style:
                                    TextStyle(fontSize: 20, color: Colors.grey),
                              ),
                            )
                          // Text(
                          //     timeago.format(
                          //       DateTime.now().subtract(
                          //         dateTime!.difference(DateTime.now()),
                          //       ),
                          //       allowFromNow: true,
                          //     ),
                          //     textScaleFactor: .6,
                          //     style:
                          //         TextStyle(color: Colors.grey, fontSize: 20),
                          //   )
                          : SizedBox(),
                      SizedBox(height: 10),
                      isRead == false
                          ? Container(
                              height: Utils.blockWidth * 7.5,
                              width: Utils.blockWidth * 7.5,
                              constraints: BoxConstraints(
                                maxHeight: 30,
                                maxWidth: 30,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: Text("$messageCount"),
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          indent: Utils.blockHeight * 7 > 85 ? 85 : Utils.blockHeight * 7 + 10,
          color: Colors.grey,
          thickness: .5,
        )
      ],
    );
  }
}
