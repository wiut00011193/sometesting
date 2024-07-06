import 'package:mars_it_app/mars_space/features/domain/entity/response/search_student_response_entity.dart';

class SearchStudentResponseModel extends SearchStudentResponseEntity {
  SearchStudentResponseModel({
    required super.id,
    required super.externalId,
    required super.name,
    required super.profile,
  });

  factory SearchStudentResponseModel.fromJson(Map<String, dynamic> json) {
    return SearchStudentResponseModel(
      id: json['id'] as int?,
      externalId: json['external_id'] as int?,
      name: json['name'] as String?,
      profile: ProfileModel.fromJson(json['profile']),
    );
  }
}

class ProfileModel extends Profile {
  ProfileModel({required super.avatar});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(avatar: json['avatar'] as String?);
  }
}
