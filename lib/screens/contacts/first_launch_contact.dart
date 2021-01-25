import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirstLaunchContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _listOfContacts = Provider.of<List<List<Contact>>>(context);

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
            onPressed: () => {print('100')},
            style: ButtonStyle(
              textStyle: MaterialStateProperty.all<TextStyle>(
                TextStyle(fontSize: 18),
              ),
            ),
            child: Center(
              child: Text('Skip'),
            ),
          ),
        ],
      ),
      body: _listOfContacts == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _listOfContacts.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
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
                          _listOfContacts[index] == _listOfContacts.first
                              ? 'Registered'
                              : 'UnRegistered',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      ..._listOfContacts[index].map((e) {
                        return ListTile(
                          title: Text(e?.givenName ?? e?.displayName),
                          subtitle: Text(e.phones.length == 0
                              ? ""
                              : e?.phones?.toList()[0]?.value),
                          trailing: GestureDetector(
                            onTap: () {
                              if (_listOfContacts[index] ==
                                  _listOfContacts.first) {
                                // message contact
                              } else {
                                // invite Contact
                              }
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
                                  _listOfContacts[index] ==
                                          _listOfContacts.first
                                      ? "Message"
                                      : "Invite",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
