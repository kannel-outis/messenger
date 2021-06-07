import "package:flutter/material.dart";

class CustomChatListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final int? messageCount;
  final String? photoUrl;
  const CustomChatListTile(
      {this.messageCount, this.photoUrl, this.subtitle, required this.title});
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
