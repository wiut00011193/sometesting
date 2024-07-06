import '../../../domain/entity/response/signup_response_entity.dart';

class SignUpResponseModel extends SignUpResponseEntity {
  SignUpResponseModel({
    required super.accessToken,
    required super.refreshToken,
    required super.user,
  });

  factory SignUpResponseModel.fromJson(Map<String, dynamic> json) {
    return SignUpResponseModel(
      accessToken: json['access_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.phone,
    required super.firstName,
    required super.lastName,
    required super.department,
    required super.role,
    required super.isTeacher,
    required super.isBranchAdmin,
    required super.externalId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      phone: json['phone'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      department: json['department'] as int?,
      role: json['role'] as int?,
      isTeacher: json['is_teacher'] as bool?,
      isBranchAdmin: json['is_branch_admin'] as bool?,
      externalId: json['external_id'] as int?,
    );
  }
}
