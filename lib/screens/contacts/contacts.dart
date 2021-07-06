import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:messenger/customs/widgets/custom_contact_tile.dart';
import 'package:messenger/models/contacts_model.dart';
import 'package:messenger/screens/home/home.dart';
import 'package:messenger/services/offline/hive.db/hive_init.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import '../../app/isolate__.dart';

class ContactsScreen extends StatefulWidget {
  final bool? fromHome;

  const ContactsScreen({Key? key, this.fromHome}) : super(key: key);

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen>
    with ContactsIsolate_C {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    disposeIsolate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 100,
        leadingWidth: 150,
        leading: Container(
          child: Center(
            child: Text(
              "Contacts",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 35,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        title: Text(
          refreshing ? 'refreshing...' : '',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () => widget.fromHome != true
                ? Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => HomeScreen(),
                    ),
                  )
                : Navigator.pop(context),
            style: ButtonStyle(
              textStyle: MaterialStateProperty.all<TextStyle>(
                TextStyle(fontSize: 18),
              ),
            ),
            child: Center(
              child: widget.fromHome != true ? Text('Skip') : Text('Go Back'),
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder<Box<HivePhoneContactsList>>(
        // stream: null,
        valueListenable:
            Hive.box<HivePhoneContactsList>(HiveInit.hiveContactsList)
                .listenable(),
        builder: (context, box, child) {
          if (box.values.isEmpty) {
            Provider.of<
                PhoneContacts<RegisteredPhoneContacts,
                    UnRegisteredPhoneContacts?>>(context);
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final phoneContacts = PhoneContacts(
            firstList: box.values.toList().first.registeredContactsToMap,
            lastList: box.values.toList().first.unRegisteredContactsToMap,
          );
          return FutureBuilder<
              PhoneContacts<RegisteredPhoneContacts,
                  UnRegisteredPhoneContacts?>?>(
            future: isolateSpawn(phoneContacts, false),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              final List<dynamic> listOfContacts = []
                ..addAll(snapshot.data!.firstList!)
                ..addAll(snapshot.data!.lastList!);
              return ListView.builder(
                itemCount: listOfContacts.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      if (index == snapshot.data!.firstList!.length)
                        Divider(
                          thickness: 2,
                        ),
                      BuildContactTile(
                        fromHome: widget.fromHome,
                        element: listOfContacts[index],
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
