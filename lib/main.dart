import 'package:flutter/material.dart';
import 'package:hacktj_2019/home.dart';
import 'package:hacktj_2019/tree.dart';
import 'package:hacktj_2019/friends.dart';

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

class MoneyTreesState extends State<MoneyTrees> {
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
        duration: const Duration(milliseconds: 200), curve: Curves.ease);
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
          style: new TextStyle(color: Colors.white),
        ),
      ),
      body: new PageView(
        children: [
          new Home("Home screen"),
          new Tree("Tree screen"),
          new Friends("Friends screen"),
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
                  style: new TextStyle(
                    color: Colors.white,
                  ),
                )),
            new BottomNavigationBarItem(
                icon: new Icon(
                  Icons.nature,
                  color: Colors.white,
                ),
                title: new Text(
                  "Tree",
                  style: new TextStyle(
                    color: Colors.white,
                  ),
                )),
            new BottomNavigationBarItem(
                icon: new Icon(
                  Icons.people,
                  color: Colors.white,
                ),
                title: new Text(
                  "Friends",
                  style: new TextStyle(
                    color: Colors.white,
                  ),
                ))
          ],
          onTap: navigationTapped,
          currentIndex: _page,
        ),
      ),
    );
  }
}

class MoneyTrees extends StatefulWidget {
  MoneyTrees({Key key, this.title}) : super(key: key);
  final String title;
  @override
  MoneyTreesState createState() => new MoneyTreesState();
}