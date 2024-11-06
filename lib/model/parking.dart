import 'package:homey_park/model/parking_location.dart';

class Parking {
  final int id;
  final ParkingLocation location;
  final double price;
  final String address;
  final String description;

  Parking(
      {required this.id,
      required this.location,
      required this.price,
      required this.address,
      required this.description});

  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
        id: json['id'],
        location: ParkingLocation.fromJson(json['location']),
        address: json['address'],
        price: json['price'],
        description: json['description']);
  }
}
