import 'package:homey_park/model/parking_location.dart';
import 'package:homey_park/model/user.dart';

class Parking {
  final int id;
  final ParkingLocation location;
  final int spaces;
  final double price;
  final String description;
  final int space;
  final double width;
  final double height;
  final double length;
  final User user;

  Parking(
      {required this.id,
      required this.location,
      required this.price,
      required this.description,
      required this.user,
      required this.spaces,
      required this.height,
      required this.length,
      required this.width,
      required this.space});

  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
        id: json['id'],
        location: ParkingLocation.fromJson(json['location']),
        price: json['price'],
        description: json['description'],
        user: User.fromJson(json['user']),
        spaces: json['space'],
        height: json['height'],
        length: json['length'],
        width: json['width'],
        space: json['space']);
  }
}
