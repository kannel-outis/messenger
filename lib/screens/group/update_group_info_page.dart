import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:messenger/models/contacts_model.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/screens/group/group_provider.dart';
import 'package:messenger/services/offline/hive.db/models/hive_chat.dart';
import 'package:messenger/utils/constants.dart';
import 'package:messenger/utils/utils.dart';
import 'package:provider/provider.dart';

import 'create_group_screen.dart';

class UpdateGroupInfo extends StatefulWidget {
  final HiveGroupChat hiveGroupChat;

  const UpdateGroupInfo({Key? key, required this.hiveGroupChat})
      : super(key: key);
  @override
  _UpdateGroupInfoState createState() => _UpdateGroupInfoState();
}

class _UpdateGroupInfoState extends State<UpdateGroupInfo> {
  late List<User> _participants;
  late TextEditingController _controller;
  HiveGroupChat? _returnHiveGroupChat;

  ImageProvider<Object> image(File? internalImage) {
    // if(widget.hiveGroupChat.groupPhotoUrl)
    if (internalImage == null) {
      return CachedNetworkImageProvider(widget.hiveGroupChat.groupPhotoUrl!);
    } else {
      return FileImage(internalImage);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.hiveGroupChat.groupName);
    _participants = widget.hiveGroupChat.participants!;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _returnHiveGroupChat ?? widget.hiveGroupChat);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.0,
          actions: [
            TextButton(
              onPressed: () async {
                final _selectedList = await Navigator.of(context)
                    .push<List<RegisteredPhoneContacts>>(
                  MaterialPageRoute(
                    builder: (context) => CreateGroupScreen(),
                  ),
                );
                if (_selectedList != null) {
                  _participants.addAll(_selectedList.map((e) => e.user));
                  setState(() => null);

                  print("${_participants.length}from Console");
                }
              },
              child: Center(
                child: Text(
                  'Add participant',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            SizedBox(width: 20),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            // margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          context
                              .read<GroupProvider>()
                              .pickeImageAndSaveToCloudStorage(
                                  widget.hiveGroupChat.groupID);
                        },
                        child:
                            Consumer<GroupProvider>(builder: (context, p, _) {
                          return Container(
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
                                image: image(p.internalImage),
                              ),
                            ),
                          );
                        }),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                            fontSize: 22,
                          ),
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: "Enter Group Name ...",
                            border: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            focusColor: Colors.red,
                            suffixIcon: Icon(Icons.edit, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${_participants.length} participants",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                          height: _participants.isEmpty ? 1 : 100,
                          width: double.infinity,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              ..._participants.map(
                                (e) => _ListElement(
                                  selected: e,
                                  delete: () {
                                    _participants.remove(e);
                                    setState(() => null);
                                  },
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Consumer<GroupProvider>(
                  builder: (context, p, child) {
                    return p.uploadingImageToStorage
                        ? Text("Please Wait.....")
                        : SizedBox();
                  },
                ),
                Container(
                  child: TextButton(
                    onPressed: () async {
                      if (_participants.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Participants cannot be empty");
                        return;
                      }
                      _returnHiveGroupChat =
                          await context.read<GroupProvider>().updateGroupInfo(
                                groupName: _controller.text,
                                oldGroupChat: widget.hiveGroupChat,
                                onCreatedSuccessful: () =>
                                    Fluttertoast.showToast(
                                        msg: "Updated Successfully"),
                                selected: _participants,
                              );
                      setState(() => null);
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size(50, 50),
                    ),
                    child: Center(
                      child: Text(
                        'Update',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ListElement extends StatelessWidget {
  const _ListElement({
    Key? key,
    required User selected,
    required VoidCallback delete,
  })   : _selected = selected,
        _delete = delete,
        super(key: key);
  final User _selected;
  final VoidCallback _delete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 70,
              width: 70,
              margin: EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                image: DecorationImage(
                    image: CachedNetworkImageProvider(_selected.photoUrl ??
                        GeneralConstants.DEFAULT_PHOTOURL),
                    fit: BoxFit.cover),
              ),
            ),
            Positioned(
              right: 10,
              child: GestureDetector(
                onTap: _delete,
                child: Container(
                  child: Icon(Icons.cancel, color: Colors.grey, size: 20),
                ),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(right: 15),
          child: Text(_selected.userName!),
        ),
      ],
    );
  }
}
