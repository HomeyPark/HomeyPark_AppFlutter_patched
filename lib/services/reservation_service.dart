import 'dart:convert';
import 'package:homey_park/model/reservation.dart';
import 'package:homey_park/model/reservation_dto.dart';
import 'package:homey_park/services/base_service.dart';
import 'package:http/http.dart' as http;

class ReservationService extends BaseService {
  static final String baseUrl = "${BaseService.baseUrl}/reservations";

  static Future<Reservation> getReservationById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      dynamic body = jsonDecode(response.body);

      return Reservation.fromJson(body);
    } else {
      throw Exception('Failed to load reservation');
    }
  }

  static Future<List<Reservation>> getReservationsByHostId(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/host/$id'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);

      print("DEBUG");
      print(body);
      var reservations =
          body.map((dynamic item) => Reservation.fromJson(item)).toList();

      return reservations;
    } else {
      return [];
    }
  }

  static Future<List<Reservation>> getReservationsByGuestId(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/guest/$id'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);

      print("DEBUG");
      print(body);
      var reservations =
          body.map((dynamic item) => Reservation.fromJson(item)).toList();

      return reservations;
    } else {
      return [];
    }
  }

  static Future createReservation(ReservationDto reservation) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(reservation.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create reservation');
    }
  }
}
