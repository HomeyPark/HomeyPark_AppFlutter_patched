import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homey_park/config/constants/constants.dart';
import 'package:homey_park/model/model.dart';
import 'package:homey_park/model/parking_location.dart';
import 'package:homey_park/screens/manage_garage_screen.dart';
import 'package:homey_park/services/external_google_places_service.dart';
import 'package:homey_park/services/parking_service.dart';
import 'package:homey_park/utils/user_location.dart';

class CreateEditGarageScreen extends StatefulWidget {
  final int? id;

  final Function(Parking) onSave;

  // ignore: non_constant_identifier_names
  final DEFAULT_CENTER =
      const LatLng(DEFAULT_POSITION_MAP_LAT, DEFAULT_POSITION_MAP_LNG);

  const CreateEditGarageScreen({super.key, this.id, required this.onSave});

  @override
  State<CreateEditGarageScreen> createState() => _CreateEditGarageScreenState();
}

class _CreateEditGarageScreenState extends State<CreateEditGarageScreen> {
  late final bool editMode;
  late GoogleMapController mapController;
  final Completer<GoogleMapController> _controllerCompleter = Completer();
  final searchQueryFieldController = TextEditingController();
  ParkingLocation? _tempParkingLocation;
  LatLng? _center;

  final descriptionFieldController = TextEditingController();
  final spacesFieldController = TextEditingController();
  final heightFieldController = TextEditingController();
  final lengthFieldController = TextEditingController();
  final widthFieldController = TextEditingController();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _controllerCompleter.complete(controller);
  }

  void _fetchLocation() async {
    try {
      final position = await getUserLocation();

      setState(() {
        _center = LatLng(position.latitude, position.longitude);
      });

      final controller = await _controllerCompleter.future;
      controller.animateCamera(CameraUpdate.newLatLng(_center!));
    } catch (e) {
      _center = widget.DEFAULT_CENTER;
    }
  }

  void onSearchParkingLocationByQuery() async {
    final query = searchQueryFieldController.text;
    if (query.isEmpty) return;

    try {
      final location =
          await ExternalGooglePlacesService.getParkingLocationByQuery(query);

      setState(() {
        _center = LatLng(location.latitude, location.longitude);
        _tempParkingLocation = location;
      });

      final controller = await _controllerCompleter.future;
      controller.animateCamera(CameraUpdate.newLatLng(_center!));
    } catch (e) {
      print(e);
    }
  }

  void onSave() async {
    print(_tempParkingLocation);

    if (_tempParkingLocation == null) return;

    try {
      final description = descriptionFieldController.text;
      final spaces = int.parse(spacesFieldController.text);
      final height = double.parse(heightFieldController.text);
      final length = double.parse(lengthFieldController.text);
      final width = double.parse(widthFieldController.text);

      final parking = await ParkingService.createParking(
          userId: 1,
          width: width,
          length: length,
          height: height,
          space: spaces,
          description: description,
          address: _tempParkingLocation!.address,
          numDirection: _tempParkingLocation!.numDirection,
          street: _tempParkingLocation!.street,
          district: _tempParkingLocation!.district,
          city: _tempParkingLocation!.city,
          latitude: _center!.latitude,
          price: 2.5,
          longitude: _center!.longitude);

      print(parking);

      widget.onSave(parking);

      Navigator.pop(context);
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const ManageGarageScreen()),
      // );
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    editMode = widget.id != null;
    _fetchLocation();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          editMode ? "Editar tu garaje" : "Registra tu garaje",
          style: theme.textTheme.titleMedium,
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Ubicación",
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: theme.colorScheme.onSurface)),
              const SizedBox(height: 16),
              TextField(
                  controller: searchQueryFieldController,
                  decoration: InputDecoration(
                    label: const Text("Dirección"),
                    alignLabelWithHint: true,
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                        onPressed: onSearchParkingLocationByQuery,
                        icon: const Icon(Icons.search, color: Colors.black)),
                  )),
              const SizedBox(height: 16),
              Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                        target: _center ?? widget.DEFAULT_CENTER, zoom: 16.0),
                    zoomControlsEnabled: false,
                    markers: {
                      Marker(
                        markerId: const MarkerId("1"),
                        position: _center ?? widget.DEFAULT_CENTER,
                      )
                    },
                  ),
                ),
              ),
              const Divider(height: 56),
              Text("Descripción",
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: theme.colorScheme.onSurface)),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionFieldController,
                decoration: const InputDecoration(
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const Divider(height: 56),
              Text("Dimensiones",
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: theme.colorScheme.onSurface)),
              const SizedBox(height: 16),
              TextField(
                controller: spacesFieldController,
                decoration: const InputDecoration(
                  label: Text("Espacios disponibles"),
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: heightFieldController,
                      decoration: const InputDecoration(
                        label: Text("Altura"),
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: lengthFieldController,
                      decoration: const InputDecoration(
                        label: Text("Longitud"),
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: widthFieldController,
                      decoration: const InputDecoration(
                        label: Text("Ancho"),
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              // const Divider(height: 56),
              // OutlinedButton.icon(
              //     onPressed: () {},
              //     style: OutlinedButton.styleFrom(
              //       shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(8)),
              //       minimumSize: const Size(double.infinity, 40),
              //     ),
              //     label: const Text("Agregar horario"),
              //     icon: const Icon(Icons.schedule_outlined)),
            ],
          )),
      persistentFooterButtons: [
        FilledButton(
          onPressed: onSave,
          style: ButtonStyle(
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              minimumSize:
                  WidgetStateProperty.all(const Size(double.infinity, 48))),
          child: const Text("Agregar cochera"),
        ),
      ],
    );
  }
}
