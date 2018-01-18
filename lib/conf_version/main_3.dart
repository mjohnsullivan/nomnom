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
  // ADDED - a place stream controller
  StreamController<Place> placesStreamController;

  @override
  initState() {
    super.initState();
    // ADDED - set up places stream
    placesStreamController = new StreamController<Place>.broadcast();
    placesStreamController.stream.listen(
      (place) => setState(
        () => places.add(place)
      )
    );
    getPlaces(33.9850, -118.4695, placesStreamController);
  }

  // ADDED - dispose properly of the places stream
  @override
  dispose() {
    super.dispose();
    placesStreamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        // CHANGED - Text now uses place.name
        child: new ListView(
          children: places.map((place) => new Text(place.name)).toList(),
        ),
      ),
    );
  }
}
