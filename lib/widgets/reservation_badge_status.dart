import 'package:flutter/material.dart';
import 'package:homey_park/model/model.dart';

class ReservationBadgeStatus extends StatelessWidget {
  final ReservationStatus status;

  const ReservationBadgeStatus({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final badgeStatusColor = switch (status) {
      ReservationStatus.cancelled => theme.colorScheme.error,
      ReservationStatus.inProgress => const Color.fromRGBO(252, 196, 25, 1),
      ReservationStatus.approved => const Color.fromRGBO(34, 139, 230, 1),
      ReservationStatus.pending => const Color.fromRGBO(133, 142, 150, 1),
      ReservationStatus.completed => theme.colorScheme.primary,
    };

    return Container(
      decoration: BoxDecoration(
        color: badgeStatusColor,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Text(statusText(status),
          style: theme.textTheme.bodySmall?.apply(color: Colors.white)),
    );
  }
}
