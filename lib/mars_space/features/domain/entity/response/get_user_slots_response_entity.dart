class GetUserSlotsResponseEntity {
  String? date;
  String? dayOfWeek;
  List<Slot>? slot;

  GetUserSlotsResponseEntity({
    required this.date,
    required this.dayOfWeek,
    required this.slot,
  });
}

class Slot {
  int? id;
  String? fromHour;
  String? tillHour;
  bool? isActive;

  Slot({
    required this.id,
    required this.fromHour,
    required this.tillHour,
    required this.isActive,
  });
}
