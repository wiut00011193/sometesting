class SignUpResponseEntity {
  String? accessToken;
  String? refreshToken;
  UserEntity? user;

  SignUpResponseEntity({
    this.accessToken,
    this.refreshToken,
    this.user,
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
    this.id,
    this.phone,
    this.firstName,
    this.lastName,
    this.department,
    this.role,
    this.isTeacher,
    this.isBranchAdmin,
    this.externalId,
  });
}
