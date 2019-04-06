import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  @override
  // friend list page
  Widget build(BuildContext context) {
    return new Scaffold (
      body: _buildFriendsList(),
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

  void _addFriend(String n, int tl, int nt) {
    if (_friendNames.contains(n)) {
      return;
    }
    Friend f = Friend(n, tl, nt);
    _friends.add(f);
    _friendNames.add(n);
  }
}