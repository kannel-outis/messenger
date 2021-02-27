import 'package:hive/hive.dart';
part 'hive_messages.g.dart';

@HiveType(typeId: 0)
class HiveMessages {
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

  HiveMessages({
    this.chatID,
    this.msg,
    this.messageType,
    this.dateTime,
    this.senderID,
    this.receiverID,
  });
}
