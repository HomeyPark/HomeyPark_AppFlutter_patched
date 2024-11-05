import 'package:flutter/material.dart';
import 'package:homey_park/widgets/reservation_card.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  void onTapReservation(int id) {
    print("Tapped reservation with id: $id");
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Mis reservas",
            style: theme.textTheme.titleMedium,
          ),
          backgroundColor: Colors.white,
          bottom: const TabBar(tabs: [
            Tab(text: "En progreso"),
            Tab(text: "Próximas"),
            Tab(text: "Pasadas"),
          ]),
        ),
        body: TabBarView(children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ReservationCard(
                    id: 1,
                    status: ReservationStatus.inProgress,
                    address: "Avenida Siempre Viva",
                    number: "123",
                    date: DateTime.now(),
                    startTime: const TimeOfDay(hour: 3, minute: 0),
                    endTime: const TimeOfDay(hour: 3, minute: 30),
                    onTapReservation: onTapReservation),
                ReservationCard(
                  id: 2,
                  status: ReservationStatus.approved,
                  address: "Avenida Siempre Viva",
                  number: "123",
                  date: DateTime.now(),
                  startTime: const TimeOfDay(hour: 3, minute: 0),
                  endTime: const TimeOfDay(hour: 3, minute: 30),
                  onTapReservation: onTapReservation,
                ),
                ReservationCard(
                  id: 3,
                  status: ReservationStatus.completed,
                  address: "Avenida Siempre Viva",
                  number: "123",
                  date: DateTime.now(),
                  startTime: const TimeOfDay(hour: 3, minute: 0),
                  endTime: const TimeOfDay(hour: 3, minute: 30),
                  onTapReservation: onTapReservation,
                ),
              ],
            ),
          ),
          const Center(
            child: Text("It's cloudy here"),
          ),
          const Center(
            child: Text("It's rainy here"),
          ),
          const Center(
            child: Text("It's sunny here"),
          ),
        ]),
      ),
    );
  }
}
