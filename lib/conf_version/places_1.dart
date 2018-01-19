// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:http/http.dart' as http;

import '../key.dart' show key;

main() {
  getPlaces(33.9850, -118.4695); // Venice Beach, CA
}

class Place {
  final String name;
  final double rating;
  final String vicinity;

  Place.fromJson(Map jsonMap) :
    name = jsonMap['name'],
    rating = jsonMap['rating']?.toDouble() ?? -1.0,
    vicinity = jsonMap['vicinity'];

  String toString() => 'Place: $name';
}

getPlaces(double lat, double lng) async {
  var url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json' +
    '?location=$lat,$lng' +
    '&radius=500&type=restaurant' +
    '&key=$key';

  http.get(url).then(
    (res) => print(res.body)
  );

  /*
  var client = new http.Client();
  var req = new http.Request('get', Uri.parse(url));
  var streamedRes = await client.send(req);
  */

  //streamedRes.stream
  //  .transform(UTF8.decoder)
  //  .transform(JSON.decoder)
  //  .expand((jsonBody) => (jsonBody as Map)['results'] )
  //  .map((jsonPlace) => new Place.fromJson(jsonPlace));
  //  .listen( (data) => print(data))
  //  .onDone( () => client.close());
  //  .pipe(controller);
}