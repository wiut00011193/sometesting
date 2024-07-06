import 'package:mars_it_app/mars_space/features/data/model/request/get_group_attendance_request_model.dart';

class GetGroupAttendanceRequestEntity {
  int? groupId;
  String? fromDate;
  String? tillDate;

  GetGroupAttendanceRequestEntity({
    required this.groupId,
    required this.fromDate,
    required this.tillDate,
  });

  Future<GetGroupAttendanceRequestModel> toModel() async {
    return GetGroupAttendanceRequestModel(
      groupId: groupId,
      fromDate: fromDate,
      tillDate: tillDate,
    );
  }
}
