class ParkingLocation {
  final int id;
  final String district;
  final String city;
  final double latitude;
  final double longitude;
  final String numDirection;
  final String street;

  ParkingLocation({
    required this.id,
    required this.district,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.numDirection,
    required this.street,
  });

  factory ParkingLocation.fromJson(Map<String, dynamic> json) {
    return ParkingLocation(
      id: json['id'],
      district: json['district'],
      city: json['city'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      numDirection: json['numDirection'],
      street: json['street'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'district': district,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'numDirection': numDirection,
      'street': street,
    };
  }
}
