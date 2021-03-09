import 'package:flutter/material.dart';
import 'package:messenger/models/contacts_model.dart';
import 'package:messenger/screens/home/home.dart';
import 'package:provider/provider.dart';

import 'contacts_provider.dart';

class FirstLaunchContactScreen extends StatelessWidget {
  final bool? fromHome;

  const FirstLaunchContactScreen({Key? key, this.fromHome}) : super(key: key);
  Widget _buildContactTile(ContactProvider _contactModel, PhoneContacts element,
      BuildContext context) {
    if (element is RegisteredPhoneContacts) {
      var e = element;

      return ListTile(
        title: Text("${e.contact.givenName ?? e.contact.displayName}"),
        subtitle: Text(e.contact.phones!.length == 0
            ? ""
            : "${e.contact.phones?.toList()[0].value}"),
        trailing: InkWell(
          onTap: () {
            _contactModel.messageUser(
              _contactModel.getUserPref(),
              e.user,
              navigate: () {
                fromHome != true
                    ? Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => HomeScreen(),
                        ),
                      )
                    : Navigator.pop(context);
              },
            );
          },
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width / 5,
            decoration: BoxDecoration(
              color: Colors.pink,
              borderRadius: BorderRadius.all(
                Radius.circular(7),
              ),
            ),
            child: Center(
              child: Text(
                "Message",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      var e = element as UnRegisteredPhoneContacts;

      return ListTile(
        title: Text("${e.contact?.givenName ?? e.contact?.displayName}"),
        subtitle: Text(e.contact!.phones!.length == 0
            ? ""
            : "${e.contact?.phones?.toList()[0].value}"),
        trailing: InkWell(
          onTap: () {},
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width / 5,
            decoration: BoxDecoration(
              color: Colors.pink,
              borderRadius: BorderRadius.all(
                Radius.circular(7),
              ),
            ),
            child: Center(
              child: Text(
                "Invite",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var _listOfContacts = Provider.of<List<List<PhoneContacts>>>(context);
    final _contactModel = Provider.of<ContactProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 100,
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        title: Text('Contacts'),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () => fromHome != true
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
              child: fromHome != true ? Text('Skip') : Text('Go Back'),
            ),
          ),
        ],
      ),
      body: _listOfContacts.length <= 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _listOfContacts.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                bool _isRegistered =
                    _listOfContacts[index] == _listOfContacts.first;
                return Container(
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        width: double.infinity,
                        color: Colors.grey.shade600,
                        child: Text(
                          _isRegistered ? 'Registered' : 'UnRegistered',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      ..._listOfContacts[index].map((e) {
                        return _buildContactTile(_contactModel, e, context);
                      }).toList(),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
