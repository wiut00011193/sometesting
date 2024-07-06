import '../../../domain/entity/response/attendance_response_entity.dart';

class AttendanceResponseModel extends AttendanceResponseEntity {
  AttendanceResponseModel({
    required super.attendanceType,
    required super.attendDate,
  });

  factory AttendanceResponseModel.fromJson(Map<String, dynamic> json) {
    return AttendanceResponseModel(
      attendDate: json['attend_date'] as String?,
      attendanceType: json['attendance_type'] as int?,
    );
  }
}
