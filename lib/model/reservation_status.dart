enum ReservationStatus {
  cancelled,
  inProgress,
  approved,
  pending,
  completed,
}

String statusText(ReservationStatus status) {
  const Map<ReservationStatus, String> statusText = {
    ReservationStatus.cancelled: "Cancelada",
    ReservationStatus.inProgress: "En progreso",
    ReservationStatus.approved: "Aprobada",
    ReservationStatus.pending: "Pendiente",
    ReservationStatus.completed: "Completada",
  };

  return statusText[status]!;
}
