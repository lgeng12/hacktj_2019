import 'package:flutter/material.dart';

import 'package:flare_flutter/flare_actor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:nima/nima_actor.dart';

import 'dart:math';
import 'dart:convert';
import 'dart:io';
import 'dart:async';

// pages
import 'package:hacktj_2019/home.dart';
import 'package:hacktj_2019/tree.dart';
import 'package:hacktj_2019/friends.dart';
import 'package:hacktj_2019/myinfo.dart';

// other stuff
import 'package:hacktj_2019/friend.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoneyTrees',
      theme: new ThemeData(
        primaryColor: Colors.green,
      ),
      home: MoneyTrees(title: "MoneyTrees"),
    );
  }
}

class _MoneyTreesState extends State<MoneyTrees> {
  final TextStyle _biggerWhite = const TextStyle(color: Colors.white, fontSize: 20.0);
  final TextStyle _standardWhite = const TextStyle(color: Colors.white, fontSize: 16.0);
  final TextStyle _standardBlack = const TextStyle(color: Colors.black, fontSize: 18.0);
  final TextStyle _headerGreen = const TextStyle(color: Colors.greenAccent, fontSize: 20.0);

  PageController _pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
  }

  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void navigationTapped(int page) {
    // Animating to the page.
    // You can use whatever duration and curve you like
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          widget.title,
          style: _biggerWhite,
        ),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.settings), onPressed: _pushToSettings),
        ],
      ),
      body: new PageView(
        children: [
          new Home(title: "Home"),
          new Tree("Tree screen"),
          new FriendsPage(),
        ],
        onPageChanged: onPageChanged,
        controller: _pageController,
      ),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: Colors.green,
        ), // sets the inactive color of the `BottomNavigationBar`
        child: new BottomNavigationBar(
          items: [
            new BottomNavigationBarItem(
                icon: new Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                title: new Text(
                  "Home",
                  style: _standardWhite,
                )),
            new BottomNavigationBarItem(
                icon: new Icon(
                  Icons.nature,
                  color: Colors.white,
                ),
                title: new Text(
                  "Tree",
                  style: _standardWhite,
                )),
            new BottomNavigationBarItem(
                icon: new Icon(
                  Icons.people,
                  color: Colors.white,
                ),
                title: new Text(
                  "Friends",
                  style: _standardWhite,
                ))
          ],
          onTap: navigationTapped,
          currentIndex: _page,
        ),
      ),
    );
  }

  void _pushToSettings() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return new Scaffold(appBar: new AppBar(
              title: const Text('Settings'),
            ),
            body: new Container(
              margin: const EdgeInsets.all(10.0),
              color: Colors.white,
              alignment: Alignment.center,
              child: new Column(children: <Widget> [
                Text('Settings', style: _headerGreen,),
                FlatButton(
                  onPressed: () { _clearFriendJson(); },
                  child: Text('Clear Friends', style: _standardBlack),
                ),
                FlatButton(
                  onPressed: () { _clearMyJson(); },
                  child: Text('Reset Data', style: _standardBlack),
                ),
                FlatButton(
                  onPressed: () { _nextDay(); },
                  child: Text('New Day', style: _standardBlack),
                ),
              ]),
            )
          );
        }
      ),
    );
  }
  void _clearFriendJson() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/friends.json');
    await file.writeAsString("", flush: true);
  }

  void _clearMyJson() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/mydata.json');
    await file.writeAsString("", flush: true);
  }

  void _nextDay() async {
    String read = await readJson();
    // print("NEXT DAY READ: $read");
    MyInfo newInfo = _parseJson(read)[0];
    // update condition
    // print("AMOUNT SPENT: ${newInfo.amountSpent}");
    // print("MAX ALLOWANCE: ${newInfo.maxAllowance}");
    newInfo.amountSpent ??= 0.0;
    if (newInfo.amountSpent <= newInfo.maxAllowance) {
      if (newInfo.treeCondition < 4)
        newInfo.treeCondition += 1;
    }
    else if (newInfo.treeCondition > 0)
      newInfo.treeCondition -= 1;

    // update numTrees
    newInfo.numTrees = newInfo.balance.round() + 1;
    newInfo.amountSpent = 0.0;
    writeJson(json.encode(newInfo));
  }
  // take in json string, return list of my info
  List<MyInfo> _parseJson(String response) {
    if (response == null) {
      return [];
    }
    // print("json home decode: ");
    // print(json.decode(response.toString()));
    final parsed = json.decode('[${response.toString()}]').cast<
        Map<String, dynamic>>();
    return parsed.map<MyInfo>((json) => new MyInfo.fromJson(json)).toList();
  }

  // return a future string read from json file
  Future<String> readJson() async {
    String text;
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/mydata.json');
      text = await file.readAsString();
    } catch (e) {
      print("Couldn't read file");
    }
    return text;
  }

  // write text to json, replaces everything
  void writeJson(String text) async {
    // print('Trying to write: ${text}');
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/mydata.json');
    await file.writeAsString(text);
  }
}

class MoneyTrees extends StatefulWidget {
  MoneyTrees({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MoneyTreesState createState() => new _MoneyTreesState();
}