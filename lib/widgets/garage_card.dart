import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:homey_park/model/parking.dart';

class GarageCard extends StatelessWidget {
  final int id;
  final Parking parking;
  final Function(int) onEdit;
  final Function(int) onDelete;

  final apiKey = dotenv.env['MAPS_API_KEY'] ?? '';

  GarageCard(
      {super.key,
      required this.id,
      required this.parking,
      required this.onEdit,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final location = parking.location;

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      clipBehavior: Clip.antiAlias,
      shadowColor: theme.colorScheme.primary.withOpacity(0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.network(
              "https://maps.googleapis.com/maps/api/streetview?size=600x400&location=${location.latitude},${location.longitude}&key=$apiKey",
              fit: BoxFit.cover,
              height: 180),
          Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${location.address} ${location.numDirection}",
                      style: theme.textTheme.bodyLarge
                          ?.apply(color: theme.colorScheme.onSurface)),
                  Text(
                      "${location.district}, ${location.street}, ${location.city}",
                      style: theme.textTheme.bodyMedium
                          ?.apply(color: theme.colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                          onPressed: () {
                            onDelete(id);
                          },
                          icon: Icon(Icons.delete_outlined,
                              color: theme.colorScheme.error),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: theme.colorScheme.error),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          label: Text(
                            "Borrar",
                            style: TextStyle(color: theme.colorScheme.error),
                          )),
                      const SizedBox(width: 8),
                      FilledButton.icon(
                          onPressed: () {
                            onEdit(id);
                          },
                          icon: const Icon(Icons.edit_outlined),
                          style: FilledButton.styleFrom(
                              backgroundColor: theme.colorScheme.tertiary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          label: const Text("Editar"))
                    ],
                  )
                ],
              ))
        ],
      ),
    );
  }
}
