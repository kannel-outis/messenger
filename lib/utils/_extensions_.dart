import 'dart:convert';

import 'package:messenger/models/user.dart';
import 'package:messenger/services/offline/shared_prefs/shared_prefs.dart';

import 'constants.dart';

extension dateFormat on String {
  String getTime() {
    final String rawDateTimeString = this;
    var dateAndTime = rawDateTimeString.split(" ");
    final String time = dateAndTime.last;
    var splitTime = time.split(":").sublist(0, 2);
    int.parse(splitTime.first) > 12
        ? splitTime.insert(2, "PM")
        : splitTime.insert(2, "AM");
    final String processedTime = splitTime.join(":");
    return processedTime;
  }

  String capitalize() {
    List<String> listOfChar = this.split("");
    listOfChar.replaceRange(0, 1, [listOfChar.first.toUpperCase()]);
    return listOfChar.join("");
  }
}

extension containsID on List<User> {
  bool containsUser([User? user]) {
    final iDs = this.map((e) => e.id!).toList();
    final User prefUser = User.fromMap(
        json.decode(SharedPrefs.instance.getString(OfflineConstants.MY_DATA)!));
    return iDs.contains(user == null ? prefUser.id : user.id);
  }
}
