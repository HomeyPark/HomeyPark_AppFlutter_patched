import 'dart:convert';

import 'package:homey_park/services/base_service.dart';
import 'package:http/http.dart' as http;
import 'package:homey_park/model/card.dart';

class PaymentService extends BaseService {
  static final String url = "${BaseService.baseUrl}/cards";

  static Future<PaymentCard> getCardById(int id) async {
    final response = await http.get(Uri.parse('$url/$id'));

    if (response.statusCode == 200) {
      return PaymentCard.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load payment card');
    }
  }

  static Future<PaymentCard?> postPaymentCard(
      PaymentCard newCard, int userId) async {
    final response = await http.post(
      Uri.parse('$url/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({...newCard.toJson(), "userId": userId}),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return PaymentCard.fromJson(data);
    } else {
      throw Exception('Failed to add payment card');
    }
  }

  static Future<bool> deletePaymentCard(int id) async {
    final response = await http.delete(Uri.parse('$url/delete/$id'));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
