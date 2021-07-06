import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/customs/custom_route.dart';
import 'package:messenger/models/contacts_model.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/screens/auth/register.dart';
import 'package:messenger/screens/auth/set_name_screen.dart';
import 'package:messenger/screens/auth/verify_otp.dart';
import 'package:messenger/screens/chats/chats.dart';
import 'package:messenger/screens/contacts/contacts.dart';
import 'package:messenger/screens/group/create_group_screen.dart';
import 'package:messenger/screens/group/update_group_info_page.dart';
import 'package:messenger/screens/home/home.dart';
import 'package:messenger/screens/profile/profile_info_page.dart';
import 'package:messenger/screens/profile/profile_page.dart';
import 'package:messenger/services/offline/hive.db/models/hive_chat.dart';

class RouteGenerator {
  static const String homeScreen = "/home_screen";
  static const String contactsScreen = "/contacts_screen";
  static const String registerScreen = "/register_screen";
  static const String verifyOtp = "/verify_otp_screen";
  static const String setName = "/set_name_screen";
  static const String createGroupScreen = "/create_contacts_screen";
  static const String chatScreen = "/chat_screen";
  static const String updateGroupInfo = "/update_group_info";
  static const String profileScreen = "/profile_screen";
  static const String profileInfoPage = "/profile_info_page";

  static Route generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case registerScreen:
        return MaterialPageRoute(
          builder: (context) => RegistrationScreen(),
        );
      case verifyOtp:
        return MaterialPageRoute(
          builder: (context) => VerifyOTPScreen(),
        );
      case setName:
        return MaterialPageRoute(
          builder: (context) => SetNameScreen(),
        );
      case homeScreen:
        return MaterialPageRoute(
          builder: (context) => HomeScreen(),
        );
      case contactsScreen:
        return MaterialPageRoute(
          builder: (context) => ContactsScreen(
            fromHome: args as bool,
          ),
        );
      case createGroupScreen:
        return MaterialPageRoute<List<RegisteredPhoneContacts>>(
          builder: (context) => CreateGroupScreen(),
        );
      case chatScreen:
        args as ChatsScreenArgument;
        return MaterialPageRoute(
          builder: (context) => ChatsScreen(args.localChat),
        );
      case updateGroupInfo:
        args as UpdateGroupInfoArgument;
        return CupertinoPageRoute<HiveGroupChat?>(
          maintainState: true,
          builder: (context) => UpdateGroupInfo(
            hiveGroupChat: args.hiveGroupChat,
          ),
        );
      case profileScreen:
        args as ProfileScreenArguments;
        return CustomRoute<User>(
          builder: (_) => ProfileScreen(user: args.user),
        );
      case profileInfoPage:
        args as ProfileInfoPageArguments;
        return MaterialPageRoute(
          builder: (_) => ProfileInfoPage(chat: args.chat),
        );

      default:
        return _errorRoute();
    }
  }

  // Widget builder<T extends Widget>(BuildContext context){
  //   return T;
  // }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}

class ChatsScreenArgument {
  final LocalChat localChat;

  const ChatsScreenArgument(this.localChat);
}

class UpdateGroupInfoArgument {
  final HiveGroupChat hiveGroupChat;

  const UpdateGroupInfoArgument({required this.hiveGroupChat});
}

class ProfileScreenArguments {
  final User? user;

  ProfileScreenArguments({this.user});
}

class ProfileInfoPageArguments {
  final LocalChat chat;
  const ProfileInfoPageArguments({required this.chat});
}
