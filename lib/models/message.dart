class Message {
  final String? message;
  final DateTime timeOfMessage;
  final String? senderID;
  final List<String>? receiverIDs;
  final String? chatID;
  final String? messageType;
  final String? messageID;
  final bool? isGroup;

  Message({
    required this.message,
    required this.timeOfMessage,
    required this.senderID,
    required this.chatID,
    this.receiverIDs,
    required this.messageType,
    required this.messageID,
    required this.isGroup,
  });

  Map<String, dynamic> get map {
    return {
      "message": message,
      "timeSent": timeOfMessage.toString(),
      "senderID": senderID,
      "receiverIDs": receiverIDs,
      "chatID": chatID,
      "messagetype": messageType,
      "messageID": messageID,
      "isGroup": isGroup,
    };
  }

  Message copyWith({
    String? message,
    DateTime? timeOfMessage,
    String? senderID,
    List<String>? receiverIDs,
    String? chatID,
    String? messageType,
    String? messageID,
    bool? isGroup,
  }) {
    return Message(
      chatID: chatID ?? this.chatID,
      message: message ?? this.message,
      messageID: messageID ?? this.messageID,
      messageType: messageType ?? this.messageType,
      senderID: senderID ?? this.senderID,
      timeOfMessage: timeOfMessage ?? this.timeOfMessage,
      receiverIDs: receiverIDs ?? this.receiverIDs,
      isGroup: isGroup ?? this.isGroup,
    );
  }

  Message.fromMap(Map<String, dynamic> map)
      : message = map["message"],
        receiverIDs = List<String>.from(map["receiverIDs"]),
        senderID = map["senderID"],
        timeOfMessage = DateTime.parse(map["timeSent"] as String),
        chatID = map["chatID"],
        messageID = map["messageID"],
        messageType = map["messagetype"],
        isGroup = map['isGroup'];

  @override
  String toString() {
    return "message: $message, timeOfMessage: $timeOfMessage, senderID: $senderID, reiceverID: $receiverIDs , messageType: $messageType ";
  }
}
