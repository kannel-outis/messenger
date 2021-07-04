import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:messenger/customs/widgets/custom_contact_tile.dart';
import 'package:messenger/models/contacts_model.dart';
import 'package:messenger/screens/contacts/contacts_provider.dart';
import 'package:messenger/utils/constants.dart';
import 'package:messenger/utils/utils.dart';
import '../../customs/widgets/scaleAndSlide.dart';
import 'package:provider/provider.dart';

import 'group_provider.dart';

enum SelectContactState { active, dormant }

class CreateGroupScreen extends StatefulWidget {
  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen>
    with SingleTickerProviderStateMixin {
  late GlobalKey<AnimatedListState> _animatedListKey;
  late final TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _animatedListKey = GlobalKey<AnimatedListState>();
  }

  ImageProvider<Object> image(provider) {
    if (provider.internalImage == null) {
      return AssetImage('assets/person.png');
    } else {
      return FileImage(provider.internalImage);
    }
  }

  void _onLongPress(RegisteredPhoneContacts contact) {
    _selectContactState = SelectContactState.active;
    setState(() {});
    if (!_selected.contains(contact) && _selected.length < 5) {
      _animatedListKey.currentState!.insertItem(
          _selected.isEmpty ? 0 : _selected.length,
          duration: const Duration(milliseconds: 300));
      _selected.add(contact);
      print(_selected.length);
    }
  }

  void _onTap(RegisteredPhoneContacts contact) {
    if (!_selected.contains(contact) &&
        _selectContactState == SelectContactState.active &&
        _selected.length < 5) {
      _animatedListKey.currentState!.insertItem(_selected.length,
          duration: const Duration(milliseconds: 300));
      _selected.add(contact);
      setState(() {});
      print(_selected.length);
    } else if (_selected.contains(contact) &&
        _selectContactState == SelectContactState.active) {
      _animatedListKey.currentState!.removeItem(
          _selected.indexOf(contact), (context, animation) => Container(),
          duration: const Duration(milliseconds: 300));
      _selected.remove(contact);
      setState(() {});
    }
  }

  final List<RegisteredPhoneContacts> _selected = [];
  SelectContactState _selectContactState = SelectContactState.dormant;

  @override
  Widget build(BuildContext context) {
    var _phoneContacts = Provider.of<ContactProvider>(context).phoneContacts;
    var _groupProvider = Provider.of<GroupProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        if (_selectContactState == SelectContactState.active) {
          _selectContactState = SelectContactState.dormant;
          setState(() {});
          return false;
        }
        Navigator.pop(context, _selected);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text("Create New Group"),
          toolbarHeight:
              kToolbarHeight + MediaQuery.of(context).padding.top / 2,
          elevation: 1.0,
          actions: [
            _selectContactState == SelectContactState.active
                ? TextButton(
                    onPressed: () {
                      _selectContactState = SelectContactState.dormant;
                      setState(() {});
                    },
                    child: Text('Cancel'),
                  )
                : SizedBox(),
            TextButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  _groupProvider.createGroupChat(
                      groupName: _controller.text, selected: _selected);
                } else {
                  Fluttertoast.showToast(msg: "A group name must be given");
                }
              },
              child: Text('Done'),
            ),
          ],
        ),
        body: Column(
          children: [
            Column(
              children: [
                Container(
                  height: 100,
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 15, right: 50),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          _groupProvider.pickeImageAndSaveToCloudStorage();
                        },
                        child: Container(
                          height: Utils.blockHeight * 5,
                          width: Utils.blockHeight * 5,
                          constraints: BoxConstraints(
                            maxHeight: 85,
                            maxWidth: 85,
                            minHeight: 60,
                            minWidth: 60,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              width: 2,
                              style: BorderStyle.solid,
                              color: Colors.red,
                            ),
                            image: DecorationImage(
                              fit: BoxFit.scaleDown,
                              image: image(_groupProvider),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: "Choose a group name ",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _phoneContacts.firstList!.isEmpty
                        ? CircularProgressIndicator.adaptive()
                        : ListView.builder(
                            itemCount: _phoneContacts.firstList!.length,
                            itemBuilder: (context, index) {
                              final contact = _phoneContacts.firstList![index];
                              return InkWell(
                                onLongPress: () {
                                  _onLongPress(contact);
                                },
                                onTap: () {
                                  _onTap(contact);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 20, left: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: Utils.blockHeight * 5,
                                        width: Utils.blockHeight * 5,
                                        constraints: BoxConstraints(
                                          maxHeight: 70,
                                          maxWidth: 70,
                                          minHeight: 50,
                                          minWidth: 50,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                  _phoneContacts
                                                          .firstList![index]
                                                          .user
                                                          .photoUrl ??
                                                      GeneralConstants
                                                          .DEFAULT_PHOTOURL),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      Expanded(
                                        child: BuildContactTile(
                                          fromHome: false,
                                          element: contact,
                                          isGroup: true,
                                        ),
                                      ),
                                      _selectContactState ==
                                              SelectContactState.active
                                          ? Checkbox(
                                              activeColor: Colors.red,
                                              value: _selected.contains(
                                                  _phoneContacts
                                                      .firstList![index]),
                                              onChanged: (e) {
                                                _onTap(contact);
                                              },
                                              tristate: true,
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${_selected.length} participants",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            _selected.isNotEmpty
                                ? TextButton(
                                    onPressed: () {
                                      _selected.clear();
                                      _animatedListKey =
                                          GlobalKey<AnimatedListState>();
                                      setState(() {});
                                    },
                                    child: Text("cancel"),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                      Container(
                        height: _selected.isEmpty ? 1 : 100,
                        width: double.infinity,
                        child: AnimatedList(
                          key: _animatedListKey,
                          initialItemCount: 0,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index, animation) {
                            return ScaleAndSlide(
                              selected: _selected,
                              index: index,
                              animation: animation,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
