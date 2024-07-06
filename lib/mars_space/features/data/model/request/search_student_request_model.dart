import 'package:mars_it_app/mars_space/features/domain/entity/request/search_student_request_entity.dart';

class SearchStudentRequestModel extends SearchStudentRequestEntity {
  SearchStudentRequestModel({
    required super.externalId,
    required super.page,
    required super.perPage,
  });

  Map<String, dynamic> toJson() {
    return {
      'external_id': externalId,
      'page': page,
      'per_page': perPage,
      'with_profile': true,
    };
  }
}
