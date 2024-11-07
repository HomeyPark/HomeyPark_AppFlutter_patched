import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homey_park/model/parking_location.dart';
import 'package:http/http.dart' as http;

class ExternalGooglePlacesService {
  static String apiUrl = "https://places.googleapis.com/v1/places";
  static final String? _apiKey = dotenv.env['MAPS_API_KEY'];

  static Future<LatLng> getLatLngByQuery(String query) async {
    var response = await http.post(Uri.parse('$apiUrl:searchText'),
        headers: {
          "Content-Type": "application/json",
          "X-Goog-Api-Key": _apiKey ?? '',
          "X-Goog-FieldMask": "*",
        },
        body: jsonEncode({"textQuery": query}));

    if (response.statusCode != 200) {
      throw Exception('Failed to load data');
    }

    var data = jsonDecode(response.body);

    print(data);

    var location = data['places'][0]['location'];
    var latitude = location['latitude'];
    var longitude = location['longitude'];

    return LatLng(latitude, longitude);
  }

  static Future<ParkingLocation> getParkingLocationByQuery(String query) async {
    var response = await http.post(Uri.parse('$apiUrl:searchText'),
        headers: {
          "Content-Type": "application/json",
          "X-Goog-Api-Key": _apiKey ?? '',
          "X-Goog-FieldMask": "*",
        },
        body: jsonEncode({"textQuery": query}));

    if (response.statusCode != 200) {
      throw Exception('Failed to load data');
    }

    var data = jsonDecode(response.body);

    var place = data['places'][0];
    var location = place['location'];
    var addressComponents = place['addressComponents'];

    String getAddressComponent(String type) {
      return addressComponents.firstWhere(
          (component) => (component['types'] as List).contains(type),
          orElse: () => {'longText': ''})['longText'];
    }

    ParkingLocation parkingLocation = ParkingLocation(
      address: place['formattedAddress'] ?? '',
      city: getAddressComponent('locality'),
      district: getAddressComponent('administrative_area_level_2'),
      latitude: location['latitude'],
      longitude: location['longitude'],
      numDirection: getAddressComponent('street_number'),
      street: getAddressComponent('route'),
    );

    return parkingLocation;
  }
}
