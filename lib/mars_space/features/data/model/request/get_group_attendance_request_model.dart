import 'package:mars_it_app/mars_space/features/domain/entity/request/get_group_attendance_request_entity.dart';

class GetGroupAttendanceRequestModel extends GetGroupAttendanceRequestEntity {
  GetGroupAttendanceRequestModel({
    required super.groupId,
    required super.fromDate,
    required super.tillDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'from_date': fromDate,
      'till_date': tillDate,
      'all': false,
    };
  }
}
