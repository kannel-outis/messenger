import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:messenger/services/online/online.dart';

class MessengerFirebaseStorage extends Online {
  @override
  Future<String> saveImageToFireStore(String uid, File file) async {
    return await FirebaseStorage.instance
        .ref(uid)
        .child(file.path.split('/').last)
        .putFile(file)
        .then(
      (taskSnap) {
        return taskSnap.ref.getDownloadURL();
      },
    );
  }
}
