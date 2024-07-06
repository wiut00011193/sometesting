import 'package:mars_it_app/injection_handler.dart';
import 'package:mars_it_app/mars_space/core/local_db/shared_pref.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/get_month_attendance_request_entity.dart';

class GetMonthAttendanceRequestModel extends GetMonthAttendanceRequestEntity {
  GetMonthAttendanceRequestModel({
    required super.fromDate,
    required super.tillDate,
  });

  Future<Map<String, dynamic>> toJson() async {
    studentId = await di.get<MySharedPref>().getStudentModmeId();
    return {
      'from_date': fromDate,
      'till_date': tillDate,
      'student_id': studentId,
    };
  }
}
