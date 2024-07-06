import 'package:mars_it_app/mars_space/features/domain/entity/request/get_profile_request_entity.dart';

class GetProfileRequestModel extends GetProfileRequestEntity {
  GetProfileRequestModel({
    required super.studentId,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
    };
  }
}