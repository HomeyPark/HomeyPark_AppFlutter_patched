import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homey_park/config/constants/constants.dart';
import 'package:homey_park/utils/user_location.dart';

class CreateEditGarageScreen extends StatefulWidget {
  final int? id;

  // ignore: non_constant_identifier_names
  final DEFAULT_CENTER =
      const LatLng(DEFAULT_POSITION_MAP_LAT, DEFAULT_POSITION_MAP_LNG);

  const CreateEditGarageScreen({super.key, this.id});

  @override
  State<CreateEditGarageScreen> createState() => _CreateEditGarageScreenState();
}

class _CreateEditGarageScreenState extends State<CreateEditGarageScreen> {
  late final bool editMode;
  late GoogleMapController mapController;
  final Completer<GoogleMapController> _controllerCompleter = Completer();
  LatLng? _center;

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

  void onSave() {}

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
              const TextField(
                decoration: InputDecoration(
                  label: Text("Dirección"),
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
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
                          onTap: () {},
                          infoWindow: const InfoWindow(
                              title: "UPC",
                              snippet:
                                  "Universidad Peruana de Ciencias Aplicadas")),
                    },
                  ),
                ),
              ),
              const Divider(height: 56),
              Text("Dimensiones",
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: theme.colorScheme.onSurface)),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  label: Text("Espacios disponibles"),
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        label: Text("Altura"),
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        label: Text("Longitud"),
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        label: Text("Ancho"),
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 56),
              Text("Horario",
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: theme.colorScheme.onSurface)),
              Chip(
                padding: const EdgeInsets.all(4),
                label: IntrinsicWidth(
                  child: Row(
                    children: [
                      Text("Lunes 11:00 AM - 09:00 PM",
                          style: theme.textTheme.bodySmall
                              ?.apply(color: theme.colorScheme.onSurface)),
                      const SizedBox(width: 8),
                      IconButton(
                        style: ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize:
                              WidgetStateProperty.all(const Size(24, 24)),
                        ),
                        icon: Icon(Icons.cancel_outlined,
                            color: theme.colorScheme.error),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        style: ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize:
                              WidgetStateProperty.all(const Size(24, 24)),
                        ),
                        icon: Icon(Icons.edit_outlined,
                            color: theme.colorScheme.tertiary),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
                backgroundColor: Colors.white,
              ),
              Chip(
                padding: const EdgeInsets.all(4),
                label: IntrinsicWidth(
                  child: Row(
                    children: [
                      Text("Lunes 11:00 AM - 09:00 PM",
                          style: theme.textTheme.bodySmall
                              ?.apply(color: theme.colorScheme.onSurface)),
                      const SizedBox(width: 8),
                      IconButton(
                        style: ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize:
                              WidgetStateProperty.all(const Size(24, 24)),
                        ),
                        icon: Icon(Icons.cancel_outlined,
                            color: theme.colorScheme.error),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        style: ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize:
                              WidgetStateProperty.all(const Size(24, 24)),
                        ),
                        icon: Icon(Icons.edit_outlined,
                            color: theme.colorScheme.tertiary),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
                backgroundColor: Colors.white,
              ),
              Chip(
                padding: const EdgeInsets.all(4),
                label: IntrinsicWidth(
                  child: Row(
                    children: [
                      Text("Lunes 11:00 AM - 09:00 PM",
                          style: theme.textTheme.bodySmall
                              ?.apply(color: theme.colorScheme.onSurface)),
                      const SizedBox(width: 8),
                      IconButton(
                        style: ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize:
                              WidgetStateProperty.all(const Size(24, 24)),
                        ),
                        icon: Icon(Icons.cancel_outlined,
                            color: theme.colorScheme.error),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        style: ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize:
                              WidgetStateProperty.all(const Size(24, 24)),
                        ),
                        icon: Icon(Icons.edit_outlined,
                            color: theme.colorScheme.tertiary),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
                backgroundColor: Colors.white,
              ),
              OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    minimumSize: const Size(double.infinity, 40),
                  ),
                  label: const Text("Agregar horario"),
                  icon: const Icon(Icons.schedule_outlined)),
            ],
          )),
      persistentFooterButtons: [
        FilledButton(
          onPressed: () => {},
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
