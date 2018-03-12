/// Streamed places added

import 'dart:async';

import 'package:flutter/material.dart';

import 'places_2.dart' show Place, getPlaces;

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
  // CHANGED - places is now of type <Place>[]
  var places = <Place>[];
  static final double starterDistance = 500.0;
  double _distance = starterDistance;

  @override
  initState() {
    super.initState();
    // ADDED - function call to listen to places
    listenForPlaces();
  }

  // ADDED - set up places stream listener
  listenForPlaces() async { 
    Stream<Place> stream = await getPlaces(33.9850, -118.4695, _distance);
    stream.listen((place) => setState(() => places.add(place)));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Column(
        children: <Widget>[
          new Slider(
            value: _distance,
            min: 300.0,
            max: 1000.0,
            onChanged: (double newValue) {
              setState(() {
              _distance = newValue;
              
              listenForPlaces();
              });
            }
          ),
          new Expanded(
            child: new ListView(
              children: places.map((place) => new PlaceWidget(place)).toList(),
            ),
          ),
        ]
      ),
    );
  }
}

class PlaceWidget extends StatelessWidget {
  Place _place;

  PlaceWidget(this._place);
  @override

  Widget build(BuildContext context) {
    var listTile = new ListTile(
      title: new Text(_place.name),
      subtitle: new Text(_place.address),
      leading: new CircleAvatar(
        child: new Text(_place.rating.toString()),
        backgroundColor: Colors.blue,
      )
    );

    return new Dismissible(
      key: new Key(_place.name),
      child: listTile,
      background: new Container(color: Colors.red),
      secondaryBackground: new Container(color: Colors.green),
    );
  }
}
