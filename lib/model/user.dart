import 'package:homey_park/model/vehicle.dart';

class User {
  int id;
  String name;
  String lastName;
  String email;
  String password;
  List<Vehicle> vehicles;

  User(
      {required this.id,
      required this.name,
      required this.lastName,
      required this.email,
      required this.password,
      required this.vehicles});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      lastName: json['lastName'],
      email: json['email'],
      password: json['password'],
      vehicles: (json['vehicles'] as List)
          .map((vehicle) => Vehicle.fromJson(vehicle))
          .toList(),
    );
  }
}
