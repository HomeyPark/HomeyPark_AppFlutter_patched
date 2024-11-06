import 'package:flutter/material.dart';

class GarageCard extends StatelessWidget {
  final int id;
  const GarageCard({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          Image.network("https://picsum.photos/250?image=9",
              fit: BoxFit.cover, height: 180),
          Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Avenida Siempre Viva 123",
                      style: theme.textTheme.bodyLarge
                          ?.apply(color: theme.colorScheme.onSurface)),
                  Text("Surquillo, Lima",
                      style: theme.textTheme.bodyMedium
                          ?.apply(color: theme.colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                          onPressed: () {},
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
                          onPressed: () {},
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
