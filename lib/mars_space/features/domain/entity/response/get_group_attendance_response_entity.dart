class GetGroupAttendanceResponseEntity {
  List<Day>? days;

  GetGroupAttendanceResponseEntity({this.days});
}

class Day {
  String? date;
  Holiday? holiday;

  Day({
    this.date,
    this.holiday,
  });
}

class Holiday {
  String? title;

  Holiday({this.title});
}
