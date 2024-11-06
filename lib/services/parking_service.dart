import 'dart:convert';

// import 'package:homey_park/model/parking_location.dart';
import 'package:homey_park/model/parking.dart';
import 'package:homey_park/model/parking_location.dart';
import 'package:http/http.dart' as http;

class ParkingService {
  static const String url = 'http://192.168.18.70:8080/parking';

  static Future<List<Parking>> getParkings() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);

      List<Parking> parkings =
          body.map((dynamic item) => Parking.fromJson(item)).toList();

      return parkings;
    } else {
      return [];
    }
  }

  static Future<List<ParkingLocation>> getParkingsLocations() async {
    final parkings = await getParkings();

    List<ParkingLocation> locations = parkings
        .map((Parking parking) => parking.location)
        .toList()
        .cast<ParkingLocation>();

    return locations;
  }

  static Future<Parking> getParkingById(int id) async {
    final response = await http.get(Uri.parse('$url/$id/details'));

    if (response.statusCode == 200) {
      return Parking.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load parking');
    }
  }
}
