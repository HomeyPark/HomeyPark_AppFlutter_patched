import 'package:flutter/material.dart';
import 'package:homey_park/config/pref/preferences.dart';
import 'package:homey_park/model/card.dart';
import 'package:homey_park/model/reservation.dart';
import 'package:homey_park/model/reservation_dto.dart';
import 'package:homey_park/model/vehicle.dart';
import 'package:homey_park/screens/home_screen.dart';
import 'package:homey_park/services/reservation_service.dart';
import 'package:homey_park/widgets/checkout/payment_select_dialog.dart';
import 'package:homey_park/widgets/checkout/vehicle_select_dialog.dart';
import 'package:homey_park/widgets/widgets.dart';
import 'package:homey_park/model/model.dart';

class CheckoutScreen extends StatefulWidget {
  final Parking parking;
  const CheckoutScreen({super.key, required this.parking});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

DateTime _combineDateAndTime(String date, String time) {
  final dateParts = date.split('/');
  final timeParts = time.split(' ')[0].split(':');
  final period = time.split(' ')[1];

  int hour = int.parse(timeParts[0]);
  final minute = int.parse(timeParts[1]);

  if (period == 'PM' && hour != 12) {
    hour += 12;
  } else if (period == 'AM' && hour == 12) {
    hour = 0;
  }

  return DateTime(
    int.parse(dateParts[2]),
    int.parse(dateParts[1]),
    int.parse(dateParts[0]),
    hour,
    minute,
  );
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _dateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  PaymentCard? _paymentCard = null;
  Vehicle? _vehicle = null;

  double totalFare = 0.0;

  void _calculateTotalFare() {
    if (_startTimeController.text.isEmpty || _endTimeController.text.isEmpty) {
      setState(() {
        totalFare = 0.0;
      });
      return;
    }

    final startTime = TimeOfDay(
      hour: int.parse(_startTimeController.text.split(":")[0]),
      minute: int.parse(_startTimeController.text.split(":")[1].split(" ")[0]),
    );

    final endTime = TimeOfDay(
      hour: int.parse(_endTimeController.text.split(":")[0]),
      minute: int.parse(_endTimeController.text.split(":")[1].split(" ")[0]),
    );

    final startDateTime = DateTime(0, 0, 0, startTime.hour, startTime.minute);
    final endDateTime = DateTime(0, 0, 0, endTime.hour, endTime.minute);

    final duration = endDateTime.difference(startDateTime).inMinutes;
    final hours = duration / 60;

    setState(() {
      totalFare =
          double.parse((hours * widget.parking.price).toStringAsFixed(2));
    });
  }

  void _submitReservationRequest() async {
    if (!_validateForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, complete todos los campos"),
        ),
      );
      return;
    }

    final guestId = await preferences.getUserId();

    final reservation = ReservationDto(
      hoursRegistered: totalFare.toInt(),
      totalFare: totalFare,
      startTime:
          _combineDateAndTime(_dateController.text, _startTimeController.text)
              .toIso8601String(),
      endTime:
          _combineDateAndTime(_dateController.text, _endTimeController.text)
              .toIso8601String(),
      guestId: guestId,
      hostId: widget.parking.user.id,
      parkingId: widget.parking.id,
      vehicleId: _vehicle!.id!,
      cardId: _paymentCard!.id!,
    );

    print("DEBUG");

    print(reservation.toJson());

    await ReservationService.createReservation(reservation);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (picked == null) return;

