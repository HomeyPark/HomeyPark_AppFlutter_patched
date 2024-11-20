import 'dart:convert';
import 'package:homey_park/services/base_service.dart';
import 'package:http/http.dart' as http;
import 'package:homey_park/model/vehicle.dart';

class VehicleService {
  static final String url = "${BaseService.baseUrl}/vehicles";

  static Future<Vehicle> getVehicleById(int id) async {
    final response = await http.get(Uri.parse('$url/$id'));

    if (response.statusCode == 200) {
      return Vehicle.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load vehicle');
    }
  }

  static Future<Vehicle?> postVehicle(Vehicle newVehicle, int userId) async {
    final response = await http.post(
      Uri.parse('$url/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({...newVehicle.toJson(), "userId": userId}),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Vehicle.fromJson(data);
    } else {
      throw Exception('Failed to add payment card');
    }
  }

  static Future<Vehicle?> putVehicle(Vehicle newVehicle) async {
    final response = await http.put(
      Uri.parse('$url/update/${newVehicle.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({...newVehicle.toJson(), "userId": 1}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Vehicle.fromJson(data);
    } else {
      throw Exception('Failed to update payment card');
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
