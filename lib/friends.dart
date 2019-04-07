import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';

import 'dart:math';
import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:hacktj_2019/friend.dart';

// currently unused
enum TreeCondition {
  deceased,
  decaying,
  bare,
  growing,
  lush
}

class FriendsPage extends StatefulWidget {
  final String title;
  const FriendsPage({Key key, this.title}) : super(key: key);

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final List<Friend> _friends = new List<Friend>();
  final Set<String> _friendNames = new Set<String>(); // avoid duplicates, bad
  var rng = new Random();

  @override
  // friend list page
  Widget build(BuildContext context) {
    return new Scaffold (
      body: _buildFriendsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _pushToAdd,
        tooltip: 'Add Friend',
        child: Icon(Icons.add),
      ),
    );
  }

  // friend list
  Widget _buildFriendsList() {
    // TEMP
    Future<String> read = readJson();
    read.then((value) => updateFriendList(value));

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
      onTap: () { _pushToView(f); },
    );
  }

  void _addFriend(String n, int tc, int nt) {
    if (_friendNames.contains(n)) {
      return;
    }
    Friend f = Friend(
      name: n, treeCondition: tc, numTrees: nt,
    );
    _friends.add(f);
    _friendNames.add(n);
    updateJson();

    Map<String, dynamic> content = new Map();
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
                            hintText: 'Name'),
                        autofocus: true,
                        controller: friendController,
                        onSubmitted: (input) {
                          _addFriend(input, rng.nextInt(5), rng.nextInt(20));
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

  void _pushToView(Friend f) {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return new Scaffold(appBar: new AppBar(
              title: const Text('Your Friend\'s tree'),
            ),
                body: new Container(
                  margin: const EdgeInsets.all(10.0),
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: new Column(children: <Widget>[
                    Text("Friend: ${f.name}"),
                    Text("Tree Condition: ${f.treeCondition}"),
                    Text("Number of Trees: ${f.numTrees}"),
                  ],
                  ),
                )
            );
          }
      ),
    );
  }

  void _pushToRefresh() {

  }

  void updateFriendList(String response) {
    List<Friend> friendsToAdd = _parseJson(response);
    for(Friend f in friendsToAdd) {
      if (_friendNames.contains(f.name)) {
        continue;
      }
      _friends.add(f);
      _friendNames.add(f.name);
    }
  }

  List<Friend> _parseJson(String response) {
    if (response == null) {
      return [];
    }
    final parsed = json.decode(response.toString()).cast<
        Map<String, dynamic>>();
    return parsed.map<Friend>((json) => new Friend.fromJson(json)).toList();
  }

  Future<String> readJson() async {
    String text;
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/friends.json');
      text = await file.readAsString();
    } catch (e) {
      print("Couldn't read file");
    }
    return text;
  }

  void updateJson() {
    // print(json.encode(_friends));
    writeJson(json.encode(_friends));
  }

  void writeJson(String text) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/friends.json');
    await file.writeAsString(text);
    Future<String> r = readJson();
    r.then((value) => print(value));
  }

  void clearJson() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/friends.json');
    await file.writeAsString("", flush: true);
  }
}