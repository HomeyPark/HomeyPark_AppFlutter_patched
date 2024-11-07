import 'package:flutter/material.dart';
import 'package:homey_park/screens/home_screen.dart';
import 'package:homey_park/widgets/widgets.dart';
import 'package:homey_park/model/model.dart';

class CheckoutScreen extends StatefulWidget {
  final Parking parking;
  const CheckoutScreen({super.key, required this.parking});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _dateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();

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

  @override
  void initState() {
    super.initState();
    _startTimeController.addListener(_calculateTotalFare);
    _endTimeController.addListener(_calculateTotalFare);
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
        _endTimeController.text.isEmpty) {
      return false;
    }
    return true;
  }

  void registerService() {
    if (!_validateForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, complete todos los campos"),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("**** **** **** 4885",
                          style: theme.textTheme.labelMedium?.apply(
                            color: theme.colorScheme.onSurface,
                          )),
                      Text("MARCELO FABIAN GARRO VEGA",
                          style: theme.textTheme.labelSmall?.apply(
                              color: theme.colorScheme.onSurfaceVariant)),
                    ],
                  )
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("B521C31",
                          style: theme.textTheme.labelMedium?.apply(
                            color: theme.colorScheme.onSurface,
                          )),
                      Text("Toyota Corolla",
                          style: theme.textTheme.labelSmall?.apply(
                              color: theme.colorScheme.onSurfaceVariant)),
                    ],
                  )
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
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.onSurface.withOpacity(0.1),
              blurRadius: 16,
            ),
          ],
        ),
        width: double.infinity,
        child: FilledButton(
          onPressed: registerService,
          style: ButtonStyle(
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          child: const Text("Pagar y reservar"),
        ),
      ),
    );
  }
}
