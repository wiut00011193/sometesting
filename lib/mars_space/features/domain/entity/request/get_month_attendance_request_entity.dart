import 'package:mars_it_app/mars_space/features/data/model/request/get_month_attendance_request_model.dart';

class GetMonthAttendanceRequestEntity {
  String? fromDate;
  String? tillDate;
  int? studentId;

  GetMonthAttendanceRequestEntity({
    required this.fromDate,
    required this.tillDate,
  });

  Future<GetMonthAttendanceRequestModel> toModel() async {
    return GetMonthAttendanceRequestModel(
      fromDate: fromDate,
      tillDate: tillDate,
    );
  }
}
