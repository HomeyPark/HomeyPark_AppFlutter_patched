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

      print(parkings);

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

  static Future<List<Parking>> getParkingListByUserId(int id) async {
    final response = await http.get(Uri.parse('$url/user/$id'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      var parkings =
          body.map((dynamic item) => Parking.fromJson(item)).toList();

      print("DEBUG PARKINGS BY USER ID");
      print(parkings);

      return parkings;
    } else {
      return [];
    }
  }

  static Future<Parking> getParkingById(int id) async {
    final response = await http.get(Uri.parse('$url/$id/details'));

    if (response.statusCode == 200) {
      return Parking.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load parking');
    }
  }

  static Future<Parking> createParking(
      {required double width,
      required int userId,
      required double length,
      required double height,
      required double price,
      String phone = '',
      required int space,
      required String description,
      required String address,
      required String numDirection,
      required String street,
      required String district,
      required String city,
      required double latitude,
      required double longitude}) async {
    final response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'width': width,
          'length': length,
          'height': height,
          'price': price,
          'phone': phone,
          'space': space,
          'description': description,
          'address': address,
          'numDirection': numDirection,
          'street': street,
          'district': district,
          'city': city,
          'latitude': latitude,
          'longitude': longitude,
          'userId': userId
        }));

    if (response.statusCode == 200) {
      return Parking.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load parking');
    }
  }
}
