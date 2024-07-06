import 'package:mars_it_app/injection_handler.dart';
import 'package:mars_it_app/mars_space/core/local_db/shared_pref.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/get_course_elements_request_entity.dart';

class GetCourseElementsRequestModel extends GetCourseElementsRequestEntity {
  GetCourseElementsRequestModel({
    required super.courseId,
    required super.module,
  });

  Future<Map<String, dynamic>> toJson() async {
    studentId = await di.get<MySharedPref>().getStudentModmeId();
    
    return {
      'student_id': studentId,
      'course_id': courseId,
      'module': module,
    };
  }
} 