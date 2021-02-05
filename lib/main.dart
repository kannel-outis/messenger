import 'package:flutter/material.dart';
import 'package:messenger/screens/contacts/contacts_provider.dart';
import 'package:messenger/services/offline/hive.db/hive_init.dart';
import 'screens/auth/register.dart';
import 'package:provider/provider.dart';
import 'screens/auth/auth_provider.dart';
import 'screens/chats/chats_provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/home/home_provider.dart';
import 'services/offline/shared_prefs/shared_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPrefs.getInstance();
  await HiveInit.hiveInit();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(create: (_) => ContactProvider()),
        FutureProvider(
          create: (_) => ContactProvider().registeredAndUnregisteredContacts(),
          catchError: (context, error) {
            // MessengerError _messengerError = error as MessengerError;
            // return [];
            // ScaffoldMessenger.of(context).showSnackBar(
            //     SnackBar(content: Text('Error fetching Contacts')));
            print(error.toString());
          },
        ),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ChatsProvider()),
      ],
      child: MaterialApp(
        title: 'Messenger',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: RegistrationScreen(),
      ),
    );
  }
}
