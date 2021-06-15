import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/screens/chats/chats.dart';
import 'package:messenger/screens/home/home_provider.dart';
import 'package:messenger/screens/profile/profile_provider.dart';
import 'package:messenger/services/offline/hive.db/models/hive_chat.dart';
import 'package:messenger/utils/utils.dart';
import 'package:provider/provider.dart';
import '../../utils/_extensions_.dart';
part 'build_contact.dart';
part 'profile_info_user.dart';
part 'profile_info_group.dart';

class ProfileInfoPage extends HookWidget {
  final LocalChat chat;
  ProfileInfoPage({required this.chat});
  @override
  Widget build(BuildContext context) {
    print(chat.id);
    if (chat is HiveGroupChat) {
      return _GroupProfileInfoPage(chat as HiveGroupChat);
    } else {
      return _UserProfileInfoPage(chat as HiveChat);
    }
  }
}