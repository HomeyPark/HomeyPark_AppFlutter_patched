import 'package:flutter/material.dart';
import 'package:homey_park/screens/screen.dart';

class ParkingDetailScreen extends StatelessWidget {
  final int parkingId;

  const ParkingDetailScreen({super.key, required this.parkingId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detalles del garaje",
          style: theme.textTheme.titleMedium,
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
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
                                color: theme.colorScheme.onSurfaceVariant),
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
                            "S/ 4.50",
                            style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.onSurfaceVariant),
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
                            Icons.garage,
                            color: theme.primaryColor,
                          ),
                          Text(
                            "3 libres",
                            style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.onSurfaceVariant),
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
                            backgroundImage:
                                NetworkImage("https://via.placeholder.com/150"),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "José Mourihno",
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
                    children: [
                      Text(
                        "Descripción",
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ligula nisl, sagittis vel eros ut, accumsan sodales metus. Morbi eget metus rhoncus, sagittis nisi vitae, consequat sapien. Cras molestie nulla nunc, at volutpat turpis imperdiet ac. Donec eros dolor, sodales nec dignissim at, laoreet in urna. Praesent quis nisi accumsan, facilisis lectus ut, laoreet augue. Integer nec convallis lectus, in ultrices purus. Ut viverra, odio non malesuada laoreet, massa lorem varius ex, et egestas nibh nulla efficitur sem. Mauris semper, libero eget facilisis congue, augue erat eleifend arcu, sit amet viverra diam tellus sed sem. Aenean elementum nibh volutpat ante ultrices luctus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Proin pretium vel libero sit amet aliquam. Nullam risus nulla, hendrerit ut cursus et, viverra ut lorem. Vestibulum in venenatis eros, ac fermentum justo.\n\nAliquam interdum orci orci, eu venenatis elit gravida a. Nunc id tempus quam. Etiam id nunc sapien. Proin a porttitor mauris. Vestibulum eu dui lacinia sapien placerat aliquam. Maecenas lacus odio, mollis eget condimentum laoreet, elementum eu nisi. Nunc mollis lorem a fringilla tristique. Cras quis aliquam risus, id imperdiet urna. Nullam non semper nibh, nec vulputate elit. Fusce volutpat arcu enim, commodo hendrerit justo finibus vitae. Duis molestie orci venenatis, molestie nisl vitae, eleifend erat. Donec dictum congue ipsum ac molestie.",
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
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
              MaterialPageRoute(builder: (context) => const CheckoutScreen()),
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
