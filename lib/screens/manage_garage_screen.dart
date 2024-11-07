import 'package:flutter/material.dart';
import 'package:homey_park/screens/screen.dart';
import 'package:homey_park/services/parking_service.dart';
import 'package:homey_park/services/user_service.dart';
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
      body: FutureBuilder(
          future: ParkingService.getParkingListByUserId(1),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              children: snapshot.data!.map((parking) {
                return GarageCard(
                  id: parking.id,
                  parking: parking,
                  onDelete: (id) => onDeleteGarage(context, id),
                  onEdit: (id) => onEditGarage(context, id),
                );
              }).toList(),
            );
          }),
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
