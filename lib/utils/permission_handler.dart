import 'package:messenger/customs/error/error.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  static Future<PermissionStatus> checkContactsPermission() async {
    var contactsPermissionStatus = await Permission.contacts.status;
    PermissionStatus _finalStatus;
    if (!contactsPermissionStatus.isGranted) {
      _finalStatus = await Permission.contacts.request();
    } else if (contactsPermissionStatus.isDenied ||
        contactsPermissionStatus.isPermanentlyDenied) {
      _finalStatus = PermissionStatus.denied;
      throw PermissionError(
          'Permission is denied. please check app settings to allow permisson');
    } else {
      _finalStatus = PermissionStatus.granted;
    }

    return _finalStatus;
  }
}
