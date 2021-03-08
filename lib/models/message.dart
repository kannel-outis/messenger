class Message {
  final String? message;
  final DateTime timeOfMessage;
  final String? senderID;
  final String? receiverID;
  final String? chatID;
  final String? messageType;
  final String? messageID;

  Message({
    required this.message,
    required this.timeOfMessage,
    required this.senderID,
    required this.chatID,
    this.receiverID,
    required this.messageType,
    required this.messageID,
  });

  Map<String, dynamic> toMap() {
    return {
      "message": message,
      "timeSent": timeOfMessage.toString(),
      "senderID": senderID,
      "receiverID": receiverID,
      "chatID": chatID,
      "messagetype": messageType,
      "messageID": messageID,
    };
  }

  Message.fromMap(Map<String, dynamic> map)
      : message = map["message"],
        receiverID = map["receiverID"],
        senderID = map["senderID"],
        timeOfMessage = DateTime.parse(map["timeSent"] as String),
        chatID = map["chatID"],
        messageID = map["messageID"],
        messageType = map["messagetype"];

  @override
  String toString() {
    return "message: $message, timeOfMessage: $timeOfMessage, senderID: $senderID, reiceverID: $receiverID , messageType: $messageType ";
  }
}
