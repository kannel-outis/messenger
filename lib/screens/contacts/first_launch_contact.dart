import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:messenger/screens/contacts/contacts_provider.dart';

class FirstLaunchContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<List<Contact>>>(
        future: ContactProvider().registeredAndUnregisteredContacts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                // snapshot.data.forEach((element) {
                //   // print(element);
                //   for (var e in element) {
                //     print({
                //       "name": e?.givenName ?? e?.displayName,
                //       "phone": e.phones.toList().first?.value
                //     });
                //   }
                // });

                return Column(
                  children: [
                    Container(
                      child: Column(
                        children: snapshot.data[index]
                            .map((e) => ListTile(
                                  title: Text(e.givenName ?? "Nothing here"),
                                  subtitle: Text(e.phones.toList()[0].value ??
                                      "Nothing here"),
                                ))
                            .toList(),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: Center(
                        child: Divider(),
                      ),
                    ),
                    Container(
                      child: Column(
                        children: snapshot.data[index]
                            .map((e) => ListTile(
                                  title: Text(e.givenName ?? "Nothing here"),
                                  subtitle: Text(e.phones.toList()[0].value ??
                                      "Nothing here"),
                                ))
                            .toList(),
                      ),
                    )
                  ],
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Something Went Wrong'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
