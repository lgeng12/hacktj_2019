import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flare_flutter/flare_actor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:nima/nima_actor.dart';

import 'dart:math';
import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'friend.dart';

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
  var asset = "";

  final List<Friend> _friends = new List<Friend>();
  final Set<String> _friendNames = new Set<String>(); // avoid duplicates, bad
  var rng = new Random();

  String condition(Friend f){
    int treeCondition = f.treeCondition;
    int numTrees = f.numTrees;
    String root = "assets/";
    if (treeCondition == 0){
      root += 'stump';
    }
    if (treeCondition == 1){
      root += 'dead';
    }
    if (treeCondition == 2){
      root += 'unhealthy';
    }
    if (treeCondition == 3){
      root += 'healthy';
    }
    if (numTrees <= 1){
      root += '1';
    }
    else if (numTrees <= 5){
      root += '2';
    }
    else if (numTrees <= 10){
      root += '3';
    }
    else {
      root += '4';
    }
    root += '.flr';
    return root;
  }

  @override
  // friend list page
  Widget build(BuildContext context) {
    updateFriendList();
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
                            _addFriend(input, rng.nextInt(4), rng.nextInt(20));
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
    this.asset = condition(f);
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return new Scaffold(appBar: new AppBar(
              title: const Text('Your Friend\'s tree'),
            ),
            body: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                Text("Name: ${f.name}"),
                Text("Tree Condition: ${f.treeCondition}"),
                Text("Number of Trees: ${f.numTrees}"),
                Text(""),  // spacing?
                Text(""),  // spacing?
                Container(
                    height: 300,
                    child: ClipRect(
                      clipBehavior: Clip.hardEdge,
                      child: OverflowBox(
                        maxHeight: 300,
                        maxWidth: 300,
                        child: Center(
                          child: FlareActor(this.asset, alignment:Alignment.center, fit:BoxFit.cover, animation: 'Untitled'),
                        ),
                      ),
                    ),
                ),
                ]
            ),
            );
          }
      ),
    );
  }

  void _pushToRefresh() {

  }

  void updateFriendList() async {
    String read = await readJson();
    List<Friend> friendsToAdd = _parseJson(read);
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
    writeJson(json.encode(_friends));
  }

  void writeJson(String text) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/friends.json');
    await file.writeAsString(text);
  }
}