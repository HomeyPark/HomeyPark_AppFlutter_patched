import 'package:homey_park/model/card.dart';
import 'package:homey_park/model/vehicle.dart';

class User {
  int id;
  String name;
  String lastName;
  String email;
  String password;
  List<Vehicle> vehicles;
  List<PaymentCard> cards;

  User(
      {required this.id,
      required this.name,
      required this.lastName,
      required this.email,
      required this.password,
      required this.vehicles,
      required this.cards});

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
      cards: (json['cards'] as List)
            .map((card) => PaymentCard.fromJson(card))
            .toList()
    );
  }
}
