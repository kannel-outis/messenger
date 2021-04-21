import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:messenger/models/user.dart';
import 'package:messenger/models/chat.dart';
import 'package:messenger/services/online/online.dart';
import 'package:messenger/utils/constants.dart';

class FireStoreService extends Online {
  final _cloud = FirebaseFirestore.instance;
  @override
  Future<User> saveNewUserToCloud(
      {String? userName,
      required String? phoneNumberWithoutCC,
      firebaseAuth.User? user,
      required User userDataPref,
      required String? publicKey,
      required String? newPhotoUrlString}) async {
    User _newUser = User(
      id: user?.uid,
      phoneNumbers: [user?.phoneNumber, phoneNumberWithoutCC],
      photoUrl: user?.uid == userDataPref.id && newPhotoUrlString == null
          ? userDataPref.photoUrl
          : user?.photoURL ??
              newPhotoUrlString ??
              GeneralConstants.DEFAULT_PHOTOURL,
      userName: userName,
      status: GeneralConstants.DEFAULT_STATUS,
      publicKey: publicKey,
    );
    print(_newUser.photoUrl);

    await _cloud
        .collection(OnlineConstants.FIRESTORE_USER_REF)
        .doc(_newUser.id!)
        .set(_newUser.toMap());
    return _newUser;
  }

  @override
  Future<User> getUserFromCloud(firebaseAuth.User user) async {
    DocumentSnapshot _docSnapshot = await _cloud
        .collection(OnlineConstants.FIRESTORE_USER_REF)
        .doc(user.uid)
        .get();
    return User.fromMap(_docSnapshot.data()!);
  }

  @override
  Future<QuerySnapshot> queryMobileNumberORUsername(
    String query,
    String field,
  ) async {
    return await _cloud
        .collection(OnlineConstants.FIRESTORE_USER_REF)
        .where(
          field,
          arrayContains: query,
        )
        .get();
  }

  @override
  Future<QuerySnapshot> queryInfo(
    dynamic query,
  ) async {
    return await _cloud
        .collection(OnlineConstants.FIRESTORE_ONGOING_CHATS)
        .where(
          'participantsIDs',
          isEqualTo: query,
        )
        .get();
  }

  @override
  Future<void> createNewChat(Chat newChat) async {
    return _cloud
        .collection(OnlineConstants.FIRESTORE_ONGOING_CHATS)
        .doc(newChat.chatID!)
        .set(newChat.toMap());
  }

  // @override
  // Stream<QuerySnapshot> getAllOnGoingchats() {
  //   return _cloud
  //       .collection(OnlineConstants.FIRESTORE_ONGOING_CHATS)
  //       .snapshots();
  // }

  @override
  Stream<QuerySnapshot> listenWhenAUserInitializesAChat(User user) {
    return _cloud
        .collection(OnlineConstants.FIRESTORE_ONGOING_CHATS)
        .where('participantsIDs', arrayContains: user.id)
        .snapshots();
  }

  // @override
  // Stream<DocumentSnapshot> listenToUserConnectionUpdate(String userId) {
  //   // return super.listenToUserConnectionUpdate(user);
  //   return _cloud
  //       .collection(OnlineConstants.FIRESTORE_USER_REF)
  //       .doc(userId)
  //       .snapshots();
  // }

  @override
  Future<bool> updateUserInCloud({User? user}) async {
    bool success = false;
    super.updateUserInCloud(user: user);
    await _cloud
        .collection(OnlineConstants.FIRESTORE_USER_REF)
        .doc(user!.id!)
        .update(user.toMap())
        .then(
      (value) async {
        await _cloud
            .collection(OnlineConstants.FIRESTORE_ONGOING_CHATS)
            .where('participantsIDs', arrayContains: user.id)
            .get()
            .then(
          (value) async {
            value.docs.forEach(
              (element) async {
                final Chat chat = Chat.froMap(element.data()!);
                late Chat newChat;

                final Map<String, dynamic>? secondUserMap =
                    chat.participants?.last!;

                if (chat.participants![1]!['id'] == user.id) {
                  newChat = Chat(
                      chatID: chat.chatID,
                      participantsIDs: chat.participantsIDs,
                      participants: [chat.participants?.first!, user.toMap()]);
                } else if (chat.participants![1]!['id'] == user.id &&
                    chat.participants![0]!['id'] == user.id) {
                  newChat = Chat(
                      chatID: chat.chatID,
                      participantsIDs: chat.participantsIDs,
                      participants: [user.toMap(), user.toMap()]);
                } else {
                  newChat = Chat(
                      chatID: chat.chatID,
                      participantsIDs: chat.participantsIDs,
                      participants: [user.toMap(), secondUserMap]);
                }

                await element.reference.update(newChat.toMap()).then((value) {
                  return success = true;
                });
              },
            );
          },
        );
      },
    );
    return success;
  }
}
// TODO: implement user online and offline status ...create a stream to user listen to changes from firestore
