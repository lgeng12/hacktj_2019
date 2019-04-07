import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flare_flutter/flare_actor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:nima/nima_actor.dart';

import 'dart:math';
import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'myinfo.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Home> {
  double _counter;
  final oneSecond = Duration(seconds: 1);
  final oneTenth = Duration(milliseconds: 100);

  void _changeCounter(num) {
    setState(() {
      _counter -= num;
      _updateBalanceToJson(num);
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<String> read = readJson();
    read.then((value) => _checkJson(value));

    if (_counter == null) {
      print('Trying to update counter');
      _updateFromJson();
    }

    print('Value of counter: ${_counter}');

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
                'Balance is \$' + '$_counter',
                style: new TextStyle(
                  fontFamily: "Montserrat", fontSize: 40.0,
                )
            ),
            OverlapSquare(_counter),
            Text(' '),
            AddBalance(this),
          ],
        ),
      ),
    );
  }

  // json contents -> initialize if necessary
  void _checkJson(String fromFile) {
    print('from file: $fromFile');
    if (fromFile.length == 0) {  // nonexistent idk
      _initializeBalance();
    }
    else {
      MyInfo currentInfo = _parseJson(fromFile)[0];
      _counter = currentInfo.balance;
    }
  }

  // to default values
  void _initializeBalance() {
    writeJson(json.encode(new MyInfo(
        name: "John",
        balance: 30,
        maxAllowance: 30,
        amountSpent: 0,
        treeCondition: 3,
        numTrees: 5,
    )));
    _counter = 30;
  }

  void _updateBalanceToJson(double change) async {
    String read = await readJson();
    _writeInfoToJson(_counter, change, read);
  }

  void _writeInfoToJson(double balance, double change, String fromFile) {  // angery
    MyInfo oldInfo = _parseJson(fromFile)[0];
    oldInfo.balance = balance;
    oldInfo.amountSpent ??= 0.0;
    oldInfo.amountSpent += change;
    writeJson(json.encode(oldInfo));
  }

  void _updateFromJson() async {
    String read = await readJson();
    MyInfo currentInfo = _parseJson(read)[0];
    setState(() {
      _counter = currentInfo.balance;
    });
  }

  // take in json string, return list of my info
  List<MyInfo> _parseJson(String response) {
    if (response == null) {
      return [];
    }
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

class OverlapSquare extends StatefulWidget{
  final double counter;
  OverlapSquare(this.counter);

  static OverlapSquareState of(BuildContext context) => context.ancestorStateOfType(const TypeMatcher<OverlapSquareState>());
  @override
  OverlapSquareState createState() => OverlapSquareState(counter);
}


class OverlapSquareState extends State<OverlapSquare> {
  OverlapSquareState(number);
  String _animationName = "Active";
  bool died = false;
  var asset = "assets/tree.flr";

  void check(num) {
    num ??= 0;
    if (num < 0) {
      setState(() {
        asset = "assets/dying.flr";
      });
    }
    if (asset == "assets/dying.flr" && num > 0) {
      setState(() {
        asset = "assets/tree.flr";
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    check(widget.counter);

    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.green,
      ),
      child: ClipRect(
        clipBehavior: Clip.hardEdge,
        child: OverflowBox(
          maxHeight: 100,
          maxWidth: 100,
          child: Center(
            child: Container(
              child: FlareActor(this.asset, alignment:Alignment.center, fit:BoxFit.cover, animation: _animationName),
              decoration: BoxDecoration(
                color: Colors.green[50],
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddBalance extends StatelessWidget {
  _MyHomePageState parent;

  AddBalance(this.parent);

  Widget build(BuildContext context) {
    TextEditingController controllerT = TextEditingController();
    return  TextField(
      controller: controllerT,
      decoration: new InputDecoration(
        labelText: "Enter spending",
        fillColor: Colors.white,
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(25.0),
          borderSide: new BorderSide(
          ),
        ),
        //fillColor: Colors.green
      ),
      keyboardType: TextInputType.number,
      style: new TextStyle(
        fontFamily: "Poppins",
      ),
      onSubmitted : (input) {this.parent._changeCounter(double.tryParse(input)); controllerT.clear();},
    );
  }
}