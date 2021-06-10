import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:messenger/customs/widgets/custom_contact_tile.dart';
import 'package:messenger/models/contacts_model.dart';
import 'package:messenger/utils/constants.dart';
import 'package:messenger/utils/utils.dart';
import 'package:provider/provider.dart';

import 'group_provider.dart';

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

  final List<RegisteredPhoneContacts> _selected = [];
  bool _selectingMode = false;
  @override
  Widget build(BuildContext context) {
    var _listOfContacts = Provider.of<List<List<PhoneContacts>>>(context);
    var _groupProvider = Provider.of<GroupProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        if (_selectingMode) {
          _selectingMode = false;
          setState(() {});
          return false;
        }
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
            _selectingMode
                ? TextButton(
                    onPressed: () {
                      _selectingMode = false;
                      setState(() {});
                    },
                    child: Text('Cancel'),
                  )
                : SizedBox(),
            TextButton(
              onPressed: () {},
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
                          // print("camera something");
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
                    child: _listOfContacts.isEmpty
                        ? CircularProgressIndicator.adaptive()
                        : ListView.builder(
                            itemCount: _listOfContacts[0].length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onLongPress: () {
                                  _selectingMode = true;
                                  setState(() {});
                                  if (!_selected.contains(
                                          _listOfContacts[0][index]) &&
                                      _selected.length < 2) {
                                    _animatedListKey.currentState!.insertItem(
                                        _selected.isEmpty
                                            ? 0
                                            : _selected.length,
                                        duration:
                                            const Duration(milliseconds: 300));
                                    _selected.add(_listOfContacts[0][index]
                                        as RegisteredPhoneContacts);
                                    print(_selected.length);
                                  }
                                },
                                onTap: () {
                                  if (!_selected.contains(
                                          _listOfContacts[0][index]) &&
                                      _selectingMode &&
                                      _selected.length < 2) {
                                    _animatedListKey.currentState!.insertItem(
                                        _selected.length,
                                        duration:
                                            const Duration(milliseconds: 300));
                                    _selected.add(_listOfContacts[0][index]
                                        as RegisteredPhoneContacts);
                                    setState(() {});
                                    print(_selected.length);
                                  } else if (_selected.contains(
                                          _listOfContacts[0][index]) &&
                                      _selectingMode) {
                                    var r = _listOfContacts[0][index]
                                        as RegisteredPhoneContacts;
                                    _animatedListKey.currentState!.removeItem(
                                        _selected.indexOf(r),
                                        (context, animation) => Container(),
                                        duration:
                                            const Duration(milliseconds: 300));
                                    _selected.remove(r);
                                    setState(() {});
                                  }
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
                                                  (_listOfContacts[0][index]
                                                              as RegisteredPhoneContacts)
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
                                          element: _listOfContacts[0][index],
                                          isGroup: true,
                                        ),
                                      ),
                                      _selectingMode == true
                                          ? Checkbox(
                                              activeColor: Colors.red,
                                              value: _selected.contains(
                                                  _listOfContacts[0][index]),
                                              onChanged: (e) {
                                                if (!_selected.contains(
                                                        _listOfContacts[0]
                                                            [index]) &&
                                                    _selectingMode &&
                                                    _selected.length < 2) {
                                                  _animatedListKey.currentState!
                                                      .insertItem(
                                                          _selected.length,
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      300));
                                                  _selected.add(_listOfContacts[
                                                          0][index]
                                                      as RegisteredPhoneContacts);
                                                  setState(() {});
                                                  print(_selected.length);
                                                } else if (_selected.contains(
                                                        _listOfContacts[0]
                                                            [index]) &&
                                                    _selectingMode) {
                                                  var r = _listOfContacts[0]
                                                          [index]
                                                      as RegisteredPhoneContacts;
                                                  _animatedListKey.currentState!
                                                      .removeItem(
                                                          _selected.indexOf(r),
                                                          (context,
                                                                  animation) =>
                                                              Container(),
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      300));
                                                  _selected.remove(r);
                                                  setState(() {});
                                                }
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
                            return _ScaleAndSlide(
                                selected: _selected,
                                index: index,
                                animation: animation);
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

class _ScaleAndSlide extends StatelessWidget {
  const _ScaleAndSlide({
    Key? key,
    required this.animation,
    required this.index,
    required List<RegisteredPhoneContacts> selected,
  })   : _selected = selected,
        super(key: key);
  final int index;
  final Animation<double> animation;
  final List<RegisteredPhoneContacts> _selected;

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      alignment: Alignment.bottomCenter,
      scale: animation,
      child: SizeTransition(
        sizeFactor: animation,
        axis: Axis.horizontal,
        child: Column(
          children: [
            Container(
              height: 70,
              width: 70,
              margin: EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        _selected[index].user.photoUrl ??
                            GeneralConstants.DEFAULT_PHOTOURL),
                    fit: BoxFit.cover),
              ),
            ),
            Text(_selected[index].contact.givenName ??
                _selected[index].contact.displayName!),
          ],
        ),
      ),
    );
  }
}
