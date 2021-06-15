import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:messenger/models/contacts_model.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/screens/group/group_provider.dart';
import 'package:messenger/services/offline/hive.db/models/hive_chat.dart';
import 'package:messenger/utils/constants.dart';
import 'package:provider/provider.dart';

import 'create_group_screen.dart';

class AddParticipantsPage extends StatefulWidget {
  final HiveGroupChat hiveGroupChat;

  const AddParticipantsPage({Key? key, required this.hiveGroupChat})
      : super(key: key);
  @override
  _AddParticipantsPageState createState() => _AddParticipantsPageState();
}

class _AddParticipantsPageState extends State<AddParticipantsPage> {
  late List<User> _participants;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.hiveGroupChat.groupName);
    _participants = widget.hiveGroupChat.participants!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: TextField(
                  style: TextStyle(
                    fontSize: 25,
                  ),
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Enter Group Name ...",
                    border: UnderlineInputBorder(borderSide: BorderSide.none),
                    focusColor: Colors.red,
                    suffixIcon: Icon(Icons.edit, color: Colors.grey),
                  ),
                ),
              ),
              Container(
                // height: 100,
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
              Container(
                child: TextButton(
                  onPressed: () {
                    context.read<GroupProvider>().updateGroupInfo(
                          groupName: _controller.text,
                          oldGroupChat: widget.hiveGroupChat,
                          onCreatedSuccessful: () => Fluttertoast.showToast(
                              msg: "Updated Successfully"),
                          selected: _participants,
                        );
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
