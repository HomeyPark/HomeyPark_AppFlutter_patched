import 'package:flutter/material.dart';
import 'package:homey_park/screens/screen.dart';
import 'package:homey_park/widgets/widgets.dart';

class ManageGarageScreen extends StatelessWidget {
  const ManageGarageScreen({super.key});

  void onEditGarage(BuildContext context, int id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateEditGarageScreen(id: id)),
    );
  }

  void onDeleteGarage(BuildContext context, int id) {}

  void onAddGarage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateEditGarageScreen()),
    );
  }

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
        children: [
          GarageCard(
            id: 1,
            onDelete: (id) => onDeleteGarage(context, id),
            onEdit: (id) => onEditGarage(context, id),
          ),
          const SizedBox(height: 16),
          GarageCard(
            id: 2,
            onDelete: (id) => onDeleteGarage(context, id),
            onEdit: (id) => onEditGarage(context, id),
          ),
          const SizedBox(height: 16),
          GarageCard(
            id: 3,
            onDelete: (id) => onDeleteGarage(context, id),
            onEdit: (id) => onEditGarage(context, id),
          ),
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
          onPressed: () => onAddGarage(context),
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
