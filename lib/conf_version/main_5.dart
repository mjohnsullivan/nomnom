/// Dismissible added to complete the package

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
  var places = <Place>[];

  @override
  initState() {
    super.initState();
    listenForPlaces();
  }

  listenForPlaces() async {
    var stream = await getPlaces(33.9850, -118.4695);
    stream.listen((place) => setState(() => places.add(place)));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new ListView(
          children: places.map((place) => new PlaceWidget(place)).toList(),
        ),
      ),
    );
  }
}

class PlaceWidget extends StatelessWidget {
  PlaceWidget(this.place);
  final Place place;
  
  @override
  Widget build(BuildContext context) {
    // CHANGED - dynamically select color of rating avatar
    // Normalize rating to (0,1) and interpolate color from red to green
    var ratingColor = Color.lerp(Colors.red, Colors.green, place.rating / 5);

    // CHANGED - made listTile a variable and passed it to Disimissible's child
    var listTile = new ListTile(
      leading: new CircleAvatar(
        child: new Text(place.rating.toString()),
        backgroundColor: ratingColor,
      ),
      title: new Text(place.name),
      subtitle: new Text(place.address),
    );
    // ADDED - Dismssible
    return new Dismissible(
      key: new Key(place.name),
      background: new Container(color: Colors.green),
      secondaryBackground: new Container(color: Colors.red),
      onDismissed: (dir) {
        if (dir == DismissDirection.startToEnd) {
          print('You liked ${place.name}');
        } else {
          print('You didn\'t like ${place.name}');
        }
      },
      child: listTile,
    );
  }
}