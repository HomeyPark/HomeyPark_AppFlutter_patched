import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homey_park/config/constants/constants.dart';
import 'package:homey_park/screens/screen.dart';
import 'package:homey_park/utils/user_location.dart';
import 'package:homey_park/widgets/navigation_menu.dart';

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

  navigateToParkingDetailScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ParkingDetailScreen(parkingId: 1)),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const NavigationMenu(),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition:
                CameraPosition(target: _center ?? DEFAULT_CENTER, zoom: 16.0),
            zoomControlsEnabled: false,
            markers: {
              Marker(
                  markerId: const MarkerId("1"),
                  position: _center ?? DEFAULT_CENTER,
                  onTap: navigateToParkingDetailScreen,
                  infoWindow: const InfoWindow(
                      title: "UPC",
                      snippet: "Universidad Peruana de Ciencias Aplicadas")),
            },
          ),
          Positioned(
            top: 40,
            left: 15,
            right: 15,
            child: SearchBar(
              controller: searchQueryFieldController,
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
          )
        ],
      ),
    );
  }
}
