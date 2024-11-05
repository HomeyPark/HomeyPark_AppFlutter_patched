import 'package:flutter/material.dart';
import 'package:homey_park/model/model.dart';
import 'package:homey_park/widgets/widgets.dart';

class ReservationCard extends StatelessWidget {
  final int id;
  final String address;
  final String number;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final ReservationStatus status;
  final Function(int)? onTapReservation;

  const ReservationCard({
    super.key,
    required this.id,
    required this.address,
    required this.number,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.onTapReservation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final dateStr = "$day/$month/${date.year}";

    return GestureDetector(
      onTap: () {
        onTapReservation?.call(id);
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        shadowColor: theme.colorScheme.primary.withOpacity(0.6),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("$address $number",
                          style: theme.textTheme.bodyLarge
                              ?.apply(color: theme.colorScheme.onSurface)),
                      Text("#${id.toString().padLeft(7, "0")}",
                          style: theme.textTheme.bodyMedium?.apply(
                              color: theme.colorScheme.onSurfaceVariant))
                    ],
                  ),
                  const Spacer(),
                  ReservationBadgeStatus(status: status),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(248, 249, 250, 1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Text("Desde:",
                          style: theme.textTheme.bodySmall
                              ?.apply(color: theme.colorScheme.onSurface)),
                      const SizedBox(width: 12),
                      Text("${startTime.format(context).toString()} - $dateStr",
                          style: theme.textTheme.bodySmall
                              ?.apply(color: theme.colorScheme.onSurface)),
                    ],
                  )),
              const SizedBox(height: 4),
              Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(248, 249, 250, 1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Text("Hasta:",
                          style: theme.textTheme.bodySmall
                              ?.apply(color: theme.colorScheme.onSurface)),
                      const SizedBox(width: 12),
                      Text("${endTime.format(context).toString()} - $dateStr",
                          style: theme.textTheme.bodySmall
                              ?.apply(color: theme.colorScheme.onSurface)),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
