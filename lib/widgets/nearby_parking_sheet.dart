import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:homey_park/model/model.dart';

class NearbyParkingSheet extends StatefulWidget {
  final List<Parking> parkings;

  final Function(Parking)? onTapParking;

  const NearbyParkingSheet(
      {super.key, required this.parkings, this.onTapParking});

  @override
  State<NearbyParkingSheet> createState() => _NearbyParkingSheetState();
}

class _NearbyParkingSheetState extends State<NearbyParkingSheet> {
  final apiKey = dotenv.env['MAPS_API_KEY'] ?? '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.09, // Initial height of the sheet
      minChildSize: 0.09, // Minimum height of the sheet
      maxChildSize: 0.6, // Maximum height of the sheet
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
          child: ListView(
            controller: scrollController,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Estacionamientos cercanos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // List of items

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    for (var parking in widget.parkings) ...[
                      InkWell(
                        onTap: () {
                          widget.onTapParking?.call(parking);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.1),
                            ),
                          ),
                          shadowColor: null,
                          clipBehavior: Clip.antiAlias,
                          color: Colors.white,
                          child: Row(
                            children: [
                              Image.network(
                                "https://maps.googleapis.com/maps/api/streetview?size=600x400&location=${parking.location.latitude},${parking.location.longitude}&key=$apiKey",
                                fit: BoxFit.cover,
                                height: 80,
                                width: 80,
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                      "${parking.location.address} ${parking.location.numDirection}",
                                      style: theme.textTheme.titleSmall?.apply(
                                          color: theme.colorScheme.onSurface)),
                                  subtitle: Text(
                                      "${parking.location.street}, ${parking.location.district}, ${parking.location.city}",
                                      style: theme.textTheme.bodySmall?.apply(
                                          color: theme
                                              .colorScheme.onSurfaceVariant)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
