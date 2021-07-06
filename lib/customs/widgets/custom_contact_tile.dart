import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:messenger/app/route/route.dart';
import 'package:messenger/models/contacts_model.dart';
import 'package:messenger/screens/contacts/contacts_provider.dart';
import 'package:messenger/screens/home/home.dart';
import 'package:messenger/utils/utils.dart';
import 'package:provider/provider.dart';

class BuildContactTile extends StatelessWidget {
  const BuildContactTile({
    Key? key,
    required this.fromHome,
    required this.element,
    this.isGroup = false,
  }) : super(key: key);

  final bool? fromHome;
  final Object element;
  final bool isGroup;

  bool _isDenseLayout(ListTileTheme? tileTheme) {
    return tileTheme?.dense ?? false;
  }

  TextStyle _titleTextStyle(ThemeData theme, ListTileTheme? tileTheme) {
    final TextStyle style;
    if (tileTheme != null) {
      switch (tileTheme.style) {
        case ListTileStyle.drawer:
          style = theme.textTheme.bodyText1!;
          break;
        case ListTileStyle.list:
          style = theme.textTheme.subtitle1!;
          break;
      }
    } else {
      style = theme.textTheme.subtitle1!;
    }
    final Color? color = _textColor(theme, tileTheme, style.color);
    return _isDenseLayout(tileTheme)
        ? style.copyWith(fontSize: 13.0, color: color)
        : style.copyWith(color: color);
  }

  TextStyle _subtitleTextStyle(ThemeData theme, ListTileTheme? tileTheme) {
    final TextStyle style = theme.textTheme.bodyText2!;
    final Color? color =
        _textColor(theme, tileTheme, theme.textTheme.caption!.color);
    return _isDenseLayout(tileTheme)
        ? style.copyWith(color: color, fontSize: 12.0)
        : style.copyWith(color: color);
  }

  Color? _textColor(
      ThemeData theme, ListTileTheme? tileTheme, Color? defaultColor) {
    if (tileTheme?.selectedColor != null) return tileTheme!.selectedColor;

    if (tileTheme?.textColor != null) return tileTheme!.textColor;

    return defaultColor;
  }

  @override
  Widget build(BuildContext context) {
    final _contactModel = Provider.of<ContactProvider>(context);

    if (element is RegisteredPhoneContacts) {
      var e = element as RegisteredPhoneContacts;
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        height: Utils.blockHeight * 5,
        constraints: BoxConstraints(minHeight: 40, maxHeight: 100),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${e.contact.name ?? e.contact.name2}",
                  style: _titleTextStyle(
                    Theme.of(context),
                    ListTileTheme.of(context),
                  ),
                ),
                Text(
                  e.contact.phones!.length == 0
                      ? ""
                      : "${e.contact.phones?.toList()[0]}",
                  style: _subtitleTextStyle(
                    Theme.of(context),
                    ListTileTheme.of(context),
                  ),
                ),
              ],
            ),
            isGroup == false
                ? InkWell(
                    onTap: () {
                      _contactModel.messageUser(
                        _contactModel.getUserPref(),
                        e.user,
                        navigate: () {
                          fromHome != true
                              ? Navigator.pushNamed(
                                  context, RouteGenerator.homeScreen)
                              : Navigator.pop(context);
                        },
                      );
                      print(e.user.userName);
                      log(e.user.userName!);
                    },
                    child: Container(
                      height: 40,
                      width: Utils.blockWidth * 35,
                      constraints: BoxConstraints(
                        maxHeight: 40,
                        maxWidth: 150,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey,
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
                  )
                : SizedBox(),
          ],
        ),
      );
    } else {
      var e = element as UnRegisteredPhoneContacts;
      if (isGroup) return SizedBox();
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        height: Utils.blockHeight * 5,
        constraints: BoxConstraints(minHeight: 40, maxHeight: 100),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${e.contact!.name ?? e.contact!.name2}",
                  style: _titleTextStyle(
                    Theme.of(context),
                    ListTileTheme.of(context),
                  ),
                ),
                Text(
                  e.contact!.phones!.length == 0
                      ? ""
                      : "${e.contact!.phones?.toList()[0]}",
                  style: _subtitleTextStyle(
                    Theme.of(context),
                    ListTileTheme.of(context),
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {},
              child: Container(
                height: 40,
                width: Utils.blockWidth * 35,
                constraints: BoxConstraints(
                  maxHeight: 40,
                  maxWidth: 150,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey,
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
          ],
        ),
      );
    }
  }
}
