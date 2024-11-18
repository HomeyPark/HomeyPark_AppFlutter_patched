import 'package:flutter/material.dart';
import 'package:homey_park/config/pref/preferences.dart';
import 'package:homey_park/model/user.dart';
import 'package:homey_park/model/vehicle.dart';
import 'package:homey_park/services/user_service.dart';

class VehicleSelectDialog extends StatefulWidget {
  const VehicleSelectDialog({super.key});

  @override
  State<VehicleSelectDialog> createState() => _VehicleSelectDialogState();
}

class _VehicleSelectDialogState extends State<VehicleSelectDialog> {
  Future<User>? _vehiclesFuture;
  int? _currentVehicleId;
  Vehicle? _vehicle;

  Future<User> _fetchVehicles() async {
    final userId = await preferences.getUserId();
    return UserService.getUserById(userId);
  }

  @override
  void initState() {
    super.initState();
    _vehiclesFuture = _fetchVehicles();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text("Seleccione un vehículo", style: theme.textTheme.titleMedium),
      content: SizedBox(
        width: double.maxFinite,
        child: FutureBuilder(
          future: _vehiclesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text("Ocurrió un error al cargar los datos."),
              );
            }

            if (!snapshot.hasData || snapshot.data?.cards == null) {
              return const Center(
                child: Text("No se encontraron vehículos en su posesión."),
              );
            }

            final vehicles = snapshot.data!.vehicles;

            if (vehicles.isEmpty) {
              return const Center(
                child: Text("No tienes vehículos guardados."),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                final vehicle = vehicles[index];
                return ListTile(
                  trailing: Icon(
                      _currentVehicleId == vehicle.id
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: theme.primaryColor),
                  leading: const Icon(Icons.credit_card),
                  title: Text(vehicle.licensePlate,
                      style: theme.textTheme.labelLarge),
                  subtitle:
                      Text(vehicle.brand, style: theme.textTheme.labelMedium),
                  onTap: () {
                    setState(() {
                      _currentVehicleId = vehicle.id;
                      _vehicle = vehicle;
                    });
                  },
                );
              },
            );
          },
        ),
      ),
      actions: [
        OutlinedButton(
          style: ButtonStyle(
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(color: theme.colorScheme.error)),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancelar",
              style: TextStyle(color: theme.colorScheme.error)),
        ),
        FilledButton(
          style: ButtonStyle(
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          onPressed: () {
            if (_currentVehicleId != null) {
              Navigator.of(context).pop(_vehicle);
            }
          },
          child: const Text("Aceptar"),
        ),
      ],
    );
  }
}
