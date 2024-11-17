import 'package:homey_park/model/reservation_status.dart';

class Reservation {
  int id;
  int hoursRegistered;
  double totalFare;
  DateTime startTime;
  DateTime endTime;
  ReservationStatus status;
  int guestId;
  int hostId;
  int parkingId;
  int vehicleId;
  int cardId;
  DateTime createdAt;
  DateTime updatedAt;

  Reservation({
    required this.id,
    required this.hoursRegistered,
    required this.totalFare,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.guestId,
    required this.hostId,
    required this.parkingId,
    required this.vehicleId,
    required this.cardId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      hoursRegistered: json['hoursRegistered'],
      totalFare: json['totalFare'].toDouble(),
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      status: statusFromJson(json['status']),
      guestId: json['guestId'],
      hostId: json['hostId'],
      parkingId: json['parkingId'],
      vehicleId: json['vehicleId'],
      cardId: json['cardId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
