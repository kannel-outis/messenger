import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:messenger/customs/error/error.dart';
import 'package:messenger/services/online/online.dart';

class MessengerFirebaseStorage extends Online {
  final FirebaseStorage? storage;
  MessengerFirebaseStorage({this.storage})
      : _storage = storage ?? FirebaseStorage.instance;
  FirebaseStorage? _storage;
  @override
  Future<String> saveImageToFireStore(String? uid, File? file) async {
    try {
      return await _storage!
          .ref(uid!)
          .child(file!.path.split('/').last)
          .putFile(file)
          .then(
        (taskSnap) {
          return taskSnap.ref.getDownloadURL();
        },
      );
    } catch (e) {
      if (e is FirebaseException)
        throw MessengerError(e.code.split('-').join(''));
      throw MessengerError("An unknown error has occurred");
    }
  }
}
