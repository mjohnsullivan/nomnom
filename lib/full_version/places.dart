// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

/// GCP key to access the Places API
const key = '';

class Place {
  final String name;
  final double rating;
  final String address;

  Place.fromJson(Map jsonMap)
      : name = jsonMap['name'],
        rating = jsonMap['rating'].toDouble(),
        address = jsonMap['vicinity'];
}

/// Retrieves a stream of places either from the network or local asset
Future<Stream<Place>> getPlaces(double lat, double lng) {
  return key.length > 0 ? getPlacesFromNetwork(lat, lng) : getPlacesFromAsset();
}

/// Retrieves a stream of places from the Google Places API
Future<Stream<Place>> getPlacesFromNetwork(double lat, double lng) async {
  var url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json' +
      '?location=$lat,$lng' +
      '&radius=500&type=restaurant' +
      '&key=$key';

  var client = new http.Client();
  var streamedRes = await client.send(new http.Request('get', Uri.parse(url)));

  return streamedRes.stream
      .transform(UTF8.decoder)
      .transform(JSON.decoder)
      .expand((jsonBody) => (jsonBody as Map)['results'])
      .map((jsonPlace) => new Place.fromJson(jsonPlace));
}

/// Retrieves a stream of places from a local json asset
Future<Stream<Place>> getPlacesFromAsset() async {
  return new Stream.fromFuture(rootBundle.loadString('assets/places.json'))
    .transform(json.decoder)
    .expand((jsonBody) => (jsonBody as Map)['results'])
    .map((jsonPlace) => new Place.fromJson(jsonPlace));
}
