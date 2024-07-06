class LoginResponseEntity {
  String? accessToken;
  String? refreshToken;
  UserEntity? user;

  LoginResponseEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });
}

class UserEntity {
  int? id;
  String? phone;
  String? firstName;
  String? lastName;
  int? department;
  int? role;
  bool? isTeacher;
  bool? isBranchAdmin;
  int? externalId;

  UserEntity({
    required this.id,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.department,
    required this.role,
    required this.isTeacher,
    required this.isBranchAdmin,
    required this.externalId,
  });
}
