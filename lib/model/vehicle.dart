class Vehicle {
  final int id;
  final String licensePlate;
  final String model;
  final String brand;

  Vehicle(
      {required this.id,
      required this.licensePlate,
      required this.model,
      required this.brand});

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      licensePlate: json['licensePlate'],
      model: json['model'],
      brand: json['brand'],
    );
  }
}