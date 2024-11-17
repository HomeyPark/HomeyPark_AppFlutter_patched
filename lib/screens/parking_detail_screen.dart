import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:homey_park/model/parking.dart';
import 'package:homey_park/screens/screen.dart';
import 'package:homey_park/services/parking_service.dart';

class ParkingDetailScreen extends StatelessWidget {
  final int parkingId;

  const ParkingDetailScreen({super.key, required this.parkingId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    late Parking parking;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detalles del garaje",
          style: theme.textTheme.titleMedium,
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: ParkingService.getParkingById(parkingId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              parking = snapshot.data!;

              final latitude = parking.location.latitude;
              final longitude = parking.location.longitude;
              final apiKey = dotenv.env['MAPS_API_KEY'] ?? '';

              return Column(
                children: [
                  Stack(
                    children: [
                      Image.network(
                        "https://maps.googleapis.com/maps/api/streetview?size=600x400&location=$latitude,$longitude&key=$apiKey",
                        fit: BoxFit.cover,
                        height: 240,
                        width: double.infinity,
                      ),
                      Container(
                        width: double.infinity,
                        height: 240,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(
                                  0.6), // Bottom color with opacity
                              Colors.transparent, // Transparent top
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        bottom: 24,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${parking.location.address} ${parking.location.numDirection}",
                              style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${parking.location.district}, ${parking.location.street}, ${parking.location.city}",
                              style: theme.textTheme.labelMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: theme.primaryColor,
                                ),
                                Text(
                                  "4.5",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color:
                                          theme.colorScheme.onSurfaceVariant),
                                ),
                                Text(
                                  "Rating",
                                  style: theme.textTheme.labelMedium,
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Icon(
                                  Icons.money,
                                  color: theme.primaryColor,
                                ),
                                Text(
                                  "S/ ${parking!.price.toStringAsFixed(2)}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color:
                                          theme.colorScheme.onSurfaceVariant),
                                ),
                                Text(
                                  "Precio/hora",
                                  style: theme.textTheme.labelMedium,
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Icon(
                                  Icons.garage,
                                  color: theme.primaryColor,
                                ),
                                Text(
                                  "${parking.spaces} libres",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color:
                                          theme.colorScheme.onSurfaceVariant),
                                ),
                                Text(
                                  "Espacios",
                                  style: theme.textTheme.labelMedium,
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Propietario",
                              style: theme.textTheme.titleMedium,
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(
                                      "https://via.placeholder.com/150"),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${parking.user.name} ${parking.user.lastName}",
                                      style: theme.textTheme.labelLarge,
                                    ),
                                    Text(
                                      "Se unió a HomeyPark desde 22 Octubre, 2024",
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 32),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Descripción",
                              style: theme.textTheme.titleMedium,
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              parking.description,
                              style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.onSurface.withOpacity(0.1),
              blurRadius: 16,
            ),
          ],
        ),
        width: double.infinity,
        child: FilledButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CheckoutScreen(parking: parking)),
            );
          },
          style: ButtonStyle(
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          child: const Text("Reservar"),
        ),
      ),
    );
  }
}
