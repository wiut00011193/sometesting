import 'package:mars_it_app/mars_space/features/domain/entity/response/get_group_attendance_response_entity.dart';

class GetGroupAttendanceResponseModel extends GetGroupAttendanceResponseEntity {
  GetGroupAttendanceResponseModel({required super.days});

  factory GetGroupAttendanceResponseModel.fromJson(Map<String, dynamic> json) {
    return GetGroupAttendanceResponseModel(
      days: json['days'] != null
          ? List<Day>.from(json['days'].map((x) => DayModel.fromJson(x)))
          : null,
    );
  }
}

class DayModel extends Day {
  DayModel({
    required super.date,
    required super.holiday,
  });

  factory DayModel.fromJson(Map<String, dynamic> json) {
    return DayModel(
      date: json['date'] as String?,
      holiday: json['holiday'] != null
          ? HolidayModel.fromJson(json['holiday'])
          : null,
    );
  }
}

class HolidayModel extends Holiday {
  HolidayModel({required super.title});

  factory HolidayModel.fromJson(Map<String, dynamic> json) {
    return HolidayModel(title: json['title'] as String?);
  }
}
