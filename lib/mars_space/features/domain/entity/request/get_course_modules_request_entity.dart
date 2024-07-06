import 'package:mars_it_app/mars_space/features/data/model/request/get_course_modules_request_model.dart';

class GetCourseModulesRequestEntity {
  int? courseId;

  GetCourseModulesRequestEntity({required this.courseId});

  Future<GetCourseModulesRequestModel> toModel() async {
    return GetCourseModulesRequestModel(courseId: courseId);
  }
}
