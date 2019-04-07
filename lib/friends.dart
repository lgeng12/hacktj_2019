import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:math';

import 'package:hacktj_2019/friend.dart';

class FriendsPage extends StatefulWidget {
  final String title;
  const FriendsPage({Key key, this.title}) : super(key: key);

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final List<Friend> _friends = new List<Friend>();
  final Set<String> _friendNames = new Set<String>();  // avoid duplicates, bad
  var rng = new Random();

  @override
  // friend list page
  Widget build(BuildContext context) {
    return new Scaffold (
      body: _buildFriendsList(),
      floatingActionButton:  FloatingActionButton(
        onPressed: _pushToAdd,
        tooltip: 'Add Friend',
        child: Icon(Icons.add),
      ),
    );
  }

  // friend list
  Widget _buildFriendsList() {
    // TEMP
    _addFriend('john', 1, 2);
    _addFriend('sean', 1, 2);
    _addFriend('quentin', 1, 2);

    return new ListView(
      padding: const EdgeInsets.all(16.0),
      children: _buildColumn(),
    );
  }

  List<Widget> _buildColumn() {
    List<Widget> column = new List<Widget>();
    for (Friend f in _friends) {
      column.add(_buildRow(f));
      column.add(Divider());
    }
    return column;
  }

  Widget _buildRow(Friend f) {
    return new ListTile(
      title: new Text(
        f.name,
      ),
      trailing: new Text(
        f.numTrees.toString(),
      ),
    );
  }

  void _addFriend(String n, int tc, int nt) {
    if (_friendNames.contains(n)) {
      return;
    }
    Friend f = Friend(
        name: n, treeCondition: tc , numTrees: nt,
    );
    _friends.add(f);
    _friendNames.add(n);
  }

  void _pushToAdd() {
    final friendController = new TextEditingController();
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return new Scaffold(appBar: new AppBar(
              title: const Text('Add a friend'),
            ),
                body: new Container(
                  margin: const EdgeInsets.all(10.0),
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: new Column(children: <Widget>[
                      new TextField(
                        decoration: new InputDecoration(
                            // counterText: "100",
                            // filled: true,
                            // fillColor: Colors.grey[300],
                            hintText: 'Name'),
                        autofocus: true,
                        controller: friendController,
                        onSubmitted: (input) {
                          _addFriend(input, 0, rng.nextInt(20));
                          friendController.clear();
                        }
                      ),
                    ],
                  ),
                )
            );
          }
      ),
    );
  }
}