// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_driver/driver_extension.dart';

import './places.dart' as places;

void main() {
  enableFlutterDriverExtension();
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
  StreamController<places.Place> placesStreamController;
  List<places.Place> placeList;
  static const platform = const MethodChannel('com.mjohnsullivan.nomnom/gps');

  _getGPS() async {
    try {
      final Float64List result = await platform.invokeMethod('getGPS');
      print('GPS result: $result');
      _getPlaces(result[0], result[1]);
    } on PlatformException catch (e) {
      print('Unable to retrieve GPS: ${e.message}');
    }
  }

  _getPlaces(double lat, double lng) {
    placesStreamController = new StreamController<places.Place>.broadcast();
    placesStreamController.stream.listen(
      (place) => setState( () => placeList.add(place) )
    );
    places.getPlaces(lat, lng, placesStreamController); 
  }

  @override
  initState() {
    super.initState();
    placeList = [];
    _getGPS();
  }

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
    Color ratingColor = Colors.green[800];
    if (place.rating < 2) {
      ratingColor = Colors.green[100];
    } else if (place.rating < 4) {
      ratingColor = Colors.green[400];
    }
    
    return new Dismissible(
      key: new Key(place.name),
      onDismissed: (dir) => dir == DismissDirection.startToEnd ?
        print('You favorited ${place.name}!') :
        print('You dismissed ${place.name} ...'),
      background: new Container(color: Colors.green,),
      secondaryBackground: new Container(color: Colors.red),
      child: new ListTile(
        leading: new CircleAvatar(
          child: new Text(place.rating.toString()),
          backgroundColor: ratingColor,
        ),
        title: new Text(place.name),
        subtitle: new Text(place.vicinity ?? "unknown ..."),
        isThreeLine: false,
      )
    );
  }
}