import 'dart:convert';

import 'package:homey_park/model/user.dart';
import 'package:http/http.dart' as http;

class UserService {
  static const String url = 'http://192.168.18.70:8080/users';

  static Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);

      List<User> parkings =
          body.map((dynamic item) => User.fromJson(item)).toList();

      return parkings;
    } else {
      return [];
    }
  }

  static Future<User> getUserById(int id) async {
    final response = await http.get(Uri.parse('$url/$id'));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load parking');
    }
  }
}
