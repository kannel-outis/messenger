import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:messenger/customs/widgets/custom_contact_tile.dart';
import 'package:messenger/models/contacts_model.dart';
import 'package:messenger/screens/home/home.dart';
import 'package:provider/provider.dart';

class ContactsScreen extends StatefulWidget {
  final bool? fromHome;

  const ContactsScreen({Key? key, this.fromHome}) : super(key: key);

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen>
    with TickerProviderStateMixin {
  bool? _registeredCollapse;
  bool? _unRegisteredCollapse;
  late final AnimationController _controller;
  late final AnimationController _controller2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      value: 0,
      duration: Duration(milliseconds: 300),
    );
    _controller2 = AnimationController(
      vsync: this,
      value: 0,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    super.dispose();
  }

  double _calcExpansionTileSpace(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    const appBarHeight = 100;
    const bothTilePanelHeihgt = 150;
    if (_registeredCollapse != null &&
        _registeredCollapse == true &&
        _unRegisteredCollapse != true) {
      return MediaQuery.of(context).size.height -
          (bothTilePanelHeihgt + statusBarHeight + appBarHeight);
    }

    if (_unRegisteredCollapse != null &&
        _unRegisteredCollapse == true &&
        _registeredCollapse != true) {
      return MediaQuery.of(context).size.height -
          (bothTilePanelHeihgt + statusBarHeight + appBarHeight);
    }
    return (MediaQuery.of(context).size.height / 2) - (100 + statusBarHeight);
  }

  @override
  Widget build(BuildContext context) {
    var _listOfContacts = Provider.of<List<List<PhoneContacts>>>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 100,
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.grey,
            fontSize: 35,
            fontWeight: FontWeight.w500,
          ),
        ),
        title: Text('Contacts'),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () => widget.fromHome != true
                ? Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => HomeScreen(),
                    ),
                  )
                : Navigator.pop(context),
            style: ButtonStyle(
              textStyle: MaterialStateProperty.all<TextStyle>(
                TextStyle(fontSize: 18),
              ),
            ),
            child: Center(
              child: widget.fromHome != true ? Text('Skip') : Text('Go Back'),
            ),
          ),
        ],
      ),
      body: _listOfContacts.length <= 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              // bool _isRegistered =
              //     _listOfContacts[index] == _listOfContacts.first;
              children: [
                Container(
                  child: Column(
                    children: [
                      ExpansionTile(
                        trailing: AnimatedIcon(
                          icon: AnimatedIcons.menu_close,
                          progress: _controller2,
                          color: Colors.grey,
                        ),
                        maintainState: true,
                        onExpansionChanged: (boolean) {
                          _registeredCollapse = boolean;
                          if (_registeredCollapse == true) {
                            _controller2.forward();
                          } else if (_registeredCollapse == false) {
                            _controller2.reverse();
                          } else {
                            _controller2.reset();
                          }
                          print(_registeredCollapse);
                          setState(() {});
                        },
                        title: Container(
                          height: 50,
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          width: double.infinity,
                          color: Colors.grey.shade600,
                          child: Text(
                            'Registered',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        children: [
                          Container(
                            height: (MediaQuery.of(context).size.height / 100) *
                                5 *
                                _listOfContacts[0].length,
                            child: Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: _listOfContacts[0].length,
                                      itemBuilder: (context, i) {
                                        return BuildContactTile(
                                          fromHome: widget.fromHome,
                                          element: _listOfContacts[0][i],
                                        );
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // ..._listOfContacts[index].map((e) {
                      // return _BuildContactTile(
                      //   fromHome: fromHome,
                      //   contactModel: _contactModel,
                      //   element: e,
                      // );
                      //   // return Text("Emir");
                      // }).toList(),
                      // ConstrainedBox(
                      //   constraints: BoxConstraints(maxHeight: 1000),
                      //   child: ListView.builder(
                      //       shrinkWrap: true,
                      //       itemCount: _listOfContacts[index].length,
                      //       itemBuilder: (context, i) {
                      //         return _BuildContactTile(
                      //           fromHome: fromHome,
                      //           contactModel: _contactModel,
                      //           element: _listOfContacts[index][i],
                      //         );
                      //       }),
                      // ),
                    ],
                  ),
                ),
                //

                Container(
                  child: Column(
                    children: [
                      ExpansionTile(
                        maintainState: true,
                        // collapsedBackgroundColor: Colors.red,
                        trailing: AnimatedIcon(
                          icon: AnimatedIcons.menu_close,
                          color: Colors.grey,
                          progress: _controller,
                        ),
                        onExpansionChanged: (boolean) {
                          _unRegisteredCollapse = boolean;
                          if (_unRegisteredCollapse == true) {
                            _controller.forward();
                          } else if (_unRegisteredCollapse == false) {
                            _controller.reverse();
                          } else {
                            _controller.reset();
                          }
                          setState(() {});
                        },
                        title: Container(
                          height: 50,
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          width: double.infinity,
                          color: Colors.grey.shade600,
                          child: Text(
                            'UnRegistered',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        children: [
                          Container(
                            height: (MediaQuery.of(context).size.height / 100) *
                                5 *
                                _listOfContacts[1].length,
                            constraints: BoxConstraints(
                              // maxHeight: (MediaQuery.of(context).size.height /
                              //         2) -
                              //     (100 + MediaQuery.of(context).padding.top),
                              maxHeight: _calcExpansionTileSpace(context),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: _listOfContacts[1].length,
                                      itemBuilder: (context, i) {
                                        return BuildContactTile(
                                          fromHome: widget.fromHome,
                                          element: _listOfContacts[1][i],
                                        );
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // ..._listOfContacts[index].map((e) {
                      // return _BuildContactTile(
                      //   fromHome: fromHome,
                      //   contactModel: _contactModel,
                      //   element: e,
                      // );
                      //   // return Text("Emir");
                      // }).toList(),
                      // ConstrainedBox(
                      //   constraints: BoxConstraints(maxHeight: 1000),
                      //   child: ListView.builder(
                      //       shrinkWrap: true,
                      //       itemCount: _listOfContacts[index].length,
                      //       itemBuilder: (context, i) {
                      //         return _BuildContactTile(
                      //           fromHome: fromHome,
                      //           contactModel: _contactModel,
                      //           element: _listOfContacts[index][i],
                      //         );
                      //       }),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
