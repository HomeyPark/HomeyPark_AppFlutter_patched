class ReservationDto {
  int hoursRegistered;
  double totalFare;
  String startTime;
  String endTime;
  int guestId;
  int hostId;
  int parkingId;
  int vehicleId;
  int cardId;

  ReservationDto({
    required this.hoursRegistered,
    required this.totalFare,
    required this.startTime,
    required this.endTime,
    required this.guestId,
    required this.hostId,
    required this.parkingId,
    required this.vehicleId,
    required this.cardId,
  });

  Map<String, dynamic> toJson() {
    return {
      'hoursRegistered': hoursRegistered,
      'totalFare': totalFare,
      'startTime': startTime,
      'endTime': endTime,
      'guestId': guestId,
      'hostId': hostId,
      'parkingId': parkingId,
      'vehicleId': vehicleId,
      'cardId': cardId,
    };
  }
}
