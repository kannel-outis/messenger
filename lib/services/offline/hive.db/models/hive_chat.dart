import 'dart:ui';

import 'package:hive/hive.dart';
import 'package:messenger/models/user.dart' as u;
import 'package:messenger/models/user.dart';
part 'hive_chat.g.dart';

@HiveType(typeId: 1)
class HiveChat extends HiveObject {
  @HiveField(0)
  final String? chatId;
  @HiveField(1)
  final List<u.User>? participants;

  HiveChat({
    this.chatId,
    this.participants,
  });

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final HiveChat typedOther = other;
    return typedOther.chatId == chatId &&
        typedOther.participants == participants;
  }

  @override
  int get hashCode => hashValues(chatId, hashList(participants));
}
