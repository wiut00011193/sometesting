class GetExtraLessonsResponseEntity {
  String? forDate;
  List<Data>? data;

  GetExtraLessonsResponseEntity({
    required this.forDate,
    required this.data,
  });
}

class Data {
  int? id;
  Tutor? tutor;
  Slot? slot;
  String? comment;
  String? status;
  String? theme;
  int? mark;

  Data({
    required this.id,
    required this.tutor,
    required this.slot,
    required this.comment,
    required this.status,
    required this.theme,
    required this.mark,
  });
}

class Tutor {
  int? id;
  String? firstName;
  String? lastName;

  Tutor({
    required this.id,
    required this.firstName,
    required this.lastName,
  });
}

class Slot {
  int? id;
  String? fromHour;
  String? tillHour;
  bool? isBooked;

  Slot({
    required this.id,
    required this.fromHour,
    required this.tillHour,
    required this.isBooked,
  });
}
