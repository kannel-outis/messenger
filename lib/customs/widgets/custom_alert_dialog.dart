import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:messenger/screens/home/home_provider.dart';
import 'package:messenger/services/offline/hive.db/models/hive_chat.dart';
import 'package:messenger/utils/utils.dart';
import 'package:provider/provider.dart';

class AlertDialog extends StatelessWidget {
  final LocalChat? hiveChat;
  final bool? isGroup;
  final String? title;
  final String? details;
  final Widget? leftButtonChild;
  final Widget? rightButtonChild;
  final VoidCallback? leftButtonAction;
  final VoidCallback? rightButtonAction;
  const AlertDialog({
    this.hiveChat,
    this.isGroup,
    this.title,
    this.details,
    this.leftButtonAction,
    this.leftButtonChild,
    this.rightButtonAction,
    this.rightButtonChild,
  });
  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

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
                title ?? "Delete Conversation",
                style: TextStyle(
                    fontSize: 35,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                details ??
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
                        onPressed:
                            leftButtonAction ?? () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(150, 40),
                          primary: Colors.grey,
                        ),
                        child: Center(
                          child: leftButtonChild ??
                              Row(
                                children: [
                                  Icon(CupertinoIcons.multiply_circle,
                                      size: 20),
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
                        onPressed: rightButtonAction ??
                            () {
                              Navigator.popUntil(
                                  context, (route) => route.isFirst);

                              homeProvider
                                  .deleteChatAndRemovePrintsFromDB(hiveChat!,
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
                          child: rightButtonChild ??
                              Row(
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
                        onPressed:
                            leftButtonAction ?? () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(150, 40),
                          primary: Colors.grey,
                        ),
                        child: Center(
                          child: leftButtonChild ??
                              Row(
                                children: [
                                  Icon(CupertinoIcons.multiply_circle,
                                      size: 20),
                                  SizedBox(width: 10),
                                  Text('Cancel'),
                                ],
                              ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: rightButtonAction ??
                            () {
                              Navigator.popUntil(
                                  context, (route) => route.isFirst);
                              homeProvider
                                  .deleteChatAndRemovePrintsFromDB(hiveChat!,
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
                          child: rightButtonChild ??
                              Row(
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
