// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_driver/driver_extension.dart';

import 'places.dart' as places;

void main() {
  // enableFlutterDriverExtension();
  runApp(new NomNomApp());
}

class NomNomApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Nom Nom',
      theme: new ThemeData(
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
  static const platform = const MethodChannel('com.mjohnsullivan.nomnom/gps');

  /// Gets GPS location from platform-specific code
  /// Note that only Android is implemented atm
  Future<Float64List> _getGPS() async {
    try {
      final Float64List result = await platform.invokeMethod('getGPS');
      return new Future(() => result);
    } on PlatformException catch (e) {
      print('Unable to retrieve GPS: ${e.message}');
    }
    return null;
  }

  /// Retrieves a list of restaurants from Google's Places REST API
  _getPlaces(double lat, double lng) async {
    var stream = await places.getPlaces(lat, lng); 
    stream.listen(
      (place) => setState(() => placeList.add(place))
    );
  }

  @override
  initState() {
    super.initState();
    _getGPS().then(
      (latLng) => _getPlaces(latLng[0], latLng[1])
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new ListView(
        children: placeList.map((place) => new PlaceWidget(place)).toList(),
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

    var listTile = new ListTile(
      leading: new CircleAvatar(
        child: new Text(place.rating.toString()),
        backgroundColor: ratingColor,
      ),
      title: new Text(place.name),
      subtitle: new Text(place.address ?? "unknown ..."),
      isThreeLine: false,
    );
    
    return new Dismissible(
      key: new Key(place.name),
      onDismissed: (dir) => dir == DismissDirection.startToEnd ?
        print('You favorited ${place.name}!') :
        print('You dismissed ${place.name} ...'),
      background: new Container(color: Colors.green,),
      secondaryBackground: new Container(color: Colors.red),
      child: listTile,
    );
  }
}