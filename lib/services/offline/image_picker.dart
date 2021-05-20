import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:messenger/customs/error/error.dart';

class MessengerImagePicker {
  static Future<File?> pickeImage() async {
    File? _imageFile;
    try {
      var pickedFile =
          await ImagePicker().getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    } catch (e) {
      print(e.toString());
      throw MessengerError(e.toString());
    }
    return _imageFile;
  }
}
