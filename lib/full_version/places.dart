// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../key.dart' show key;

class Place {
  final String name;
  final double rating;
  final String address;

  Place.fromJson(Map jsonMap) :
    name = jsonMap['name'],
    rating = jsonMap['rating'].toDouble(),
    address = jsonMap['vicinity'];

  String toString() => 'Place: $name';
}

Future<Stream<Place>> getPlaces(double lat, double lng) async {
  var url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json' +
    '?location=$lat,$lng' +
    '&radius=500&type=restaurant' +
    '&key=$key';

  // http.get(url).then( (res) => print(res.body) );
  var client = new http.Client();
  var streamedRes = await client.send(new http.Request('get', Uri.parse(url)));

  return streamedRes.stream
    .transform(UTF8.decoder)
    .transform(JSON.decoder)
    .expand((jsonBody) => (jsonBody as Map)['results'])
    .map((jsonPlace) => new Place.fromJson(jsonPlace));
    // .listen( (data) => print(data))
    // .onDone( () => client.close());
}

/// For testing purposes only
main() {
  // Co-ords for Venice Beach, CA
  getPlaces(34.0195, -118.4912);
}
