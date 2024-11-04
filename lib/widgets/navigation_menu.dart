import 'package:flutter/material.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

const guestDestinations = [
  NavigationDrawerDestination(
      icon: Icon(Icons.search), label: Text("Buscar un garage")),
  NavigationDrawerDestination(
      icon: Icon(Icons.apps), label: Text("Tus reservas"))
];
const hostDestinations = [
  NavigationDrawerDestination(
      icon: Icon(Icons.garage), label: Text("Tus garages")),
  NavigationDrawerDestination(
      icon: Icon(Icons.inbox), label: Text("Reservas entrantes")),
];

const accountDestinations = [
  NavigationDrawerDestination(
      icon: Icon(Icons.account_circle), label: Text("Perfil")),
  NavigationDrawerDestination(
      icon: Icon(Icons.directions_car), label: Text("Vehículos")),
  NavigationDrawerDestination(
      icon: Icon(Icons.credit_card), label: Text("Métodos de pago")),
  NavigationDrawerDestination(
      icon: Icon(Icons.logout), label: Text("Cerrar sesión")),
];

class _NavigationMenuState extends State<NavigationMenu> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  int screenIndex = 0;
  late bool showNavigationDrawer;

  void handleScreenChanged(int selectedScreen) {
    setState(() {
      screenIndex = selectedScreen;
    });
  }

  void openDrawer() {
    scaffoldKey.currentState!.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      key: scaffoldKey,
      selectedIndex: screenIndex,
      children: [
        ...guestDestinations,
        const Divider(),
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Text("Renta un garaje",
              style: Theme.of(context).textTheme.titleSmall),
        ),
        ...hostDestinations,
        const Divider(),
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Text("Cuenta", style: Theme.of(context).textTheme.titleSmall),
        ),
        ...accountDestinations
      ],
    );
  }
}
