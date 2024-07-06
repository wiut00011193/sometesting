import 'package:mars_it_app/injection_handler.dart';
import 'package:mars_it_app/mars_space/core/local_db/shared_pref.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/get_course_element_request_entity.dart';

class GetCourseElementRequestModel extends GetCourseElementRequestEntity {
  GetCourseElementRequestModel({
    required super.groupId,
    required super.courseElementId,
  });

  Future<Map<String, dynamic>> toJson() async {
    studentId = await di.get<MySharedPref>().getStudentModmeId();

    return {
      'student_id': studentId,
      'group_id': groupId,
      'course_element_id': courseElementId,
    };
  }
}
