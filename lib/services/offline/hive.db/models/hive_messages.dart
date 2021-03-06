import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
part 'hive_messages.g.dart';

@HiveType(typeId: 0)
class HiveMessages extends HiveObject {
  @HiveField(0)
  final String chatID;
  @HiveField(1)
  final String msg;
  @HiveField(2)
  final String messageType;
  @HiveField(3)
  final DateTime dateTime;
  @HiveField(4)
  final String senderID;
  @HiveField(5)
  final String receiverID;
  @HiveField(6)
  final String messageID;

  ///  messsage if is read or not
  @HiveField(7)
  bool isRead;

  HiveMessages({
    this.chatID,
    this.msg,
    this.messageType,
    this.dateTime,
    this.senderID,
    this.receiverID,
    @required this.messageID,
    @required this.isRead,
  });

  @override
  String toString() {
    return '$chatID,  $dateTime, $msg, $senderID, $receiverID, $messageType, $messageID';
  }
}
