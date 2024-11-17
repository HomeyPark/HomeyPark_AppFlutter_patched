import 'package:flutter/material.dart';
import 'package:homey_park/config/pref/preferences.dart';
import 'package:homey_park/model/model.dart';
import 'package:homey_park/model/reservation.dart';
import 'package:homey_park/screens/reservation_detail_screen.dart';
import 'package:homey_park/services/parking_service.dart';
import 'package:homey_park/services/reservation_service.dart';
import 'package:homey_park/widgets/widgets.dart';

class HostReservationsScreen extends StatefulWidget {
  const HostReservationsScreen({super.key});

  @override
  State<HostReservationsScreen> createState() => _HostReservationsScreenState();
}

class _HostReservationsScreenState extends State<HostReservationsScreen> {
  var _loading = true;
  var _reservationsList = <Reservation>[];

  var _incomingReservationsList = <Reservation>[];
  var _pastReservationsList = <Reservation>[];
  var _inProgressReservationList = <Reservation>[];
  var _toAcceptReservationList = <Reservation>[];

  void onTapReservation(int id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReservationDetailScreen(id: id)),
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    _loadHostReservations();
  }

  void _loadHostReservations() async {
    final reservations = await ReservationService.getReservationsByHostId(
        await preferences.getUserId());

    final toAcceptReservations = reservations
        .where((reservation) => reservation.status == ReservationStatus.pending)
        .toList();

    final inProgressReservations = reservations
        .where(
            (reservation) => reservation.status == ReservationStatus.inProgress)
        .toList();

    final incomingReservations = reservations
        .where(
            (reservation) => reservation.status == ReservationStatus.approved)
        .toList();

    final pastReservations = reservations
        .where((reservation) =>
            reservation.status == ReservationStatus.completed ||
            reservation.status == ReservationStatus.cancelled)
        .toList();

    setState(() {
      _reservationsList = reservations;
      _incomingReservationsList = incomingReservations;
      _pastReservationsList = pastReservations;
      _inProgressReservationList = inProgressReservations;
      _toAcceptReservationList = toAcceptReservations;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Tus reservas entrantes",
            style: theme.textTheme.titleMedium,
          ),
          backgroundColor: Colors.white,
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: "Por aceptar"),
              Tab(text: "En progreso"),
              Tab(text: "Próximas"),
              Tab(text: "Pasadas"),
            ],
          ),
        ),
        body: TabBarView(children: [
          _loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _toAcceptReservationList.length,
                  itemBuilder: (context, index) {
                    final reservation = _toAcceptReservationList[index];

                    if (_toAcceptReservationList.isEmpty) {
                      return const Center(
                        child: Text("No tienes reservas por aceptar"),
                      );
                    }

                    return FutureBuilder(
                        future: ParkingService.getParkingById(
                            reservation.parkingId),
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return const SizedBox();
                          }
                          return ReservationCard(
                            id: reservation.id,
                            status: reservation.status,
                            address: snapshot.data!.location.address,
                            number: snapshot.data!.location.numDirection,
                            date: reservation.startTime,
                            startTime:
                                TimeOfDay.fromDateTime(reservation.startTime),
                            endTime:
                                TimeOfDay.fromDateTime(reservation.endTime),
                            onTapReservation: onTapReservation,
                          );
                        });
                  },
                ),
          _loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _inProgressReservationList.length,
                  itemBuilder: (context, index) {
                    final reservation = _inProgressReservationList[index];

                    return FutureBuilder(
                        future: ParkingService.getParkingById(
                            reservation.parkingId),
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return const SizedBox();
                          }
                          return ReservationCard(
                            id: reservation.id,
                            status: reservation.status,
                            address: snapshot.data!.location.address,
                            number: snapshot.data!.location.numDirection,
                            date: reservation.startTime,
                            startTime:
                                TimeOfDay.fromDateTime(reservation.startTime),
                            endTime:
                                TimeOfDay.fromDateTime(reservation.endTime),
                            onTapReservation: onTapReservation,
                          );
                        });
                  },
                ),
          _loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _incomingReservationsList.length,
                  itemBuilder: (context, index) {
                    final reservation = _incomingReservationsList[index];
                    return FutureBuilder(
                        future: ParkingService.getParkingById(
                            reservation.parkingId),
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return const SizedBox();
                          }
                          return ReservationCard(
                            id: reservation.id,
                            status: reservation.status,
                            address: snapshot.data!.location.address,
                            number: snapshot.data!.location.numDirection,
                            date: reservation.startTime,
                            startTime:
                                TimeOfDay.fromDateTime(reservation.startTime),
                            endTime:
                                TimeOfDay.fromDateTime(reservation.endTime),
                            onTapReservation: onTapReservation,
                          );
                        });
                  },
                ),
          _loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _pastReservationsList.length,
                  itemBuilder: (context, index) {
                    final reservation = _pastReservationsList[index];
                    return FutureBuilder(
                        future: ParkingService.getParkingById(
                            reservation.parkingId),
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return const SizedBox();
                          }
                          return ReservationCard(
                            id: reservation.id,
                            status: reservation.status,
                            address: snapshot.data!.location.address,
                            number: snapshot.data!.location.numDirection,
                            date: reservation.startTime,
                            startTime:
                                TimeOfDay.fromDateTime(reservation.startTime),
                            endTime:
                                TimeOfDay.fromDateTime(reservation.endTime),
                            onTapReservation: onTapReservation,
                          );
                        });
                  },
                ),
        ]),
      ),
    );
  }
}
