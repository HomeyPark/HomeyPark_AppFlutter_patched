import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homey_park/config/constants/constants.dart';
import 'package:homey_park/screens/screen.dart';
import 'package:homey_park/services/parking_service.dart';
import 'package:homey_park/utils/user_location.dart';
import 'package:homey_park/widgets/navigation_menu.dart';
import 'package:homey_park/widgets/nearby_parking_sheet.dart';

// ignore: constant_identifier_names
const DEFAULT_CENTER =
    LatLng(DEFAULT_POSITION_MAP_LAT, DEFAULT_POSITION_MAP_LNG);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late GoogleMapController mapController;
  final Completer<GoogleMapController> _controllerCompleter = Completer();
  final searchQueryFieldController = TextEditingController();

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
      _center = DEFAULT_CENTER;
    }
  }

  navigateToParkingDetailScreen(int? parkingId) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ParkingDetailScreen(parkingId: parkingId!)),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
        key: _scaffoldKey,
        drawer: const NavigationMenu(),
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            FutureBuilder(
                future: ParkingService.getParkingsLocations(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                          target: _center ?? DEFAULT_CENTER, zoom: 16.0),
                      zoomControlsEnabled: false,
                      markers: snapshot.hasData
                          ? {
                              ...snapshot.data!.map((location) => Marker(
                                    markerId: MarkerId(location.id.toString()),
                                    position: LatLng(
                                        location.latitude, location.longitude),
                                    onTap: () => navigateToParkingDetailScreen(
                                        location.id),
                                  )),
                              Marker(
                                markerId: const MarkerId('current'),
                                position: _center!,
                                icon: BitmapDescriptor.defaultMarkerWithHue(
                                    BitmapDescriptor.hueGreen),
                              )
                            }
                          : {});
                }),
            Positioned(
              top: 40,
              left: 15,
              right: 15,
              child: SearchBar(
                hintText: "Buscar por nombre o dirección",
                controller: searchQueryFieldController,
                backgroundColor: const WidgetStatePropertyAll(Colors.white),
                shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
                leading: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                ),
                trailing: [
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            FutureBuilder(
                future: ParkingService.getNearbyParkings(
                    _center!.latitude, _center!.longitude),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasData) {
                    return NearbyParkingSheet(
                      parkings: snapshot.data ?? [],
                      onTapParking: (parking) =>
                          navigateToParkingDetailScreen(parking.id),
                    );
                  }

                  return const SizedBox.shrink();
                })
          ],
        ));
  }
}
