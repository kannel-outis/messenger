import 'dart:io';

import 'package:image_picker/image_picker.dart';

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
    }
    return _imageFile;
  }
}
