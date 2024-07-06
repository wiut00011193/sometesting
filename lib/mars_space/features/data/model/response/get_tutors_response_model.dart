import 'package:mars_it_app/mars_space/features/domain/entity/response/get_tutors_response_entity.dart';

class GetTutorsResponseModel extends GetTutorsResponseEntity {
  GetTutorsResponseModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.position,
    required super.profile,
  });

  factory GetTutorsResponseModel.fromJson(Map<String, dynamic> json) {
    return GetTutorsResponseModel(
      id: json['id'] as int?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      position: json['position'] != null ? List<String>.from(json['position']) : null,
      profile: ProfileModel.fromJson(json['profile']),
    );
  }
}

class ProfileModel extends Profile {
  ProfileModel({
    required super.id,
    required super.avatar,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as int?,
      avatar: json['avatar'] as String?,
    );
  }
}
