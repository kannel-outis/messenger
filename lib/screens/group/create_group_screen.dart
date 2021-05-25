import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:messenger/customs/widgets/custom_contact_tile.dart';
import 'package:messenger/models/contacts_model.dart';
import 'package:messenger/utils/constants.dart';
import 'package:provider/provider.dart';

class CreateGroupScreen extends StatefulWidget {
  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen>
    with SingleTickerProviderStateMixin {
  late GlobalKey<AnimatedListState> _animatedListKey;
  @override
  void initState() {
    super.initState();
    _animatedListKey = GlobalKey<AnimatedListState>();
  }

  final List<RegisteredPhoneContacts> _selected = [];
  bool _selectingMode = false;
  @override
  Widget build(BuildContext context) {
    var _listOfContacts = Provider.of<List<List<PhoneContacts>>>(context);

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
          elevation: 0.0,
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
          ],
        ),
        body: Column(
          children: [
            Container(
              height: 100,
              width: double.infinity,
              padding: EdgeInsets.only(left: 30, right: 50),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => print("camera something"),
                    child: Container(
                      height: 85,
                      width: 85,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                            width: 3,
                            style: BorderStyle.solid,
                            color: Colors.blue),
                        image: DecorationImage(
                          fit: BoxFit.scaleDown,
                          image: AssetImage('assets/person.png'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.black, style: BorderStyle.solid),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            // SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _selected.isNotEmpty
                    ? TextButton(
                        onPressed: () {
                          _selected.clear();
                          _animatedListKey = GlobalKey<AnimatedListState>();
                          setState(() {});
                        },
                        child: Text("cancel"),
                      )
                    : SizedBox(),
              ],
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
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
                  ..._listOfContacts.first.map((e) {
                    return InkWell(
                      onLongPress: () {
                        _selectingMode = true;
                        setState(() {});
                        if (!_selected.contains(e) && _selected.length < 5) {
                          _animatedListKey.currentState!.insertItem(
                              _selected.isEmpty ? 0 : _selected.length,
                              duration: const Duration(milliseconds: 300));
                          _selected.add(e as RegisteredPhoneContacts);
                          print(_selected.length);
                        }
                      },
                      onTap: () {
                        if (!_selected.contains(e) &&
                            _selectingMode &&
                            _selected.length < 5) {
                          _animatedListKey.currentState!.insertItem(
                              _selected.length,
                              duration: const Duration(milliseconds: 300));
                          _selected.add(e as RegisteredPhoneContacts);
                          setState(() {});
                          print(_selected.length);
                        } else if (_selected.contains(e) && _selectingMode) {
                          e as RegisteredPhoneContacts;
                          _animatedListKey.currentState!.removeItem(
                              _selected.indexOf(e),
                              (context, animation) => Container(),
                              duration: const Duration(milliseconds: 300));
                          _selected.remove(e);
                          setState(() {});
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20, left: 10),
                        child: Row(
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                        (e as RegisteredPhoneContacts)
                                                .user
                                                .photoUrl ??
                                            GeneralConstants.DEFAULT_PHOTOURL),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            Expanded(
                              child: BuildContactTile(
                                fromHome: false,
                                element: e,
                                isGroup: true,
                              ),
                            ),
                            _selectingMode == true
                                ? Checkbox(
                                    value: _selected.contains(e),
                                    onChanged: (e) =>
                                        print("something Happend"),
                                    tristate: true,
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    );
                    // return Text("Emir");
                  }).toList(),
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
