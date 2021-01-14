import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger/services/offline/contacts/contacts.dart';
import 'package:messenger/services/online/cloud_firestore/firestore_service.dart';
import 'package:messenger/services/online/online.dart';

class ContactProvider extends ChangeNotifier {
  final Online _fireStoreService = FireStoreService();
  Future<List<List<Contact>>> registeredAndUnregisteredContacts() async {
    var _contacts = Contacts(_fireStoreService);
    return await _contacts.listOfRegisteredAndUnregisteredUsers().then((value) {
      print(value.length);
      return value;
    });
  }
}

// .then((value) {
//       value.forEach((element) {
//         // print(element);
//         for (var e in element) {
//           print({
//             "name": e?.givenName ?? e?.displayName,
//             "phone": e.phones.toList().first?.value
//           });
//         }
//       });
//     });
//   }
