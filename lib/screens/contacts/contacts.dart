import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:messenger/customs/widgets/custom_contact_tile.dart';
import 'package:messenger/models/contacts_model.dart';
import 'package:messenger/screens/contacts/contacts_provider.dart';
import 'package:messenger/screens/home/home.dart';
import 'package:messenger/services/offline/hive.db/hive_init.dart';
import 'package:messenger/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

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
    const bothTilePanelHeihgt = 200;
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
    return (Utils.blockHeight * 50) - (100 + statusBarHeight);
  }

  @override
  Widget build(BuildContext context) {
    final _contactsProvider = Provider.of<ContactProvider>(context);

    // return ValueListenableBuilder(builder: ,);

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
      body: ValueListenableBuilder<Box<HivePhoneContactsList>>(
          // stream: null,
          valueListenable:
              Hive.box<HivePhoneContactsList>(HiveInit.hiveContactsList)
                  .listenable(),
          builder: (context, box, child) {
            if (box.values.isEmpty) {
              Provider.of<List<List<PhoneContacts>>>(context);
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return FutureBuilder<List<List<PhoneContacts>>>(
                future: _contactsProvider.decodeAndCreateContactsListFromJson(
                    box.values.toList().first.phoneContacts),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());
                  final _listOfContacts = snapshot.data!;
                  return Column(
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
                                  height: Utils.blockHeight *
                                      5 *
                                      _listOfContacts[0].length,
                                  constraints: BoxConstraints(
                                    maxHeight:
                                        Utils.blockHeight * 50 - 100 - 50,
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount:
                                                _listOfContacts[0].length,
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
                                  height: Utils.blockHeight *
                                      5 *
                                      _listOfContacts[1].length,
                                  constraints: BoxConstraints(
                                    maxHeight: _calcExpansionTileSpace(context),
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount:
                                                _listOfContacts[1].length,
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
                          ],
                        ),
                      ),
                    ],
                  );
                });
          }),
    );
  }
}
