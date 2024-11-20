import 'package:flutter/material.dart';
import 'package:homey_park/config/pref/preferences.dart';
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
    final userId = await preferences.getUserId();

    final parkingList = await ParkingService.getParkingListByUserId(userId);
    setState(() {
      _parkingList = parkingList;
    });
  }

  void onEditGarage(BuildContext context, int id, Parking parking) async {
    final response = await Navigator.push<Parking>(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEditGarageScreen(id: id, parking: parking),
      ),
    );

    if (response == null) return;

    setState(() {
      final index = _parkingList.indexWhere((p) => p.id == id);
      if (index != -1) {
        _parkingList[index] = response;
      }
    });
  }

  void onDeleteGarage(BuildContext context, int id) async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Eliminando garaje..."),
    ));

    await ParkingService.deleteParking(id);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Garaje eliminado."),
    ));

    setState(() {
      _parkingList = _parkingList.where((parking) => parking.id != id).toList();
    });
  }

  void onAddGarage(BuildContext context) async {
    final response = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateEditGarageScreen(),
      ),
    );

    if (response == null) return;

    setState(() {
      _parkingList = [..._parkingList, response];
    });
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
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _parkingList.length,
              itemBuilder: (context, index) {
                return GarageCard(
                  id: _parkingList[index].id,
                  parking: _parkingList[index],
                  onDelete: (id) => onDeleteGarage(context, id),
                  onEdit: (id) =>
                      onEditGarage(context, id, _parkingList[index]),
                );
              }),
      persistentFooterButtons: [
        FilledButton.icon(
          onPressed: () => onAddGarage(context),
          icon: const Icon(Icons.add),
          style: ButtonStyle(
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              minimumSize:
                  WidgetStateProperty.all(const Size(double.infinity, 48))),
          label: const Text("Agregar"),
        ),
      ],
    );
  }
}
