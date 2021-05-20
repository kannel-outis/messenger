import 'package:flutter/foundation.dart';
import 'package:messenger/customs/error/error.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  static Future<PermissionStatus> checkContactsPermission(
      {@required Permission? permission}) async {
    var contactsPermissionStatus = await permission!.status;
    PermissionStatus _finalStatus;
    if (!contactsPermissionStatus.isGranted) {
      _finalStatus = await permission.request();
    } else if (contactsPermissionStatus.isDenied ||
        contactsPermissionStatus.isPermanentlyDenied) {
      _finalStatus = PermissionStatus.denied;
      throw MessengerError(
          'Permission is denied. please check app settings to allow permisson');
    } else {
      _finalStatus = PermissionStatus.granted;
    }

    return _finalStatus;
  }
}
