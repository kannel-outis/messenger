import 'package:flutter/cupertino.dart';

class Utils {
  static late double blockHeight;
  static late double blockWidth;

  static getBlockHeightAndWidth(BuildContext context) {
    final query = MediaQuery.of(context);
    if (query.orientation == Orientation.landscape) {
      blockHeight = query.size.width / 100;
      blockWidth = query.size.height / 100;
    } else {
      blockHeight = query.size.height / 100;
      blockWidth = query.size.width / 100;
    }
  }
}
