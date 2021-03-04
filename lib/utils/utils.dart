import 'package:flutter/cupertino.dart';

class Utils {
  static double blockHeight;
  static double blockWidth;

  static getBlockHeightAndWidth(BuildContext context) {
    blockHeight = MediaQuery.of(context).size.height / 100;
    blockWidth = MediaQuery.of(context).size.width / 100;
  }
}
