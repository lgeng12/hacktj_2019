import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flare_flutter/flare_actor.dart';
import 'package:nima/nima_actor.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Home> {
  double _counter = 30;
  var date = new DateTime.now();

  void _incrementCounter() {
    setState(() {
      _counter--;
    });
  }
  double _getCount() {
    return this._counter;
  }
  void _ChangeCounter(num) {
    setState(() {
      _counter-=num;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
                'balance is \$' + '$_counter',
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
  bool died = false;
  var asset = "assets/tree.nima";

  void check(num) {
    if (num < 0) {
      setState(() {
        asset = "assets/dyingtree.nima";
      });
    }
    if (asset == "assets/dyingtree.nima" && num > 0) {
      setState(() {
        asset = "assets/tree.nima";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    check(widget.counter);
    print(this.asset);

    return Container(
      height: 125,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.green,
      ),
      child: ClipRect(
        clipBehavior: Clip.hardEdge,
        child: OverflowBox(
          maxHeight: 125,
          maxWidth: 125,
          child: Center(
            child: Container(
              child: NimaActor(this.asset, alignment:Alignment.center, fit:BoxFit.contain,mixSeconds: 0.5, animation:"Idle"),
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
      onSubmitted : (input) {this.parent._ChangeCounter(double.tryParse(input));controllerT.clear();},
    );
  }
}