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
class Tree extends StatefulWidget {
  Tree({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyTreePageState createState() => _MyTreePageState();
}

class _MyTreePageState extends State<Tree> {
  var asset = "assets/healthy1.flr";
  MyInfo currentData;

  String condition(){
    int treeCondition = currentData.treeCondition;
    String root = "assets/";
    if (treeCondition == 1){
      root += 'stump';
    }
    if (treeCondition == 2){
      root += 'dead';
    }
    if (treeCondition == 3){
      root += 'unhealthy';
    }
    if (treeCondition == 4){
      root += 'healthy';
    }
    root += '1.flr';
    asset = root;
    return root;

  }

  @override

  Widget build(BuildContext context) {
    updateCurrentData();

    return new Scaffold(
      body: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Name: ${currentData.name}"),
            Text("Amount Spent Today: ${currentData.amountSpent}"),
            Text("Max Allowance: ${currentData.maxAllowance}"),
            Text("Tree Condition: ${currentData.treeCondition}"),
            Text("Number of Trees: ${currentData.numTrees}"),
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

  void updateCurrentData() async {
    String read = await readJson();
    currentData = _parseJson(read)[0];
    print("TREE AMOUNT SPENT: ${currentData.amountSpent}");
    currentData.amountSpent ??= 0.0;  // angery
  }

  // take in json string, return list of my info
  List<MyInfo> _parseJson(String response) {
    if (response == null) {
      return [];
    }
    print("TREE TEXT 2: ${response}");
    final parsed = json.decode('[${response.toString()}]').cast<
        Map<String, dynamic>>();
    print("TREE TEXT 3: ${parsed}");
    return parsed.map<MyInfo>((json) => new MyInfo.fromJson(json)).toList();
  }

  // return a future string read from json file
  Future<String> readJson() async {
    String text;
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/mydata.json');
      text = await file.readAsString();
      print("TREE TEXT: ${text}");
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