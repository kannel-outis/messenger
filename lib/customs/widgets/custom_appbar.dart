import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String photoUrl;
  final String friendContactName;
  const CustomAppBar({this.height, this.friendContactName, this.photoUrl})
      : assert(height > 50);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: Colors.blueAccent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 70,
                  width: 70,
                  child: SizedBox(),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.blue),
                ),
                SizedBox(height: 10),
                Text(
                  '$friendContactName',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, height ?? 50);
}
