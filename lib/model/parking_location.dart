class ParkingLocation {
  final int id;
  final String district;
  final String city;
  final String coordinates;
  final double latitude;
  final double longitude;
  final String typeDirection;
  final String numDirection;
  final String street;
  final String reference;

  ParkingLocation({
    required this.id,
    required this.district,
    required this.city,
    required this.coordinates,
    required this.latitude,
    required this.longitude,
    required this.typeDirection,
    required this.numDirection,
    required this.street,
    required this.reference,
  });

  factory ParkingLocation.fromJson(Map<String, dynamic> json) {
    return ParkingLocation(
      id: json['id'],
      district: json['district'],
      city: json['city'],
      coordinates: json['coordinates'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      typeDirection: json['typeDirection'],
      numDirection: json['numDirection'],
      street: json['street'],
      reference: json['reference'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'district': district,
      'city': city,
      'coordinates': coordinates,
      'latitude': latitude,
      'longitude': longitude,
      'typeDirection': typeDirection,
      'numDirection': numDirection,
      'street': street,
      'reference': reference,
    };
  }
}
