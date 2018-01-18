/// ListView added

import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Nom Nom',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new MyHomePage(title: 'Nom Nom'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // ADDED - Places list to the state
  var places = <String>[];

  @override
  initState() {
    super.initState();
    // ADDED - add 100 places to the places list
    for (int i=0; i<100; i++) {
      places.add('Place $i');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        // ADDED - ListView replaces the hello World Text widget
        child: new ListView(
          children: places.map((place) => new Text(place)).toList(),
        ),
      ),
    );
  }
}
