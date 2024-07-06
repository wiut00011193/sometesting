import 'package:mars_it_app/mars_space/features/domain/entity/response/get_course_modules_response_entity.dart';

class GetCourseModulesResponseModel extends GetCourseModulesResponseEntity {
  GetCourseModulesResponseModel({required super.modules});

  factory GetCourseModulesResponseModel.fromJson(Map<String, dynamic> json) {
    return GetCourseModulesResponseModel(modules: json['modules'] as int?);
  }
}