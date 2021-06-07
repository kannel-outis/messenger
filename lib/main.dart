import 'package:flutter/material.dart';
import 'package:messenger/customs/error/error.dart';
import 'package:messenger/screens/contacts/contacts_provider.dart';
import 'package:messenger/screens/group/group_provider.dart';
import 'package:messenger/screens/home/home.dart';
import 'package:messenger/services/offline/hive.db/hive_init.dart';
import 'models/contacts_model.dart';
import 'screens/auth/register.dart';
import 'package:provider/provider.dart';
import 'screens/auth/auth_provider.dart';
import 'screens/chats/chats_provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/home/home_provider.dart';
import 'screens/profile/profile_provider.dart';
import 'services/offline/shared_prefs/shared_prefs.dart';
import 'utils/utils.dart';

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
        ChangeNotifierProvider<ContactProvider>(
            create: (_) => ContactProvider()),
        ChangeNotifierProvider<GroupProvider>(create: (_) => GroupProvider()),
        FutureProvider<List<List<PhoneContacts>>>(
          initialData: [],
          create: (_) => ContactProvider().registeredAndUnregisteredContacts(),
          catchError: (context, error) {
            print(error.toString());
            // return ;
            throw MessengerError(error.toString());
          },
        ),
        ChangeNotifierProvider<HomeProvider>(create: (_) => HomeProvider()),
        ChangeNotifierProvider<ChatsProvider>(create: (_) => ChatsProvider()),
        ChangeNotifierProvider<ProfileProvider>(
            create: (_) => ProfileProvider()),
      ],
      child: MaterialApp(
        title: 'Messenger',
        theme: ThemeData(
            // scaffoldBackgroundColor: Colors.black,
            // brightness: Brightness.light,
            ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.red,
          primaryColor: Colors.red,
        ),
        home: SharedPrefs.instance.getUserData().id != null
            ? HomeScreen()
            : RegistrationScreen(),
        builder: (context, child) {
          Utils.getBlockHeightAndWidth(context);
          return child!;
        },
      ),
    );
  }
}
