import 'package:flutter/material.dart';
import 'package:homey_park/model/vehicle.dart';
import 'package:homey_park/services/user_service.dart';
import 'package:homey_park/services/vehicle_service.dart';

class ManageVehiclesScreen extends StatefulWidget {
  const ManageVehiclesScreen({super.key});

  @override
  State<ManageVehiclesScreen> createState() => _ManageVehiclesScreenState();
}

class _ManageVehiclesScreenState extends State<ManageVehiclesScreen> {
  late List<Vehicle> vehicles;

  void handleDeleteVehicle(int id) async {
    final response = await VehicleService.deleteVehicle(id);

    if (response) {
      setState(() {
        vehicles.removeWhere((element) => element.id == id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Vehículos",
          style: theme.textTheme.titleMedium,
        ),
        actions: [TextButton(onPressed: () {}, child: const Text("Agregar"))],
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Gestiona tus vehículos para el uso de estacionamientos de HomeyPark.",
              style: theme.textTheme.bodyMedium
                  ?.apply(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            FutureBuilder(
                future: UserService.getUserById(2),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    vehicles = snapshot.data!.vehicles;

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: vehicles.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              clipBehavior: Clip.antiAlias,
                              shadowColor:
                                  theme.colorScheme.primary.withOpacity(0.4),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.directions_car),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "${vehicles[index].brand} ${vehicles[index].model}",
                                              style: theme.textTheme.labelMedium
                                                  ?.apply(
                                                      color: theme.colorScheme
                                                          .onSurface)),
                                          Text(vehicles[index].licensePlate,
                                              style: theme.textTheme.bodySmall
                                                  ?.apply(
                                                      color: theme.colorScheme
                                                          .onSurfaceVariant)),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.edit_outlined)),
                                    IconButton(
                                        onPressed: () {
                                          handleDeleteVehicle(
                                              vehicles[index].id);
                                        },
                                        icon: const Icon(Icons.delete_outlined))
                                  ],
                                ),
                              ),
                            ),
                            index == vehicles.length - 1
                                ? Container()
                                : const SizedBox(height: 16),
                          ],
                        );
                      },
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                })
          ],
        ),
      ),
    );
  }
}