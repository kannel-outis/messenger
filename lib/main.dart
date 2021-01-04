import 'package:flutter/material.dart';
import 'package:messenger/screens/auth/register.dart';
import 'package:provider/provider.dart';
import 'screens/auth/auth_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        )
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
