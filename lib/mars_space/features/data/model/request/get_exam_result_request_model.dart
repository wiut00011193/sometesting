import 'package:mars_it_app/injection_handler.dart';
import 'package:mars_it_app/mars_space/core/local_db/shared_pref.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/get_exam_result_request_entity.dart';

class GetExamResultRequestModel extends GetExamResultRequestEntity {
  GetExamResultRequestModel({
    required super.groupId,
    required super.module,
  });

  Future<Map<String, dynamic>> toJson() async {
    studentId = await di.get<MySharedPref>().getStudentModmeId();
    
    return {
      'group_id': groupId,
      'module': module,
      'student_id': studentId,
    };
  }
}
