import 'package:mars_it_app/mars_space/features/domain/entity/request/get_course_modules_request_entity.dart';

class GetCourseModulesRequestModel extends GetCourseModulesRequestEntity {
  GetCourseModulesRequestModel({required super.courseId});

  Map<String, dynamic> toJson() {
    return {
      'course_id': courseId,
    };
  }
}