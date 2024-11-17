import 'package:flutter/material.dart';
import 'package:homey_park/config/pref/preferences.dart';
import 'package:homey_park/model/model.dart';
import 'package:homey_park/model/reservation.dart';
import 'package:homey_park/screens/reservation_detail_screen.dart';
import 'package:homey_park/services/parking_service.dart';
import 'package:homey_park/services/reservation_service.dart';
import 'package:homey_park/widgets/widgets.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  var _loading = true;
  var _reservationsList = <Reservation>[];

  var _incomingReservationsList = <Reservation>[];
  var _pastReservationsList = <Reservation>[];
  var _inProgressReservationList = <Reservation>[];

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
    _loadGuestReservations();
  }

  void _loadGuestReservations() async {
    final reservations = await ReservationService.getReservationsByGuestId(
        await preferences.getUserId());

    final incomingReservations = reservations
        .where((reservation) =>
            reservation.status == ReservationStatus.pending ||
            reservation.status == ReservationStatus.approved)
        .toList();

    final pastReservations = reservations
        .where((reservation) =>
            reservation.status == ReservationStatus.completed ||
            reservation.status == ReservationStatus.cancelled)
        .toList();

    final inProgressReservations = reservations
        .where(
            (reservation) => reservation.status == ReservationStatus.inProgress)
        .toList();

    setState(() {
      _reservationsList = reservations;
      _incomingReservationsList = incomingReservations;
      _pastReservationsList = pastReservations;
      _inProgressReservationList = inProgressReservations;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      initialIndex: 0,
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
          _loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ..._inProgressReservationList.map((reservation) {
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
                                startTime: TimeOfDay.fromDateTime(
                                    reservation.startTime),
                                endTime:
                                    TimeOfDay.fromDateTime(reservation.endTime),
                                onTapReservation: onTapReservation,
                              );
                            });
                      }),
                    ],
                  ),
                ),
          _loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ..._incomingReservationsList.map((reservation) {
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
                                startTime: TimeOfDay.fromDateTime(
                                    reservation.startTime),
                                endTime:
                                    TimeOfDay.fromDateTime(reservation.endTime),
                                onTapReservation: onTapReservation,
                              );
                            });
                      }),
                    ],
                  ),
                ),
          _loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ..._pastReservationsList.map((reservation) {
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
                                startTime: TimeOfDay.fromDateTime(
                                    reservation.startTime),
                                endTime:
                                    TimeOfDay.fromDateTime(reservation.endTime),
                                onTapReservation: onTapReservation,
                              );
                            });
                      }),
                    ],
                  ),
                ),
        ]),
      ),
    );
  }
}