    setState(() {
      final day = picked.day.toString().padLeft(2, '0');
      final month = picked.month.toString().padLeft(2, '0');
      _dateController.text = "$day/$month/${picked.year}";
    });
  }

  Future<void> _selectTime(TextEditingController controller) async {
    final timeOfDay =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (timeOfDay == null) return;

    setState(() {
      controller.text = timeOfDay.format(context).toString();
    });
  }

  bool _validateForm() {
    if (_dateController.text.isEmpty ||
        _startTimeController.text.isEmpty ||
        _endTimeController.text.isEmpty ||
        _paymentCard == null ||
        _vehicle == null) {
      return false;
    }
    return true;
  }

  Future _showPaymentOptionsDialog() async {
    PaymentCard? selectedCard = await showDialog(
        context: context, builder: (context) => const PaymentSelectDialog());

    if (selectedCard == null) return;

    setState(() {
      _paymentCard = selectedCard;
    });
  }

  Future _showVehicleOptionsDialog() async {
    Vehicle? selectedVehicle = await showDialog(
        context: context, builder: (context) => const VehicleSelectDialog());

    if (selectedVehicle == null) return;

    setState(() {
      _vehicle = selectedVehicle;
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimeController.addListener(_calculateTotalFare);
    _endTimeController.addListener(_calculateTotalFare);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Checkout",
          style: theme.textTheme.titleMedium,
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CardWithHeader(
              headerTextStr: "Horario",
              body: Column(
                children: [
                  TextField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                      label: Text("Fecha"),
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.today),
                    ),
                    readOnly: true,
                    onTap: () {
                      _selectDate();
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _startTimeController,
                          decoration: const InputDecoration(
                            label: Text("Hora inicio"),
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(),
                          ),
                          readOnly: true,
                          onTap: () {
                            _selectTime(_startTimeController);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _endTimeController,
                          decoration: const InputDecoration(
                            label: Text("Hora fin"),
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(),
                          ),
                          readOnly: true,
                          onTap: () {
                            _selectTime(_endTimeController);
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            CardWithHeader(
              headerTextStr: "Medio de pago",
              body: Row(
                children: [
                  const Icon(Icons.credit_card),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_paymentCard != null) ...[
                          Text(
                              "**** **** **** ${_paymentCard?.numCard.toInt().toString().substring(12)}",
                              style: theme.textTheme.labelMedium?.apply(
                                color: theme.colorScheme.onSurface,
                              )),
                          Text(_paymentCard?.holder.toUpperCase() ?? "",
                              style: theme.textTheme.labelSmall?.apply(
                                  color: theme.colorScheme.onSurfaceVariant)),
                        ] else
                          Text("Seleccionar tarjeta",
                              style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: _showPaymentOptionsDialog,
                      icon: const Icon(Icons.edit))
                ],
              ),
            ),
            const SizedBox(height: 16),
            CardWithHeader(
              headerTextStr: "Vehículo",
              body: Row(
                children: [
                  const Icon(Icons.directions_car_outlined),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_vehicle != null) ...[
                          Text(_vehicle?.licensePlate ?? "",
                              style: theme.textTheme.labelMedium?.apply(
                                color: theme.colorScheme.onSurface,
                              )),
                          Text(_vehicle?.brand ?? "",
                              style: theme.textTheme.labelSmall?.apply(
                                  color: theme.colorScheme.onSurfaceVariant)),
                        ] else
                          Text("Seleccionar vehículo",
                              style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: _showVehicleOptionsDialog,
                      icon: const Icon(Icons.edit))
                ],
              ),
            ),
            const SizedBox(height: 16),
            CardWithHeader(
                headerTextStr: "Resumen",
                body: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tarifa total",
                          style: theme.textTheme.labelMedium?.apply(
                              color: theme.colorScheme.onSurfaceVariant),
                        ),
                        Text(
                            (_startTimeController.text.isEmpty ||
                                    _endTimeController.text.isEmpty)
                                ? "---"
                                : "S/ ${totalFare.toStringAsFixed(2)}",
                            style: theme.textTheme.labelMedium?.apply(
                                color: theme.colorScheme.onSurfaceVariant))
                      ],
                    )
                  ],
                )),
          ],
        ),
      ),
      persistentFooterButtons: [
        FilledButton.icon(
          onPressed: _submitReservationRequest,
          icon: const Icon(Icons.add),
          style: ButtonStyle(
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              minimumSize:
                  WidgetStateProperty.all(const Size(double.infinity, 48))),
          label: const Text("Pagar y reservar"),
        ),
      ],
    );
  }
}
