import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:homey_park/model/vehicle.dart';

class VehicleService {
  static const String url = 'http://192.168.18.70:8080/vehicles';

  static Future<Vehicle> getVehicleById(int id) async {
    final response = await http.get(Uri.parse('$url/$id'));

    if (response.statusCode == 200) {
      return Vehicle.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load vehicle');
    }
  }

  static Future<bool> deleteVehicle(int id) async {
    final response = await http.delete(Uri.parse('$url/delete/$id'));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
