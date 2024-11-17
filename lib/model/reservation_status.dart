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

ReservationStatus statusFromJson(String status) {
  const Map<String, ReservationStatus> statusMap = {
    "Cancelled": ReservationStatus.cancelled,
    "InProgress": ReservationStatus.inProgress,
    "Approved": ReservationStatus.approved,
    "Pending": ReservationStatus.pending,
    "Completed": ReservationStatus.completed,
  };

  return statusMap[status]!;
}
