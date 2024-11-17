import 'package:flutter/material.dart';
import 'package:homey_park/model/model.dart';
import 'package:homey_park/services/reservation_service.dart';
import 'package:homey_park/widgets/widgets.dart';

class ReservationDetailScreen extends StatefulWidget {
  final int id;

  const ReservationDetailScreen({super.key, required this.id});

  @override
  State<ReservationDetailScreen> createState() =>
      _ReservationDetailScreenState();
}

class _ReservationDetailScreenState extends State<ReservationDetailScreen> {
  bool _loading = true;

  late ReservationStatus _status;
  late DateTime _createdDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

  @override
  void initState() {
    super.initState();
    _fetchReservation();
  }

  void _fetchReservation() async {
    final reservation = await ReservationService.getReservationById(widget.id);

    setState(() {
      _loading = false;
      _status = reservation.status;
      _createdDate = reservation.createdAt;
      _startTime = TimeOfDay(
          hour: reservation.startTime.hour,
          minute: reservation.startTime.minute);
      _endTime = TimeOfDay(
          hour: reservation.endTime.hour, minute: reservation.endTime.minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    void showCancelAlertDialog() {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                title: Text("Cancelar reserva",
                    style: theme.textTheme.titleMedium),
                content: Text(
                  "¿Estas seguro de cancelar esta reserva? Esta acción es irreversible y no se mostrara tu publicación.",
                  style: theme.textTheme.bodyMedium
                      ?.apply(color: theme.colorScheme.onSurfaceVariant),
                ),
                actions: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context, 'Close');
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: theme.colorScheme.tertiary),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text("Cerrar",
                        style: TextStyle(color: theme.colorScheme.tertiary)),
                  ),
                  FilledButton(
                      onPressed: () {
                        Navigator.pop(context, 'Ok');
                        setState(() {
                          _status = ReservationStatus.cancelled;
                        });
                      },
                      style: FilledButton.styleFrom(
                        overlayColor: theme.colorScheme.error,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: theme.colorScheme.error),
                        ),
                        backgroundColor: theme.colorScheme.error,
                      ),
                      child: const Text("Cancelar")),
                ],
              ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detalles de reserva",
          style: theme.textTheme.titleMedium,
        ),
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: _loading
                ? Container()
                : ReservationBadgeStatus(status: _status),
          )
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CardWithHeader(
                      headerTextStr: "Horario",
                      body: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Creado:",
                              style: theme.textTheme.labelMedium
                                  ?.apply(color: theme.colorScheme.onSurface)),
                          Text(
                              "${_createdDate.day}/${_createdDate.month}/${_createdDate.year} ${_createdDate.hour.toString().padLeft(2, "0")}:${_createdDate.minute.toString().padLeft(2, "0")}:${_createdDate.second.toString().padLeft(2, "0")}",
                              style: theme.textTheme.bodySmall
                                  ?.apply(color: theme.colorScheme.onSurface)),
                          const SizedBox(height: 20),
                          Text("Horario de reserva:",
                              style: theme.textTheme.labelMedium
                                  ?.apply(color: theme.colorScheme.onSurface)),
                          Text(
                              "Desde: ${_startTime.format(context).toString()} - ${_createdDate.day}/${_createdDate.month}/${_createdDate.year}",
                              style: theme.textTheme.bodySmall
                                  ?.apply(color: theme.colorScheme.onSurface)),
                          Text(
                              "Hasta: ${_endTime.format(context).toString()} - ${_createdDate.day}/${_createdDate.month}/${_createdDate.year}",
                              style: theme.textTheme.bodySmall
                                  ?.apply(color: theme.colorScheme.onSurface)),
                        ],
                      )),
                  const SizedBox(height: 16),
                  CardWithHeader(
                      headerTextStr: "Información adicional",
                      body: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.directions_car_outlined),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("B521C31",
                                      style: theme.textTheme.labelMedium?.apply(
                                        color: theme.colorScheme.onSurface,
                                      )),
                                  Text("Toyota Corolla",
                                      style: theme.textTheme.labelSmall?.apply(
                                          color: theme
                                              .colorScheme.onSurfaceVariant)),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Icon(Icons.credit_card),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("**** **** **** 4885",
                                      style: theme.textTheme.labelMedium?.apply(
                                        color: theme.colorScheme.onSurface,
                                      )),
                                  Text("MARCELO FABIAN GARRO VEGA",
                                      style: theme.textTheme.labelSmall?.apply(
                                          color: theme
                                              .colorScheme.onSurfaceVariant)),
                                ],
                              )
                            ],
                          ),
                        ],
                      )),
                  const SizedBox(height: 16),
                  if (_status != ReservationStatus.cancelled)
                    CardWithHeader(
                      headerTextStr: "Cancelar reserva",
                      body: Column(children: [
                        Text(
                          "Puedes cancelar tu reserva hasta 6 horas antes de la hora programada para recibir un reembolso completo del pago realizado.",
                          style: theme.textTheme.bodySmall?.apply(
                              color: theme.colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: theme.colorScheme.error),
                              minimumSize: const Size(double.infinity, 40),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: showCancelAlertDialog,
                            child: Text(
                              "Cancelar reserva",
                              style: TextStyle(color: theme.colorScheme.error),
                            )),
                      ]),
                    ),
                ],
              ),
            ),
    );
  }
}
