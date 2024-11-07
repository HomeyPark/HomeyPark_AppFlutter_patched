import 'package:flutter/material.dart';
import 'package:homey_park/screens/screen.dart';
import 'package:homey_park/services/parking_service.dart';
// import 'package:homey_park/services/user_service.dart';
import 'package:homey_park/widgets/widgets.dart';

import '../model/parking.dart';

class ManageGarageScreen extends StatefulWidget {
  const ManageGarageScreen({super.key});

  @override
  _ManageGarageScreenState createState() => _ManageGarageScreenState();
}

class _ManageGarageScreenState extends State<ManageGarageScreen> {
  List<Parking> _parkingList = [];

  @override
  void initState() {
    super.initState();
    _loadParkingList();
  }

  void _loadParkingList() async {
    final parkingList = await ParkingService.getParkingListByUserId(1);
    setState(() {
      _parkingList = parkingList;
    });
  }

  void onEditGarage(BuildContext context, int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEditGarageScreen(
          id: id,
          onSave: (parking) {
            setState(() {
              final index = _parkingList.indexWhere((p) => p.id == id);
              if (index != -1) {
                _parkingList[index] = parking;
              }
            });
          },
        ),
      ),
    );
  }

  void onDeleteGarage(BuildContext context, int id) {
    setState(() {
      _parkingList.removeWhere((parking) => parking.id == id);
    });
  }

  void onAddGarage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEditGarageScreen(
          onSave: (parking) {
            print(parking);
            setState(() {
              _parkingList.add(parking);
            });
          },
        ),
      ),
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
      body: _parkingList.isEmpty
          ? const CircularProgressIndicator()
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              children: _parkingList.map((parking) {
                return GarageCard(
                  id: parking.id,
                  parking: parking,
                  onDelete: (id) => onDeleteGarage(context, id),
                  onEdit: (id) => onEditGarage(context, id),
                );
              }).toList(),
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
            shape: MaterialStateProperty.all(
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
