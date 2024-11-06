import 'package:flutter/material.dart';
import 'package:homey_park/widgets/garage_card.dart';

class ManageGarageScreen extends StatelessWidget {
  const ManageGarageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tus garajes",
          style: theme.textTheme.titleMedium,
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: const [
          GarageCard(id: 1),
          SizedBox(height: 16),
          GarageCard(id: 2),
          SizedBox(height: 16),
          GarageCard(id: 3),
        ],
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
        child: FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          style: ButtonStyle(
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          label: const Text("Agregar"),
        ),
      ),
    );
  }
}
