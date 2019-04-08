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
    int numTrees = currentData.numTrees;
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
    asset = root;
    return root;
  }

  @override

  Widget build(BuildContext context) {
    updateCurrentData();
    asset = condition();

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
    currentData.amountSpent ??= 0.0;  // angery
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