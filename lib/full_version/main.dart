// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'places.dart' as places;

void main() => runApp(NomNomApp());

class NomNomApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nom Nom',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  var placeList = <places.Place>[];

  /// Retrieves a list of restaurants from Google's Places REST API
  _getPlaces(double lat, double lng) async {
    final stream = await places.getPlaces(lat, lng);
    stream.listen((place) => setState(() => placeList.add(place)));
  }

  @override
  initState() {
    super.initState();
    _getPlaces(34.0195, -118.4912);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: placeList.map((place) => PlaceWidget(place)).toList(),
      ),
    );
  }
}

class PlaceWidget extends StatelessWidget {
  PlaceWidget(this.place);
  final places.Place place;

  @override
  Widget build(BuildContext context) {
    // Normalize rating to (0,1) and interpolate color from red to green
    var ratingColor = Color.lerp(Colors.red, Colors.green, place.rating / 5);

    var listTile = ListTile(
      leading: CircleAvatar(
        child: Text(place.rating.toString()),
        backgroundColor: ratingColor,
      ),
      title: Text(place.name),
      subtitle:  Text(place.address ?? "unknown ..."),
      isThreeLine: false,
    );

    return Dismissible(
      key: Key(place.name),
      onDismissed: (dir) => dir == DismissDirection.startToEnd
          ? print('You favorited ${place.name}!')
          : print('You dismissed ${place.name} ...'),
      background: Container(
        color: Colors.green,
      ),
      secondaryBackground: Container(color: Colors.red),
      child: listTile,
    );
  }
}
