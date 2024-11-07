import 'package:homey_park/model/parking_location.dart';
import 'package:homey_park/model/user.dart';

class Parking {
  final int id;
  final ParkingLocation location;
  final int spaces;
  final double price;
  final String description;
  final User user;

  Parking(
      {required this.id,
      required this.location,
      required this.price,
      required this.description,
      required this.user,
      required this.spaces});

  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
        id: json['id'],
        location: ParkingLocation.fromJson(json['location']),
        price: json['price'],
        description: json['description'],
        user: User.fromJson(json['user']),
        spaces: json['space']);
  }
}
