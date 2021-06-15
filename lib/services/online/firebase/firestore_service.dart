import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:messenger/models/user.dart';
import 'package:messenger/models/chat.dart';
import 'package:messenger/services/online/online.dart';
import 'package:messenger/utils/constants.dart';

class FireStoreService extends Online {
  final FirebaseFirestore? firebaseFirestore;
  FireStoreService({this.firebaseFirestore})
      : _cloud = firebaseFirestore ?? FirebaseFirestore.instance;
  late final FirebaseFirestore _cloud;
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
          arrayContains: query,
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

  @override
  Future<void> deleteChat({required String id, bool isGroup = false}) async {
    if (isGroup) {
      return _cloud
          .collection(OnlineConstants.FIRESTORE_ONGOING_GROUP_CHATS)
          .doc(id)
          .delete();
    }
    return _cloud
        .collection(OnlineConstants.FIRESTORE_ONGOING_CHATS)
        .doc(id)
        .delete();
  }

  @override
  Future<void> createNewGroupChat(GroupChat newGroupChat) {
    print("Creating...");
    return _cloud
        .collection(OnlineConstants.FIRESTORE_ONGOING_GROUP_CHATS)
        .doc(newGroupChat.groupID)
        .set(newGroupChat.toMap());
  }

  @override
  Stream<QuerySnapshot> listenWhenAUserInitializesAChat(User user,
      {bool isGroup = false}) {
    // super.listenWhenAUserInitializesAChat(user, isGroup: isGroup);
    return _cloud
        .collection(isGroup
            ? OnlineConstants.FIRESTORE_ONGOING_GROUP_CHATS
            : OnlineConstants.FIRESTORE_ONGOING_CHATS)
        .where('participantsIDs', arrayContains: user.id)
        .snapshots();
  }

  @override
  Future<bool> updateUserInCloud({User? user}) async {
    bool success = false;
    super.updateUserInCloud(user: user);
    await _cloud
        .collection(OnlineConstants.FIRESTORE_USER_REF)
        .doc(user!.id!)
        .update(user.toMap())
        .then(
      (value) {
        _updateOnGoingChats(user).then((value) => success = true);
        _updateOnGoingGroupChats(user).then((value) => success = true);
      },
    );
    return success;
  }

  Future<void> _updateOnGoingChats(User user) async {
    await _cloud
        .collection(OnlineConstants.FIRESTORE_ONGOING_CHATS)
        .where('participantsIDs', arrayContains: user.id)
        .get()
        .then(
      (value) async {
        for (var element in value.docs) {
          final Chat chat = Chat.froMap(element.data()!);
          late Chat newChat;

          final Map<String, dynamic>? secondUserMap = chat.participants.last!;

          if (chat.participants[1]!['id'] == user.id) {
            newChat = Chat(
                chatID: chat.chatID,
                participantsIDs: chat.participantsIDs,
                participants: [chat.participants.first!, user.toMap()]);
          } else if (chat.participants[1]!['id'] == user.id &&
              chat.participants[0]!['id'] == user.id) {
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

          await element.reference.update(newChat.toMap());
        }
      },
    );
  }

  Future<void> _updateOnGoingGroupChats(User user) async {
    await _cloud
        .collection(OnlineConstants.FIRESTORE_ONGOING_GROUP_CHATS)
        .where('participantsIDs', arrayContains: user.id)
        .get()
        .then((value) async {
      for (var element in value.docs) {
        final GroupChat groupChat = GroupChat.froMap(element.data()!);
        late GroupChat newGroupChat;
        int index = groupChat.participants
            .indexWhere((element) => element!.containsValue(user.id));
        int adminIndex = groupChat.groupAdmins!
            .indexWhere((element) => element.containsValue(user.id));
        late final User _user;
        if (user.id == groupChat.groupCreator['id']) _user = user;

        if (adminIndex != -1) {
          groupChat.groupAdmins![adminIndex] = user.toMap();
        }

        groupChat.participants[index] = user.toMap();
        newGroupChat = groupChat.copyWith(
          groupCreator: _user.toMap(),
          participants: groupChat.participants,
          groupAdmins: groupChat.groupAdmins,
        );
        await element.reference.update(newGroupChat.toMap());
      }
    });
  }
}
